//////////////////////////////////////////////////////////////////////////////////
//
//  Filename: tb_regfile.sv
//
//  Author: Ethan Scott
//  Description: 
//
//////////////////////////////////////////////////////////////////////////////////

module tb_cnt.sv();

    logic clk, rst, en, up, load;
    logic[3:0] count_in, count;
    int i, errors;

    cnt DUT(clk, rst, en, up, load, count_in, count);

    function void 

    initial begin
        #100ns;
        clk = 0;
        forever begin
            #5ns clk = ~clk;
        end
        #100ns;
    end
    // test functionality of reset
    initial begin
        // initial values for testing
        rst = 0;
        en = 0;
        up = 0;
        load = 0;
        errors = 0;
        // wait 4 clock cycles
        repeat(4) @(negedge clk);
        // Issue a reset for a few clock cycles and release the reset
        rst = 1;
        repeat(4) @(negedge clk);
        rst = 0;
    end
    // test counting functionality
    initial begin
        en = 1;
        up = 1;
        for (i=0; i < 16; i=i+1) begin
            if (count != i) begin
                $display("ERROR: Incorrect count val. Should be '%1d' but is '%1d' at time %0t", i, count, $time);
                errors = errors + 1;
            end
            @(negedge clk);
        end 
        if (count != 0)
            $display("ERROR: Failed to roll back to 0. Count should be '0' but is '%1d' at time %0t, count, $time);
        else
            $display("Test Roll back to 0: SUCCESS");
    end

endmodule
