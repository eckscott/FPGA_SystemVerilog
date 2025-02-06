/***************************************************************************
* 
* Filename: arithmetic_top.sv
*
* Author: Ethan Scott
* Description: instances my 8-bit adder and connects your adder to a button,
               the switches and LEDs
*
****************************************************************************/
module arithmetic_top( 
    output logic[8:0] led,                   //LEDs (led[8] = overflow, led[7:0] = sum)
    input logic[15:0] sw,                    //Switches (sw[15:8] = ‘b’, sw[7:0] = ‘a’ op)
    input logic btnc);                      //Center button (subtract when pressed)

    logic[7:0] b;                           //b buffer
    logic burner, abar, bbar, sbar, t1, t2;             

    //invert b if btnc is pushed
    xor(b[0], btnc, sw[8]);
    xor(b[1], btnc, sw[9]);
    xor(b[2], btnc, sw[10]);
    xor(b[3], btnc, sw[11]);
    xor(b[4], btnc, sw[12]);
    xor(b[5], btnc, sw[12]);
    xor(b[6], btnc, sw[13]);
    xor(b[7], btnc, sw[14]);

    //overflow detection
    not(bbar, b[7]);
    not(abar, sw[7]);
    not(sbar, led[7]);
    and(t1, abar, bbar, led[7]);      //overflow = (a[7]' b[7]' s[7]) + (a[7] b[7] s[7]')
    and(t2, sw[7], b[7], sbar);
    or(led[8], t1, t2);


    Add8 M0(.cin(btnc), .a(sw[7:0]), .co(burner), .b(b), .s(led[7:0]));

endmodule