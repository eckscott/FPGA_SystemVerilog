/***************************************************************************
* 
* Filename: regfile.sv
*
* Author: Ethan Scott
* Description: create a register file with 8 entries that will allow you to
* save eight different 4-bit numbers based using a 3-bit address to indicate
* which of the eight registers you want to read from or write to
*
****************************************************************************/
module regfile(
    output logic[3:0] q,            // register output
    
    input logic[3:0] din,           // Data to be loaded into register
    input logic[2:0] addr,          // Address to specify the register to read/load
    input logic clk, load, clr);    // Clock input, Control signal to cause
                                    // register to load, Control signal to
                                    // clear the contents of the register

    logic [3:0] q0, q1, q2, q3, q4,
                q5, q6, q7;
    logic [7:0] int_load;

    reg4 M0 (.q(q0), .clk(clk), .load(int_load[0]), .clr(clr), .din(din));
    reg4 M1 (.q(q1), .clk(clk), .load(int_load[1]), .clr(clr), .din(din));
    reg4 M2 (.q(q2), .clk(clk), .load(int_load[2]), .clr(clr), .din(din));
    reg4 M3 (.q(q3), .clk(clk), .load(int_load[3]), .clr(clr), .din(din));
    reg4 M4 (.q(q4), .clk(clk), .load(int_load[4]), .clr(clr), .din(din));
    reg4 M5 (.q(q5), .clk(clk), .load(int_load[5]), .clr(clr), .din(din));
    reg4 M6 (.q(q6), .clk(clk), .load(int_load[6]), .clr(clr), .din(din));
    reg4 M7 (.q(q7), .clk(clk), .load(int_load[7]), .clr(clr), .din(din));

    assign q = (addr == 0) ? q0 : (addr == 1) ? q1 :
               (addr == 2) ? q2 : (addr == 3) ? q3 :
               (addr == 4) ? q4 : (addr == 5) ? q5 :
               (addr == 6) ? q6 : (addr == 7) ? q7 :
               0;

    assign int_load = ((addr == 0) && load) ? 1 :
                      ((addr == 1) && load) ? 2 :
                      ((addr == 2) && load) ? 4 :
                      ((addr == 3) && load) ? 8 :
                      ((addr == 4) && load) ? 16 :
                      ((addr == 5) && load) ? 32 :
                      ((addr == 6) && load) ? 64 :
                      ((addr == 7) && load) ? 128 :
                      00000000;
    
    
    
    

endmodule