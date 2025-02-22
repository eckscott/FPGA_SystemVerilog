/***************************************************************************
* 
* Filename: regfile_top.sv
*
* Author: Ethan Scott
* Description: top-level module for regfile module
*
****************************************************************************/
module regfile_top(
    input logic [3:0] data_in,          // Data input (switches[3:0])
    input logic [2:0] addr,             // Register address (switches[15:13])
    input logic clk, btnc, btnd, btnr,  // write register file, clear register
                                        // file, turn off digits when pressed

    output logic [7:0] segment,         // cathode segments
    output logic [3:0] anode);          // anode signals for each of four digits

    logic [3:0] out;

    assign segment[7] = 1;
    assign anode[3:1] = 3'b111;
    assign anode[0] = btnr ? 1 : 0;

    regfile M0(.clk(clk), .load(btnc), .clr(btnd), .din(data_in), .addr(addr), .q(out));
    seven_segment M1(.data(out), .segment(segment[6:0]));

endmodule