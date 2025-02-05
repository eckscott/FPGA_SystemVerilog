/***************************************************************************
* 
* Filename: FullAdd.sv
*
* Author: Ethan Scott
* Description: A single-bit full adder module
*
****************************************************************************/
module FullAdd(
    output logic s, co,         //s=sum output      co=carry output
    input logic a, b, cin);     //cin=carry in

    logic i1, i2, i3;           //input 1, 2, and 3 of the final or gate
                                //to get the output of carry out

    and(i1, a, b);              //i1=ab
    and(i2, b, cin);            //i2=bcin
    and(i3, a, cin);            //i3=acin
    or(co, i1, i2, i3);         //co=i1+i2+i3

    xor(s, a, b, cin);          //s=a + b + cin


endmodule