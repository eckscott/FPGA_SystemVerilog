/***************************************************************************************
* 
* Filename: codebreaker.sv
*
* Author: Ethan Scott
* Description: This is the top level codebreaker module used to connect the codebreaker
*              module with the BASYS3 FPGA
*
***************************************************************************************/
module codebreaker_top #(FILENAME="", CLK_FREQUENCY=100_000_000, BAUD_RATE=19_200,
                         WAIT_TIME_US=5_000, REFRESH_RATE=200, FOREGROUND_COLOR=12'hfff,
                         BACKGROUND_COLOR=12'h000)(
    // Determine which byte to display
    input logic[2:0] sw,
    // System clk, reset, start codebreak, display ciphertext on 7seg display,
    // display plain text on 7seg display, UART receiver input
    input logic clk, btnd, btnc, btnl, btnr, rx_in,
    
    // display lower 8 bits of cipher text
    output logic[7:0] led,
    // RGB color signals
    output logic[3:0] vgaRed, vgaGreen, vgaBlue,
    // anode and cathode signals for seven seg display
    output logic[3:0] anode, output logic[7:0] segment,
    // horizontal sync, vertical sync, codebreaker error sig
    output logic Hsync, Vsync, error);

    // sync signals for rst btnd and switches
    logic rst_sync, rst_sync1; logic[2:0] sw_sync;

    // sync signals for rx_in and ack signal to acknowledge reception of UART
    logic rx_in_sync, rx_in_sync1, ack;
    // signal used for output of uart receiver
    logic[7:0] rx_out;

    // register that stores ciphertext being decoded
    logic[127:0] ciphTxt = 128'ha13a3ab3071897088f3233a58d6238bb;
    // final key val outputted by codebreaker and plainTxt generated
    logic[23:0] keyCorrect, logic[127:0] plainTxt;
    // done signal to indicate encryption/decryption process finished
    logic codeBreakDone;

    // data displayed on the seven-segment display
    logic[15:0] sevenSegData;
    // synced signals to display ciphertext and plain text on 7seg display
    logic ciphTxtDisp_sync, ciphTxtDisp_sync1, plainTxtDisp_sync, plainTxtDisp_sync1;

    // 2 flip flop synchronizer for reset signal
    always_ff @(posedge clk) begin
        rst_sync1 <= btnd;
        rst_sync <= rst_sync1;
    end
    // synchronizer for switch values
    always_ff @(posedge clk) begin
        sw_sync <= sw;
    end

    /*****************************************************
    *                 UART RECEIVER                      *
    *****************************************************/
 
 
    // 2 flip flop synchronizer for rx_in signal
    always_ff @(posedge clk) begin
        rx_in_sync1 <= rx_in;
        rx_in_sync <= rx_in_sync1;
    end

    // This UART Receiver module is used to receive the ciphertext from the computer.
    // It connects top level parameters to its params, rx_out as the output of the
    // UART Receiver, ack as the receive acknowledge signal, btnd as the reset,
    // and the synced rx_in signal as the input Sin signal
    rx #(.CLK_FREQUENCY(CLK_FREQUENCY), .BAUD_RATE(BAUD_RATE)) UARTReceiver(
         .Dout(rx_out), .Receive(ack), .parityErr(), .clk(clk), .rst(rst_sync),
         .Sin(rx_in_sync), .ReceiveAck(ack));

    // fill bottom byte of ciphTxt with output of UART receiver so that it can be filled
    // with 16 bytes from the UART Receiver
    assign ciphTxt = {ciphTxt[119:0], rx_out};

    
    /*****************************************************
    *                 CODE BREAKER                       *
    *****************************************************/


    // This codebreaker module takes a cipherTxt as an input and generates a plainTxt
    // as an output once it finds a key that can decipher the code. It raises a signal
    // 'codeBreakDone' once it finishes deciphering, or a signal 'error' if it couldn't
    // crack the code. Runs through this process on the raising of the start signal
    codebreaker codeBreak(.bytes_in(ciphTxt), .clk(clk), .reset(rst_sync), .start(),
                          .bytes_out(plainTxt), .key(keyCorrect), .done(codeBreakDone),
                          .error(error));


    /*****************************************************
    *             SEVEN SEGMENT DISPLAY                  *
    *****************************************************/


    // synchronizer for btnl
    always_ff @(posedge clk) begin
        ciphTxtDisp_sync1 <= btnl;
        ciphTxtDisp_sync <= ciphTxtDisp_sync1;
    end
    // synchronizer for btnr
    always_ff @(posedge clk) begin
        plainTxtDisp_sync1 <= btnr;
        plainTxtDisp_sync <= plainTxtDisp_sync1;
    end

    // This seven segment display module displays the current key, ciphertext, and the
    // plain text on the seven segment display depending on which button is pushed
    seven_segment4 sevenSegDisp(.segment(segment), .anode(anode), .data_in(sevenSegData),
                                .blank(), .dp_in(), .rst(rst_sync), .clk(clk));

    always_comb begin
        if (ciphTxtDisp_sync) begin
            case (sw_sync)
                3'b000: sevenSegData = ciphTxt[15:0];
                3'b001: sevenSegData = ciphTxt[31:16];
                3'b010: sevenSegData = ciphTxt[47:32];
                3'b011: sevenSegData = ciphTxt[63:48];
                3'b100: sevenSegData = ciphTxt[79:64];
                3'b101: sevenSegData = ciphTxt[95:80];
                3'b110: sevenSegData = ciphTxt[111:96];
                3'b111: sevenSegData = ciphTxt[127:112];
            endcase
        end
    end

endmodule