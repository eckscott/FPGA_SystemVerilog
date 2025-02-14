/***************************************************************************
* 
* Filename: seven_segment_top.sv
*
* Author: Ethan Scott
* Description: instances seven segment controller and adds logic to
               connect controller to the display, buttons, and switches
*
****************************************************************************/
module seven_segment_top(
    output logic[7:0] segment, //Cathode signals for seven-segment display
                               // (including digit point). segment[0] corresponds
                               // to CA and segment[6] corresponds to CG, and
                               // segment[7] corresponds to DP.

    output logic[3:0] anode,   //Anode signals for each of the four digits.
    input logic[3:0] sw,       //Input from four switches to drive seven-segment decoder.
    input logic btnc, btnl, btnr); //Center button (will turn on digit point when pressed).
                                //Left button (will turn on all digits when pressed).
                                //Right button (will turn off all digits when pressed).
    
    assign segment[7] = btnc ? 0 : 1; //turns on digit point with push of btnc
    
    assign anode[0] = btnl ? 1 : btnr ? 1 : 0;
    assign anode = btnl ? 0 : btnr ? 1 : 1;


    seven_segment M0(.data(sw), .seg(segment[6:0]));


endmodule