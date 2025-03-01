/***************************************************************************
* 
* Filename: ssd_top.sv
*
* Author: Ethan Scott
* Description:  a top-level design that will use a working 7 segment
*               display controller to display 16 bit values
*
****************************************************************************/
module ssd_top #(CLK_FREQUENCY=100_000_000, REFRESH_RATE=200)(
    output logic[7:0] segment,      // Cathode signals for seven-segment display
                                    // (including digit point). segment[0] corresponds
                                    // to CA and segment[6] corresponds to CG, and
                                    // segment[7] corresponds to DP.
    output logic[3:0] anode,        // Anode signals for each of the four digits.
    input logic[15:0] sw,           // Indicates the 16-bit value to display on the 4
                                    // digits
    input logic clk, btnc, btnd, btnu, btnl, btnr); //clock, invert value to display,
                                                    // reset
                                                    //shut off display, turn on all
                                                    // digit points
                                                    //turn off left two digit points
    logic[15:0] input_val;          // input values from switches
    logic[3:0] blank_val;           // which digits to blank
    logic[3:0] dp;                  // digit points

    // if btnc pressed, invert value given by switches. If not, keep value of switches
    always_comb begin
        input_val = sw;
        if (btnc)
            input_val = ~sw;
    end

    // blank all digits on btnu press, blank first 2 digits on btnr press, no blank else
    always_comb begin
        if (btnu)
            blank_val = 4'b1111;
        else if (btnr)
            blank_val = 4'b1100;
        else 
            blank_val = 4'b0000;
    end

    // turn on all digit points with btnl push
    always_comb begin
        if (btnl)
            dp = 4'b1111;
        else
            dp = 4'b0000;
    end

    // Creates a working 4 digit seven segment display
    seven_segment4 #(.REFRESH_RATE(REFRESH_RATE),.CLK_FREQUENCY(CLK_FREQUENCY))
    seven_seg_display(.anode(anode), .segment(segment), .data_in(input_val), .clk(clk),
                      .rst(btnd), .blank(blank_val), .dp_in(dp));

endmodule