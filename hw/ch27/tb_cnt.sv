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
        
    end

endmodule
