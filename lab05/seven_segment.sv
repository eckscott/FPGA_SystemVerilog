/***************************************************************************
* 
* Filename: seven_segment.sv
*
* Author: Ethan Scott
* Description: seven different combinational logic circuits where each
*              circuit drives one of the seven segments of the display
*
****************************************************************************/
module seven_segment(
    output logic[6:0] segment,  //Cathode signals for seven-segment display
                                //(excluding digit point). segment[0] 
                                //corresponds to CA and segment[6] corresponds
                                //to CG

    input logic[3:0] data);     //Data input to display on the seven-segment
                                //display

    logic A, B, C, D;           //used to understand data input more easily
    assign D = data[0];
    assign C = data[1];
    assign B = data[2];
    assign A = data[3];
    /////////////////
    // Segment A = A'B'C'D +  A'BC'D' + ABC'D + AB'CD
    /////////////////
    assign segment[0] = (!A && !B && !C && D) ||
                        (!A && B && !C && !D) ||
                        (A && B && !C && D)   ||
                        (A && !B && C && D);
    /////////////////
    // Segment B = (A+B)(B+C)(B+C+D)(A+B'+C+D)(A+B'+C'+D')(A'+B+C'+D)(A'+B'+C+D')
    /////////////////
    assign segment[1] = (A || B) &&
                        (B || C) &&
                        (B || C || D) &&
                        (A || !B || C || D) &&
                        (A || !B || !C || !D) &&
                        (!A || B || !C || D) &&
                        (!A || !B || C || !D);
    /////////////////
    // Segment C = A'B'CD' + ABC'D' + ABC
    /////////////////
    assign segment[2] = (~A & ~B & C & ~D) |
                        (A & B & ~C & ~D) |
                        (A & B & C);
    /////////////////
    // Segment D INIT = 8492
    /////////////////
    LUT4 #(.INIT(16'h8492)) seg_LUT (.O(segment[3]), .I0(data[0]), .I1(data[1]), .I2(data[2]), .I3(data[3]) );
    /////////////////
    // Segment E = (A'+B')(A'+B+C')(A'+B+C+D)(A+B'+C'+D)(A+B+C'+D)(A+B+C+D)
    ///////////////// 
    assign segment[4] = (~A | ~B) &
                        (~A | B | ~C) &
                        (~A | B | C | D) &
                        (A | ~B | ~C | D) &
                        (A | B | ~C | D) &
                        (A | B | C | D);
    /////////////////
    // Segment F = A'B'C + A'B'C'D +A'BCD + ABC'D
    /////////////////
    assign segment[5] = (!A && !B && C) ? 1 :
                        (!A && !B && !C && D) ? 1 :
                        (!A && B && C && D) ? 1 :
                        (A && B && !C && D) ? 1 : 0;
    /////////////////
    // Segment G = A'B'C' + A'BCD + ABC'D'
    /////////////////
    assign segment[6] = ~(~(~(A & 1) & ~(B & 1) & ~(C & 1)) &
                        ~(~(A & 1) & B & C & D) &
                        ~(A & B & ~(C & 1) & ~(D & 1)));

endmodule