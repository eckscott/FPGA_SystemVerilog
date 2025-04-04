/***************************************************************************************
* 
* Filename: charGen.sv
*
* Author: Ethan Scott
* Description: A character generator module to display text characters on the VGA 
*              display. It stores the characters that should be displayed on the screen,
*              and it determines what to draw on the screen at each pixel location to
*              display the characters.
*
***************************************************************************************/
module charGen #(FILENAME="", CLK_FREQUENCY=100_000_000, BAUD_RATE=19_200,
                 WAIT_TIME_US=5_000, REFRESH_RATE=200)(
    //cathode and anode signals for digits of seven segment display
    output logic[7:0] segment, output logic[3:0] anode,
    // RGB color signals
    output logic[3:0] vgaRed, vgaGreen, vgaBlue,
    // Vertical and Horizontal sync sigs
    output logic Vsync, Hsync,

    // determines character to write or color to display
    input logic[11:0] sw,
    // uart receiver, set foreground clr, set background color, write char, rst, clk
    input logic rx_in, btnr, btnl, btnc, btnd, clk);

    // constant no decimal points
    localparam DP_NONE = 4'b0000;
    localparam SEV_SEG_BLANK = 4'b1000;
    localparam SEG_DATA = 4'b0000;

    // synchronizer signals
    logic rx_sync, rx_sync1, fore_clr_sync, fore_clr_sync1, back_clr_sync,
          back_clr_sync1, char_we_sync, char_we_sync1, rst_sync, rst_sync1;
    logic[11:0] sw_sync;

    // seven-segment display signals
    logic[15:0] seven_seg_data;

    // background/foreground clr signals
    logic [11:0] foreground_color;
    logic [11:0] background_color;

    // VGA Timing Controller and Character Generator signals
    logic[9:0] pix_x, pix_y;
    logic h_sync, v_sync, vga_blank;

    // synchronizer 1
    always_ff @(posedge clk) begin
        rx_sync1 <= rx_in;
        fore_clr_sync1 <= btnr;
        back_clr_sync1 <= btnl;
        char_we_sync1 <= btnc;
        rst_sync1 <= btnd;
        sw_sync <= sw;
    end
    // synchronizer 2
    always_ff @(posedge clk) begin
        rx_sync <= rx_sync1;
        fore_clr_sync <= fore_clr_sync1;
        back_clr_sync <= back_clr_sync1;
        char_we_sync <= char_we_sync1;
        rst_sync <= rx_sync1;
    end

    /*****************************************************
    *                 SEVEN-SEG DISPLAY                  *
    *****************************************************/
    // This is the seven segment display module. It connects the segment signal to
    // the segment port, anode signal to the anode port, the bottom 3 digits display the
    // value by the swithces. Top digit is blanked and so are all decimal points
    seven_segment4 seven_seg_disp(.segment(segment), .anode(anode),
                                  .data_in(seven_seg_data), .blank(SEV_SEG_BLANK),
                                  .dp_in(DP_NONE), .rst(rst_sync), .clk(clk));
    assign seven_seg_data = {SEG_DATA, sw_sync};

    /*****************************************************
    *           BACKGROUND/FOREGROUND COLRS              *
    *****************************************************/
    // if btnl is pressed, background color = value of switches, default = black
    // if btnr is pressed, foreground color = value of swithces, default = white
    always_comb begin
        foreground_color = 12'hfff;
        background_color = 12'h000;
        if (fore_clr_sync)
            foreground_color = sw_sync;
        if (back_clr_sync)
            background_color = sw_sync;
    end

    /*****************************************************
    *    VGA Timing Controller and Character Generator   *
    *****************************************************/
    vga_timing VGA(.pixel_x(pix_x), .pixel_y(pix_y), .h_sync(h_sync), .v_sync(v_sync),
                   .last_column(), .last_row(), .blank(vga_blank), .clk(clk), .rst(rst_sync));

    



endmodule