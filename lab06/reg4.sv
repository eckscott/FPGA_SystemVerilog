/***************************************************************************
* 
* Filename: reg4.sv
*
* Author: Ethan Scott
* Description: create a 4-bit register that can store 4-bit values
*
****************************************************************************/
module reg4(
    output logic[3:0] q,            // Register output

    input logic[3:0] din,           // Data to be loaded into register
    input logic clk, load, clr);    // clock input, control signal to cause
                                    // register to load, control signal to clear
                                    // the contents of the register

    //four FDCE flip-flops (one for each register bit)
    FDCE ff_0 (.Q(q[0]), .C(clk), .CE(load), .CLR(clr), .D(din[0]));
    FDCE ff_1 (.Q(q[1]), .C(clk), .CE(load), .CLR(clr), .D(din[1]));
    FDCE ff_2 (.Q(q[2]), .C(clk), .CE(load), .CLR(clr), .D(din[2]));
    FDCE ff_3 (.Q(q[3]), .C(clk), .CE(load), .CLR(clr), .D(din[3]));

endmodule