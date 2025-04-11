/***************************************************************************************
* 
* Filename: codebreaker.sv
*
* Author: Ethan Scott
* Description: This is the top level codebreaker module used to connect the codebreaker
*              module with the BASYS3 FPGA
*
***************************************************************************************/
module codebreaker_top #(FILENAME="", CLK_FREQUENCY=100_000_000, BAUD_RATE=19_200,
                         WAIT_TIME_US=5_000, REFRESH_RATE=200, FOREGROUND_COLOR=12'hfff,
                         BACKGROUND_COLOR=12'h000)(
    // Determine which byte to display
    input logic[2:0] sw,
    // System clk, reset, start codebreak, display ciphertext on 7seg display,
    // display plain text on 7seg display, UART receiver input
    input logic clk, btnd, btnc, btnl, btnr, rx_in,
    
    // display lower 8 bits of cipher text
    output logic[7:0] led,
    // RGB color signals
    output logic[3:0] vgaRed, vgaGreen, vgaBlue,
    // anode and cathode signals for seven seg display
    output logic[3:0] anode, output logic[7:0] segment,
    // horizontal sync, vertical sync, codebreaker error sig
    output logic Hsync, Vsync, error);

    // constants for seven segment display
    localparam DP_NONE = 4'b0000;
    localparam SEV_SEG_BLANK = 4'b0000;

    // sync signals for rst btnd and switches
    logic rst_sync, rst_sync1; logic[2:0] sw_sync;

    // sync signals for rx_in and ack signal to acknowledge reception of UART
    logic rx_in_sync, rx_in_sync1, ack;
    // signal used for output of uart receiver
    logic[7:0] rx_out;

    // register that stores ciphertext being decoded
    logic[127:0] ciphTxt = 128'ha13a3ab3071897088f3233a58d6238bb;
    // final key val outputted by codebreaker and plainTxt generated
    logic[23:0] keyCorrect; logic[127:0] plainTxt;
    // done signal to indicate encryption/decryption process finished
    logic codeBreakDone;

    // synce signals for btnc to start codebreak
    logic start_sync1, start_sync, start_db, f1_db, f2_db, start_edge;

    // data displayed on the seven-segment display
    logic[15:0] sevenSegData;
    // synced signals to display ciphertext and plain text on 7seg display
    logic ciphTxtDisp_sync, ciphTxtDisp_sync1, plainTxtDisp_sync, plainTxtDisp_sync1;

    // pixel x and y signals for vga timing module and charGen module
    logic[9:0] pix_x, pix_y;
    // Input signals for charGen module
    logic[11:0] charAddr; logic[7:0] charData; logic writeChar;
    // signals to indicate when there is a new frame
    logic new_frame, last_column, last_row;

    // signals used for the vga color
    logic[3:0] r, g, b;
    logic vga_blank, h_sync, h_sync1, h_sync2, v_sync, v_sync1, v_sync2;
    logic pix_out;

    // 2 flip flop synchronizer for reset signal
    always_ff @(posedge clk) begin
        rst_sync1 <= btnd;
        rst_sync <= rst_sync1;
    end
    // synchronizer for switch values
    always_ff @(posedge clk) begin
        sw_sync <= sw;
    end

    /*****************************************************
    *                 UART RECEIVER                      *
    *****************************************************/
 
 
    // 2 flip flop synchronizer for rx_in signal
    always_ff @(posedge clk) begin
        rx_in_sync1 <= rx_in;
        rx_in_sync <= rx_in_sync1;
    end

    // This UART Receiver module is used to receive the ciphertext from the computer.
    // It connects top level parameters to its params, rx_out as the output of the
    // UART Receiver, ack as the receive acknowledge signal, btnd as the reset,
    // and the synced rx_in signal as the input Sin signal
    rx #(.CLK_FREQUENCY(CLK_FREQUENCY), .BAUD_RATE(BAUD_RATE)) UARTReceiver(
         .Dout(rx_out), .Receive(ack), .parityErr(), .clk(clk), .rst(rst_sync),
         .Sin(rx_in_sync), .ReceiveAck(ack));

    // fill bottom byte of ciphTxt with output of UART receiver so that it can be filled
    // with 16 bytes from the UART Receiver
    always_ff @(posedge clk) begin
        if (rst_sync)
            ciphTxt <= 128'ha13a3ab3071897088f3233a58d6238bb;
        else
            ciphTxt <= {ciphTxt[119:0], rx_out};
    end

    
    /*****************************************************
    *                 CODE BREAKER                       *
    *****************************************************/


    // synchronizer for btnc
    always_ff @(posedge clk) begin
        start_sync1 <= btnc;
        start_sync <= start_sync1;
    end

    // This debounce module debounces the synchronized btnc that is used as the start
    // signal to indicate to the codebreaker that it is time to start decoding
    debounce #(.CLK_FREQUENCY(CLK_FREQUENCY), .WAIT_TIME_US(WAIT_TIME_US)) debouncer (
               .debounced(start_db), .clk(clk), .rst(rst_sync), .noisy(start_sync));

    // edge detector to verify one button push counts as 1 and doesn't increment 4ever
    always_ff @(posedge clk) begin
        f1_db <= start_db;
        f2_db <= f1_db;
    end
    assign start_edge = (f1_db & ~f2_db);

    // This codebreaker module takes a cipherTxt as an input and generates a plainTxt
    // as an output once it finds a key that can decipher the code. It raises a signal
    // 'codeBreakDone' once it finishes deciphering, or a signal 'error' if it couldn't
    // crack the code. Runs through this process on the raising of the start signal
    codebreaker codeBreak(.bytes_in(ciphTxt), .clk(clk), .reset(rst_sync),
                          .start(start_edge), .bytes_out(plainTxt), .key(keyCorrect),
                          .done(codeBreakDone), .error(error));


    /*****************************************************
    *             SEVEN SEGMENT DISPLAY                  *
    *****************************************************/


    // synchronizer for btnl
    always_ff @(posedge clk) begin
        ciphTxtDisp_sync1 <= btnl;
        ciphTxtDisp_sync <= ciphTxtDisp_sync1;
    end
    // synchronizer for btnr
    always_ff @(posedge clk) begin
        plainTxtDisp_sync1 <= btnr;
        plainTxtDisp_sync <= plainTxtDisp_sync1;
    end

    // This seven segment display module displays the current key, ciphertext, and the
    // plain text on the seven segment display depending on which button is pushed
    seven_segment4 #(.CLK_FREQUENCY(CLK_FREQUENCY), .REFRESH_RATE(REFRESH_RATE))
                   sevenSegDisp(.segment(segment), .anode(anode), .data_in(sevenSegData),
                                .blank(SEV_SEG_BLANK), .dp_in(DP_NONE), .rst(rst_sync),
                                .clk(clk));

    // block to decide what data to display on the seven segment display. If btnl is
    // pressed, display certain bits of the cipherTxt depending on the value of the
    // switches. If btnr is pressed, display certain bits of the plainTxt depending
    // on the value of the switches. If no buttons are pressed, display the top
    // 16 bits of the key
    always_comb begin
        if (ciphTxtDisp_sync) begin
            case (sw_sync)
                3'b000: sevenSegData = ciphTxt[15:0];
                3'b001: sevenSegData = ciphTxt[31:16];
                3'b010: sevenSegData = ciphTxt[47:32];
                3'b011: sevenSegData = ciphTxt[63:48];
                3'b100: sevenSegData = ciphTxt[79:64];
                3'b101: sevenSegData = ciphTxt[95:80];
                3'b110: sevenSegData = ciphTxt[111:96];
                3'b111: sevenSegData = ciphTxt[127:112];
            endcase
        end
        else if (plainTxtDisp_sync) begin
            case (sw_sync)
                3'b000: sevenSegData = plainTxt[15:0];
                3'b001: sevenSegData = plainTxt[31:16];
                3'b010: sevenSegData = plainTxt[47:32];
                3'b011: sevenSegData = plainTxt[63:48];
                3'b100: sevenSegData = plainTxt[79:64];
                3'b101: sevenSegData = plainTxt[95:80];
                3'b110: sevenSegData = plainTxt[111:96];
                3'b111: sevenSegData = plainTxt[127:112];
            endcase
        end 
        else
            sevenSegData = keyCorrect[23:8];
    end

    // LED 0-7 displays the lower 8 bits of the key
    assign led = keyCorrect[7:0];


    /*****************************************************
    *                   VGA DISPLAY                      *
    *****************************************************/


    // This vga_timing module is used for the vga timing. It outputs pix_x and pix_y
    // indicating the current x,y location. As well, it outputs last_column and last_row
    // signals that are used to tell when a new frame needs to be produced
    vga_timing VGA(.pixel_x(pix_x), .pixel_y(pix_y), .h_sync(h_sync), .v_sync(v_sync),
                   .blank(vga_blank), .last_column(last_column), .last_row(last_row),
                   .clk(clk), .rst(rst_sync));

    assign new_frame = last_column & last_row;

    // This is the character generator module. It takes the pix x and y values from the
    // vga timing module and uses it to store character values at a certain address.
    // It writes characters on the assertion of the writeChar signal
    charGen #(.FILENAME(FILENAME)) charGenerator (.pixel_out(pix_out),
              .char_addr(charAddr), .pixel_x(pix_x), .pixel_y(pix_y[8:0]),
              .char_value(charData[6:0]), .char_we(writeChar), .clk(clk));

    // This vgawrite module is used to interface with the charGen module above. It
    // writes the plaintext, ciphertext, and key in real-time to the vga display
    write_vga vgaWrite(.write_char(writeChar), .char_data(charData),
                       .char_addr(charAddr), .key(keyCorrect), .plaintext(plainTxt),
                       .ciphertext(ciphTxt), .write_display(new_frame), .rst(rst_sync),
                       .clk(clk));


    /*****************************************************
    *                  VGA color signals                 *
    *****************************************************/


    // set RGB to BACKGROUND_COLOR if blank sig asserted. If not, set them to the 
    // background color unless the pix_out signal is asserted, then set them to
    // foreground color
    always_comb begin
        if (vga_blank) begin
            r = BACKGROUND_COLOR[11:8];
            g = BACKGROUND_COLOR[7:4];
            b = BACKGROUND_COLOR[3:0];
        end
        else
            if (pix_out) begin
                r = FOREGROUND_COLOR[11:8];
                g = FOREGROUND_COLOR[7:4];
                b = FOREGROUND_COLOR[3:0];
            end
            else begin
                r = BACKGROUND_COLOR[11:8];
                g = BACKGROUND_COLOR[7:4];
                b = BACKGROUND_COLOR[3:0];
            end
    end

    // output synchronization to ensure no glitches
    always_ff @(posedge clk) begin
        vgaRed <= r;
        vgaGreen <= g;
        vgaBlue <= b;
    end

    // additional syncs for hsync and v sync sigs to match up with RGB
    always_ff @(posedge clk) begin
        h_sync1 <= h_sync;
        h_sync2 <= h_sync1;
        Hsync <= h_sync2;

        v_sync1 <= v_sync;
        v_sync2 <= v_sync1;
        Vsync <= v_sync2;
    end

endmodule