/***************************************************************************
* 
* Filename: Add8.sv
*
* Author: Ethan Scott
* Description: A multi-bit adder that combines eight single-bit adders 
*
****************************************************************************/
module Add8(
    output logic[7:0] s,    //s=sum output width 8
    output logic co,        //co=carry output
    input logic[7:0] a,
    input logic[7:0] b,       
    input logic cin);       //cin=carry in

    wire[6:0] c;            //carry signals between adders

    FullAdd F0(.a(a[0]), .b(b[0]), .cin(cin), .s(s[0]), .co(c[0])); 
    FullAdd F1(.a(a[1]), .b(b[1]), .cin(c[0]), .s(s[1]), .co(c[1]));
    FullAdd F2(.a(a[2]), .b(b[2]), .cin(c[1]), .s(s[2]), .co(c[2]));
    FullAdd F3(.a(a[3]), .b(b[3]), .cin(c[2]), .s(s[3]), .co(c[3]));
    FullAdd F4(.a(a[4]), .b(b[4]), .cin(c[3]), .s(s[4]), .co(c[4]));
    FullAdd F5(.a(a[5]), .b(b[5]), .cin(c[4]), .s(s[5]), .co(c[5]));
    FullAdd F6(.a(a[6]), .b(b[6]), .cin(c[5]), .s(s[6]), .co(c[6]));
    FullAdd F7(.a(a[7]), .b(b[7]), .cin(c[6]), .s(s[7]), .co(co));

endmodule