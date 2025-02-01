/***************************************************************************
* 
* Filename: logic_functions.sv
*
* Author: Ethan Scott
* Description: 
*
****************************************************************************/
module logic_functions(
    output logic O1, O2, O3, O4,
    input logic A, B, C);

    logic abar, bbar, cbar, a1, a2, a3, a4, a5, a6, a7;

    //O1=AC+A'B
    not(abar, A);           //abar = A'
    and(a1, A, C);          //a1 = AC
    and(a2, abar, B);       //a2 = A'B
    or(O1, a1, a2);

    //O2=(A+C')(BC)
    not(cbar, C);           //cbar = C'
    or(a3, A, cbar);        //a3 = (A+C')
    and(a4, B, C);           //a4 = BC
    and(O2, a3, a4);

    //O3=AB'+C
    not(bbar, B);           //bbar = B'
    and(a5, A, bbar);       //a5 = AB'
    or(O3, a5, C);

    //O4=((AB)'(C'B')')'
    nand(a6, A, B);         //a6 = AB
    nand(a7, cbar, bbar);   //a7 = C'B'
    nand(O4, a6, a7);

endmodule


