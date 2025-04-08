//////////////////////////////////////////////////////////////////////////////////
//
//  Filename: tb_regfile.sv
//
//  Author: Ethan Scott
//  Description: 
//
//////////////////////////////////////////////////////////////////////////////////

module tb_cnt();

    logic clk, rst, en, up, load;
    logic[3:0] count_in, count, count_temp;
    int i, errors;

    cnt DUT(clk, rst, en, up, load, count_in, count);

    task setUp ();
        $display("Testing intial vals with reset at time %0t", $time);
        rst = 1;
        en = 0;
        up = 0;
        load = 1;
        errors = 0;
        count_in = 3;
        count_temp = 0;
        // wait 4 clock cycles
        repeat(2) @(negedge clk);
        rst = 0;
        en = 1;
        repeat(2) @(negedge clk);
        // Issue a reset for a few clock cycles and release the reset
        rst = 1;
        repeat(4) @(negedge clk);
        rst = 0;
        if (count != 0) begin
            $display("ERROR: Incorrect count val. Should be 0 but is %1d at time %0t", count, $time);
            errors = errors + 1;
        end
        else
            $display("SUCCESS: Correct count val. Should be 0 and is %1d at time %0t", count, $time);
        $display("Finished intial vals with reset at time %0t", $time);
    endtask

    task countUpTimes (int num_counts, int currCount);
        for (i=currCount; i < num_counts + 1; i=i+1) begin
            if (i > 15) begin
                if (count != i-16) begin
                    $display("ERROR: Incorrect count val. Should be %1d but is %1d at time %0t", i-16, count, $time);
                    errors = errors + 1;
                end
                else
                    $display("SUCCESS: Correct count val. Should be %1d and is %1d at time %0t", i-16, count, $time);
                @(negedge clk);
            end
            else begin
                if (count != i) begin
                    $display("ERROR: Incorrect count val. Should be %1d but is %1d at time %0t", i, count, $time);
                    errors = errors + 1;
                end
                else
                    $display("SUCCESS: Correct count val. Should be %1d and is %1d at time %0t", i, count, $time);
                @(negedge clk);
            end
        end 
    endtask

    task countDownTimes (int num_counts);
        for (i=num_counts; i >= 0; i=i-1) begin
            if (count != i) begin
                $display("ERROR: Incorrect count val. Should be %1d but is %1d at time %0t", i, count, $time);
                errors = errors + 1;
            end
            else
                $display("SUCCESS: Correct count val. Should be %1d and is %1d at time %0t", i, count, $time);
            @(negedge clk);
        end 
    endtask
    //check load signal precendence
    task checkPrecendence ();
        if (!rst && load)
            if (count != count_in) begin
                $display("ERROR: Incorrect count val. Should be %1d but is %1d at time %0t", count_in, count, $time);
                errors = errors + 1;
            end
            else
                $display("SUCCESS: Correct count val. Should be %1d and is %1d at time %0t", count_in, count, $time);       
    endtask
    //check the count only changes when enable is asserted
    task checkEnable(logic[3:0] currCount);
        count_temp = currCount;
        if (!en) begin
            @(negedge clk);
            if (count_temp != count) begin
                $display("ERROR: Incorrect count val. Should be %1d but is %1d at time %0t", count_temp, count, $time);
                errors = errors + 1;
            end
            else
                $display("SUCCESS: Correct count val. Should be %1d and is %1d at time %0t", count_temp, count, $time);   
        end
    endtask
    //test reset
    task checkReset();
        rst = 1;
        load = 0;
        up = 0;
        en = 0;
        rst = 1;
        repeat(4) @(negedge clk);
        rst = 0;
        if (count != 0) begin
            $display("ERROR: Incorrect count val. Should be 0 but is %1d at time %0t", count, $time);
            errors = errors + 1;
        end
        else
            $display("SUCCESS: Correct count val. Should be 0 and is %1d at time %0t", count, $time); 
    endtask
    // inital clock set up block
    initial begin
        #100ns;
        clk = 0;
        forever begin
            #5ns clk = ~clk;
        end
        #100ns;
    end
    
    // "main" block of code
    initial begin
        #200ns;
        $display("Set up inputs");
        setUp();
        $display("Finished set up. Test no count without enable");
        en = 0;
        load = 0;
        checkEnable(count);
        $display("Finished checkEnable. Test count up and roll over");
        // test counting functionality
        en = 1;
        up = 1;
        countUpTimes(20, count);
        $display("Finished count up and roll over. Begin count down");
        // test count down functionality
        // make sure can count down from 15
        up = 0;
        countDownTimes(count);
        countDownTimes(15);
        // test loading precendence
        $display("Finished count down. Begin load precedence");
        load = 1;
        up = 1;
        @(negedge clk);
        checkPrecendence();
        $display("Finished load precedence. Begin reset test");
        checkReset();
        $display("Test bench finished with %1d errors at time %0t",errors, $time);
        $finish;
    end

endmodule
