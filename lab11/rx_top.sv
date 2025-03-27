/***************************************************************************************
* 
* Filename: rx_top.sv
*
* Author: Ethan Scott
* Description: This is a top level module for the UART receiver. 
*
***************************************************************************************/
module rx_top #(CLK_FREQUENCY=100_000_000, BAUD_RATE=19_200, REFRESH_RATE=19_200,
            WAIT_TIME_US=5_000)(
    // Cathode signals for seven-segment display
    output logic[7:0] segment,
    // Anode signals for the four display digits
    output logic[3:0] anode,
    // RX Debug signal, Parity error to led[0]
    output logic rx_debug, parityErr,
    // 100MHz clock, reset sig, input receive sig
    input logic clk, btnd, rx_in);

    // Synchronizer signals
    logic sync_reset1, sync_reset, sync_rx1, sync_rx;
    // Handshaking signals and data registers. Acknowledge sig used to acknowledge
    // reception of byte of data, parityErr val from rx_mod, data received from rx mod,
    // and a count of how many characters have been received
    logic acknowledge, rx_parityErr;
    logic[7:0] received_data, ack_data, char_count;
    // data shown on the 7 segment disp
    logic[15:0] data_out;
    // edge detector
    logic ack_edge_sig1, ack_edge_sig2, ack_edge_sig;

    // blank none of the digits on the 7seg disp and display the 3rd decimal digit
    localparam BLANK = 4'b0000;
    localparam DP_3 = 4'b0100;

    /*****************************************************
    *                  SET UP BUTTONS                    *
    *****************************************************/
    // Sync the receive signal to the global clock
    // sync 1
    always_ff @(posedge clk)
        sync_rx1 <= rx_in;
    // sync 2
    always_ff @(posedge clk)
        sync_rx <= sync_rx1;
    
    // Sync the reset button pushes to the global clock
    // sync 1
    always_ff @(posedge clk)
        sync_reset1 <= btnd;
    // sync 2
    always_ff @(posedge clk)
        sync_reset <= sync_reset1;

    // this is the receiver module. It connects the clk from the mod to the global clk,
    // the resets, stores the input Sin sig into sync_rx1, stores the data received
    // into the received_data sig, has an acknowledge sig that goes high when a byte
    // of data is received by the mod
    rx receiever(.clk(clk), .rst(sync_reset), .Sin(sync_rx), .Dout(received_data),
                 .Receive(acknowledge), .ReceiveAck(acknowledge),
                 .parityErr(rx_parityErr));
    assign rx_debug = ~rx_in;

    /*****************************************************
    *                    HAND SHAKING                    *
    *****************************************************/
    // edge detect sync 1
    always_ff @(posedge clk)
        ack_edge_sig1 <= acknowledge;
    // edge detect sync 2
    always_ff @(posedge clk)
        ack_edge_sig2 <= ack_edge_sig1;
    // combination of 2 syncs
    assign ack_edge_sig = (ack_edge_sig1 & ~ack_edge_sig2);
    // Using the edge detector above, increment char_count on one instance of acknowledge
    always_ff @(posedge clk) begin
        if (sync_reset)
            char_count <= 0;
        else
            if (ack_edge_sig)
                char_count <= char_count + 1;
    end 
    // if the acknowledge sig is high, assign ack_data what is in received_data
    always_ff @(posedge clk) begin
        if (sync_reset)
            ack_data = 0;
        else
            if (acknowledge)
                ack_data = received_data;
    end
    // if the acknowledge sig is high, assign parityErr what is in rx_parityErr
    always_ff @(posedge clk) begin
        if (sync_reset)
            parityErr = 0;
        else
            if (acknowledge)
                parityErr = rx_parityErr;
    end 

    /*****************************************************
    *                 SEVEN-SEG DISPLAY                  *
    *****************************************************/
    // This is the seven segment display module. It connects the segment signal to
    // the segment port, anode signal to the anode port, the top 2 digits display the
    // character received count, and the bottom 2 digits display the character
    // received. As well, the 3rd digit point is turned on to separate the 2 counts
    seven_segment4 seven_seg_disp(.segment(segment), .anode(anode), .data_in(data_out),
                                  .blank(BLANK), .dp_in(DP_3), .rst(sync_reset), .clk(clk));
    assign data_out = {char_count, ack_data};

endmodule