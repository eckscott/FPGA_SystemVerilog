/* 
 Testbench for UART Transmitter Lab
 Author: Brent Nelson

Explanation:
1. First resets the user design and then starts sending.
2. Will look for start bit within first 10 cycles or will start throwing errors.
3. Will check for the start bit, data bits, parity bit, and stop bit and if any are incorrect will throw an error.
4. As it runs it narrates what it is looking for:
run 1000000ns
Testbench is requesting sending of byte 0xff by driving 'send' high at time 1181 ns
      and is now waiting for data to be transmitted and then handshaking signals to signal completion at time 1181 ns
   Signal 'sent' went high at time 574081 ns
   Testbench is driving 'send' low and is now waiting for 'sent' to go low... at time 574081 ns
   Signal 'sent' went low to complete handshake at time 574081 ns
   Done sending byte 0xff at time 574090 ns
... and so on ...

If there were bit errors, they would show up while testbench is waiting for 'sent' to go high since that is where the actual transmitting is taking place.

Issues with code in the book that students have to address:
1. Capitalization on some of the signals is wrong, like with signals  Send, Sent, Sout, and Reset.
2. The clrBit assertion on the transition from state START to BITS is simply missing from SV code. So, be aware of it.

*/

module tb_tx #(parameter CLK_FREQUENCY=100_000_000, parameter BAUD_RATE = 19_200);

   logic clk, send, sent, sout, reset;
   logic [7:0] din;
   int errors;
   int bitTime = CLK_FREQUENCY / BAUD_RATE;
   int halfBitTime = bitTime/2;

   // Instance the DUT
   tx  #(.CLK_FREQUENCY(CLK_FREQUENCY),.BAUD_RATE(BAUD_RATE)) 
      student_tx (.clk(clk), .rst(reset), .Send(send), .Din(din), .Sent(sent), .Sout(sout));

   // Clock
   initial begin
      #100ns; // wait 100 ns before starting clock (after inputs have settled)
      clk = 0;
      forever begin
         #5ns clk = ~clk;
      end
   end

   // Cycle delay
   task dla(int cycles = 1);
      repeat (cycles)
        @(negedge clk);
   endtask

   // Cycle delay plus 1 ns
   task sdla(int cycles = 1);
      dla(cycles);
      #1ns;  // To ensure driving is after monitoring
   endtask

   function void pmsg(input string msg);
      $display("%s at time %0t", msg, $time);
   endfunction // msg

   function void incErr(input string msg);
      pmsg(msg);
      errors += 1;
      if (errors > 10) begin
         pmsg("*** MAX ERROR COUNT of 10 exceeded: exiting");
         $display("*** Simulation done with %0d errors at time %0t ***", errors, $time);
         $finish;
      end
   endfunction // incErr

   task sendData(input logic [7:0] mdin);
      // Wait for a few negative edges of clock and then start setting inputs
      sdla(4);

      // 8 bits of data
      din = mdin;

      // send --> 1
      sdla(1);
      send = 1;
      pmsg($sformatf("Testbench is requesting sending of byte 0x%h by driving 'send' high", din));
      sdla(1);

      // Wait for sent --> 1
      while (sent != 1)
        dla();
      sdla(1);
      pmsg("   Signal 'sent' went high");

      // send --> 0
      send = 0;
      pmsg("   Testbench is driving 'send' low and is now waiting for 'sent' to go low...");

      // Wait for sent --> 0
      @(negedge sent);
      pmsg("   Signal 'sent' went low to complete handshake");
      dla(1);
      pmsg($sformatf("   Done sending byte 0x%h", mdin));
   endtask

   task chkTransfer(input logic [7:0] din);

      // Wait for start bit
      automatic int waitCnt = 0;
      while (sout != 0) begin
         waitCnt += 1;
         if (waitCnt > 10) begin
            incErr("*** ERROR: have been waiting > 10 cycles for a start bit to appear.  None found so far");
         end
         dla(1);
      end

      // Check start bit
      dla(halfBitTime);
      if (sout != 0)
        incErr($sformatf("*** ERROR: start bit should be low, it is %0d instead", sout));

      // Make sure start bit stays active long enough
      // This checks that the timer is being cleared at the beginning of send.
      dla(halfBitTime - 100);
      if (sout)
         incErr("*** ERROR: Sout went high, but start bit shouldn't be done yet");
      dla(halfBitTime + 100);

      // Check rest of bits
      for (int i=0;i<8;i++) begin
         if (sout != din[i])
           incErr($sformatf("*** ERROR: expecting bit %0d of %0x which is a %0d, got %0d instead", i, din, din[i], sout));
         dla(bitTime);
      end

      // Check parity bit
      if (~^din != sout)
        incErr($sformatf("*** ERROR: parity bit error, expected %0d, received %0d instead", ~^din, sout));

      // Check stop bit
      dla(bitTime);
      if (sout != 1)
        incErr($sformatf("*** ERROR: stop bit should be high, it is %0d instead", sout));

      // Get to end of stop bit
      dla(halfBitTime);
      // pmsg($sformatf("*** INFO: testbench done receiving data word consisting of 0x%0x", din));
   endtask

   // Fire up parallel tasks to drive and monitor at same time
   task doTransfer(input logic [7:0] din);
      fork
         sendData(din);
         chkTransfer(din);
      join
      // pmsg("Done with doTransfer");
   endtask

   // This function originally printed the message and exited.
   // This cause the simulator to hang in 2019.x versions.
   // Putting those statements in-line instead fixes it.
   // Later this could be reinstated as a call in the code.
   function void endSimulation();
      $display("*** Simulation done with %0d errors at time %0t ***", errors, $time);
      $finish;
   endfunction // endSimulation

   // Main test block
   initial begin

      errors = 0;
      //shall print %t with scaled in ns (-9), with 2 precision digits, and would print the " ns" string
      $timeformat(-9, 0, " ns", 20);
      $display("*** Start of Simulation ***");

      // Initial values
      send = 0;
      din = 0;
      reset = 0;

      // Do reset
      sdla(1);
      reset = 1;
      sdla(2);
      reset = 0;
      sdla(1);

      // Check that line initially idles high
      if (sout != 1)
        incErr($sformatf("*** ERROR: tx_out should start out as a '1' but it is a %0d", sout));
      else
         pmsg("tx_out started out as a '1'");

      // test some transfers
      dla(100);
      doTransfer(8'hff);

      dla(100);
      doTransfer(8'h00);

      dla(100);
      doTransfer(8'h0f);

      dla(100);
      doTransfer(8'hf0);

      // test odd number of bits
      dla(100);
      doTransfer(8'h37);

      dla(100);
      doTransfer(8'h73);

      dla(100);
      doTransfer(8'haa);

      dla(100);
      doTransfer(8'h55);

      $display("*** Simulation done with %0d errors at time %0t ***", errors, $time);
      $finish;

   end  // end initial begin

endmodule // tb
