/***************************************************************************************
* 
* Filename: vga_timing.sv
*
* Author: Ethan Scott
* Description: Contains the timing generator for the VGA controller
*
***************************************************************************************/
module vga_timing (
    output logic[9:0] pixel_x, //column of current VGA pixel
    output logic[9:0] pixel_y, //row of current VGA pixel
    output logic h_sync, v_sync, //low asserted horizontal & vertical sync VGA signals
                 last_column, last_row, // current pixel corresponding to last visible
                                        // column and row
                 blank, // current pixel is part of a horizontal or vertical retrace
                        // and that the output color must be blanked
                                               

    input logic clk, rst); //100MHZ clock signal & synchronous reset

    logic pixel_en; //asseted every 4th clock cycle to be used by the VGA timing circuit
    logic [1:0] pixel_counter; // used to trigger pixel_en on every 4th clock cycle

    // pixel counter
    always_ff @(posedge clk) begin
        if (rst || (pixel_en == 2'b11))
            pixel_counter <= 0;
        else
            pixel_counter <= pixel_counter + 1;
    end

    // pixel enable on every 4th clock cycle
    always_comb begin
        if (pixel_counter == 2'b11)
            pixel_en = 1;
        else
            pixel_en = 0;
    end

    // horizontal pixel counter used to sequence through various phases of horiz sync
    always_ff @(posedge clk) begin
        if (rst || ( pixel_en && pixel_x == 799)) //799 is max width
            pixel_x <= 0;
        else if (pixel_en)
            pixel_x <= pixel_x + 1;
    end 

    // trigger the last_column output signal when pixel_x is 639
    always_comb begin
        if (pixel_x == 639)
            last_column = 1;
        else
            last_column = 0;
    end 

    // vertical pixel counter used to sequency through vertical sync phases
    // and indicate the current line being displayed
    always_ff @(posedge clk) begin
        if (rst || (pixel_en && pixel_x == 799 && pixel_y == 520)) //520 is max height
            pixel_y <= 0;
        else if (pixel_en && (pixel_x == 799))
            pixel_y <= pixel_y + 1;
    end 

    // trigger the last_row output signal when pixel_y is 479
    always_comb begin
        if (pixel_y == 479)
            last_row = 1;
        else
            last_row = 0;
    end 

    // Horizontal Sync timing signal lasting 96 pixel clocks
    always_comb begin
        if ((pixel_x >= 656) && (pixel_x <= 751))
            h_sync = 0;
        else
            h_sync = 1;
    end

    // Vertical sync timing signal
    always_comb begin
        if ((pixel_y >= 490) && (pixel_y <= 491))
            v_sync = 0;
        else
            v_sync = 1;
    end

    // generate the blank signal whenver the horizontal or vertical counter are
    // outside of the display area
    always_comb begin
        if ((pixel_x > 639) || (pixel_y > 479))
            blank = 1;
        else
            blank = 0;
    end

endmodule