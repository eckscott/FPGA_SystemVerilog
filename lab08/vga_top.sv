/***************************************************************************************
* 
* Filename: vga_top.sv
*
* Author: Ethan Scott
* Description: Contains the logic for generating the pixel colors on the VGA display.
*              Does this by connecting the vga_timing module to the hardware of the
*              BASYS3 FPGA.
*
***************************************************************************************/
module vga_top (
    output logic[3:0] vgaRed,       // red color signal
    output logic[3:0] vgaGreen,     // green color signal
    output logic[3:0] vgaBlue,      // blue color signal
    output logic Hsync, Vsync,      // horizontal and vertical sync signals

    input logic[11:0] sw,           // switches to determine color to display
    input logic clk, btnd, btnc, btnl, btnr);   //100MHz clock signal
    //button functionality:
    //btnd = async reset, btnc = display color from sw, btnl = white, btnr = black

    logic[9:0] pix_x;   // store the current pixel column value
    logic[9:0] pix_y;   // store the current pixel row value
    logic blank_flag;   // indicate when the pixels are in blank region to go black
    logic[11:0] default_color;  // used to store what color should be outputted
    logic hsync_int, vsync_int;  // intermediate signals to run through flip flop

    vga_timing timing_module(.clk(clk), .rst(btnd), .pixel_x(pix_x), .pixel_y(pix_y),
                             .h_sync(hsync_int), .v_sync(vsync_int), .blank(blank_flag));
    
    // default vertical columns of 8 different colors logic
    always_comb begin
        default_color = 0;
        if (pix_x < 80) // black column
            default_color = 0;
        else if ((pix_x >= 80) && (pix_x < 160)) // blue column
            default_color = 12'h00F;
        else if ((pix_x >= 160) && (pix_x < 240)) // green column
            default_color = 12'h0F0;
        else if ((pix_x >= 240) && (pix_x < 320)) // cyan column
            default_color = 12'h0FF;
        else if ((pix_x >= 320) && (pix_x < 400)) // red column
            default_color = 12'hF00;
        else if ((pix_x >= 400) && (pix_x < 480)) // magenta column
            default_color = 12'hF0F;
        else if ((pix_x >= 480) && (pix_x < 560)) // yellow column
            default_color = 12'hFF0;
        else if ((pix_x >= 560) && (pix_x < 640)) // white column
            default_color = 12'hFFF;
    end

    // MUX to decide what the color output should be
    always_comb begin
        if (blank_flag) begin
            vgaRed = 4'b0000;
            vgaGreen = 4'b0000;
            vgaBlue = 4'b0000;
        end
        else if (btnr) begin
            vgaRed = 4'b0000;
            vgaGreen = 4'b0000;
            vgaBlue = 4'b0000;
        end
        else if (btnl) begin
            vgaRed = 4'b1111;
            vgaGreen = 4'b1111;
            vgaBlue = 4'b1111;
        end 
        else if (btnc) begin
            vgaRed = sw[11:8];
            vgaGreen = sw[7:4];
            vgaBlue = sw[3:0];
        end
        else begin
            vgaRed = default_color[11:8];
            vgaGreen = default_color[7:4];
            vgaBlue = default_color[3:0];
        end 
    end

    // Additional flip flops for Hsync and Vsync to remove any glitches in output
    always_ff @(posedge clk) begin
        Hsync = hsync_int;
    end

    always_ff @(posedge clk) begin
        Vsync = vsync_int;
    end



endmodule