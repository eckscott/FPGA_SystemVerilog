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

    cnt CountMod(clk, rst, en, up, load, count_in, count);

    initial begin
        
    end

endmodule
