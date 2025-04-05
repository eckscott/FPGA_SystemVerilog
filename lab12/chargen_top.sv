/***************************************************************************************
* 
* Filename: chargen_top.sv
*
* Author: Ethan Scott
* Description: This is the character generator top level module. This module generates
*              characters and displays it on the VGA display using either UART
*              transmission or displaying the ASCII value as given by the swithces on a
*              BASYS3 FPGA. 
*
***************************************************************************************/
module chargen_top #(FILENAME="", CLK_FREQUENCY=100_000_000, BAUD_RATE=19_200,
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
    localparam BLACK = 12'h000;
    localparam WHITE = 12'hfff;
    localparam INC_COL = 1'b1;
    localparam INC_ROW = 8'b10000000;

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
    logic h_sync, h_sync1, h_sync2, v_sync, v_sync1, v_sync2, vga_blank;
    logic pix_out, write;
    logic[6:0] char_val;
    logic[11:0] char_addr;

    // debouncer sigs
    logic char_we_db, f1_db, f2_db, pulse_out_we;

    // UART sigs
    logic[7:0] rx_out;
    logic par_err, ack;

    // VGA color sigs
    logic[3:0] r, g, b;

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
        rst_sync <= rst_sync1;
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
    // top for bits not used because top digit isn't used
    assign seven_seg_data = {SEG_DATA, sw_sync};

    /*****************************************************
    *           BACKGROUND/FOREGROUND COLRS              *
    *****************************************************/
    // if btnl is pressed, background color = value of switches, default = black
    // if btnr is pressed, foreground color = value of swithces, default = white
    always_comb begin
        foreground_color = WHITE;
        background_color = BLACK;
        if (fore_clr_sync)
            foreground_color = sw_sync;
        if (back_clr_sync)
            background_color = sw_sync;
    end

    /*****************************************************
    *    VGA Timing Controller and Character Generator   *  
    *****************************************************/
    // vga timing module used to get pixel values of x and y and the necessary Hsync and
    // Vsync signals to make the character display work on the VGA display
    vga_timing VGA(.pixel_x(pix_x), .pixel_y(pix_y), .h_sync(h_sync1), .v_sync(v_sync1),
                   .blank(vga_blank), .clk(clk), .rst(rst_sync));

    // Character generator module used to write a character value at a certain address
    // if the write signal is asserted. Using pix_x and pix_y from the previous module
    // instantiation, it can output the correct pixel output (either 1 or 0) based on
    // a font ROM and the character value that is being written
    charGen charGenerator(.pixel_out(pix_out), .char_addr(char_addr), .pixel_x(pix_x),      /////////////////////////////////
                    .pixel_y(pix_y), .char_value(char_val), .char_we(write),                ///// PIX_Y IS SIZE 10 BUT //////
                    .clk(clk));                                                             ///// PIXEL_Y IS SIZE 9    //////
                                                                                            /////////////////////////////////
    /*****************************************************
    *                  UART RECEIVER                     *
    *****************************************************/
    // UART receiver module used to receive a character into the input Sin as an
    // alternate way of writting a character to the display, based off of user input
    rx UARTReceiver(.Dout(rx_out), .Receive(ack), .parityErr(par_err), .clk(clk),
                    .rst(rst_sync), .Sin(rx_sync), .ReceiveAck(ack));

    /*****************************************************
    *               Write Char to Display                *
    *****************************************************/
    // register that increments the columns and rows of the character array
    // every time a character is written
    always_ff @(posedge clk) begin
        if (rst_sync)
            char_addr = 0;
        else if (write)
            if (char_addr[6:0] < 79)
                char_addr = char_addr + INC_COL;
            if (char_addr[6:0] == 79)
                char_addr = char_addr + INC_ROW;
            if ((char_addr[6:0] == 79) && (char_addr[11:7] == 29))
                char_addr = 0;
    end
    
    // debounce module that debouces the char_we_sync signal so that only one character
    // is written when btnc is pressed.
    debounce buttonDebouncer(.noisy(char_we_sync), .clk(clk), .rst(rst_sync),
                             .debounced(char_we_db));

    // edge detector to verify one button push counts as 1 and doesn't increment 4ever
    // sync 1
    always_ff @(posedge clk)
        f1_db <= char_we_db;
    // sync 2
    always_ff @(posedge clk)
        f2_db <= f1_db;
    // combination of 2 syncs
    assign pulse_out_we = (f1_db && ~f2_db);

    // assert the write signal if the debounced btnc signal is pushed or if the UART
    // receives a signal. If not, do not assert the write signal
    always_comb begin
        if (pulse_out_we || ack)
            write = 1;
        else
            write = 0;
    end

    // assign char_val to be the value of the swithces if btnc was pressed. If not,
    // assign char_val to be the value that the UART received
    always_comb begin
        if (pulse_out_we)
            char_val = sw_sync;
        else
            char_val = rx_out; 
    end

    /*****************************************************
    *                  VGA color signals                 *
    *****************************************************/
    // set RGB to black if blank sig asserted. If not, set them to the background color
    // unless the pix_out signal is asserted, then set them to foreground color
    always_comb begin
        if (vga_blank) begin
            r = BLACK[11:8];
            g = BLACK[7:4];
            b = BLACK[3:0];
        end
        else
            if (pix_out) begin
                r = foreground_color[11:8];
                g = foreground_color[7:4];
                b = foreground_color[3:0];
            end
            else begin
                r = background_color[11:8];
                g = background_color[7:4];
                b = background_color[3:0];
            end
    end
    // output synchronization to ensure no glitches
    always_ff @(posedge clk) begin
        vgaRed <= r;
        vgaGreen <= g;
        vgaBlue <= b;
        h_sync2 <= h_sync1;
        v_sync2 <= v_sync1;
    end
    // additional syncs for hsync and v sync sigs to match up with RGB
    always_ff @(posedge clk) begin
        h_sync <= h_sync2;
        v_sync <= h_sync2;
    end
    // final sync register for hsync and vsync
    always_ff @(posedge clk) begin
        Hsync <= h_sync;
        Vsync <= v_sync;
    end 

endmodule