/***************************************************************************************
* 
* Filename: tx_top.sv
*
* Author: Ethan Scott
* Description: This module uses the transmission module for the UART (tx) in
*              conjunction with the seven-segment display and button debouncer to
*              transmit a message from the switches. The center button will assert a
*              signal that the message indicated by the value of the switches is ready
*              to be transmitted, the transmission process will happen, and the message
*              will appear on the first 2 digits of the seven segment display
*
***************************************************************************************/
module tx_top #(CLK_FREQUENCY=100_000_000, BAUD_RATE=19_200,
            REFRESH_RATE=19_200, WAIT_TIME_US=5_000)(
    output logic[7:0] segment,          // cathode signals for 7 seg display
    output logic[3:0] anode,            // anode signals for 7 seg display
    output logic tx_debug, sent, tx_out, // TX debug sig, TX sent sig, transmit sig
    
    input logic[7:0] sw,                // 8 slide swithces to specify character sent
    input logic clk, btnc, btnd);       // send character sig, reset character sig

    logic sync_btnc, sync_btnc1, sync_reset, sync_reset1; // sigs used to sync buttons
    logic send;
    logic[7:0] data_in1, data_in2;
    logic[15:0] data_in;

    localparam BLANKED_DIGITS = 4'b1100;
    localparam DEC_POINTS = 4'b0000;

    /*****************************************************
    *                  SET UP BUTTONS                    *
    *****************************************************/

    // Sync the send button pushes to the global clock
    // sync 1
    always_ff @(posedge clk)
        sync_btnc1 <= btnc;
    // sync 2
    always_ff @(posedge clk)
        sync_btnc <= sync_btnc1;
    
    // Sync the reset button pushes to the global clock
    // sync 1
    always_ff @(posedge clk)
        sync_reset1 <= btnd;
    // sync 2
    always_ff @(posedge clk)
        sync_reset <= sync_reset1;

    // This debounce module debounces button pushes. The noisy port is the input
    // and the debounced port is the debounced signal from the input
    debounce btn_debouncer(.debounced(send), .clk(clk), .rst(sync_reset),
                           .noisy(sync_btnc));
    
    /****************************************************
    *           SET UP SEVEN-SEGMENT DISPLAY            *
    ****************************************************/

    // This seven_segment4 module sets up the seven segment display to work. The data
    // passed into the data_in port is the switches for the lower 8-bits of data and
    // all 0's for the top as shown below. The top 2 digits are blanked out, and no
    // decimal points are being used
    seven_segment4 seven_seg_disp(.data_in(data_in), .blank(BLANKED_DIGITS),
                                  .dp_in(DEC_POINTS), .clk(clk), .rst(sync_reset),
                                  .anode(anode), .segment(segment));
    
    assign data_in1 = sw;
    assign data_in2 = 0;
    assign data_in = {data_in2, data_in1};

    /****************************************************
    *             SET UP TRANSMISSION MODULE            *
    ****************************************************/

    // This transmission module runs the transmission process of the UART
    tx transmit_mod(.rst(sync_reset), .clk(clk), .Send(sync_btnc), .Sout(tx_out), .Sent(sent),
                    .Din(sw));
    
    // inverted value of Sout from transmission module
    assign tx_debug = ~tx_out;


endmodule