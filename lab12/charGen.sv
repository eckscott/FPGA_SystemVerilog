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
module charGen #(FILENAME="")(
    // The value of the character output pixel
    output logic pixel_out,

    // The write address of the character memory
    input logic[11:0] char_addr,
    // The column address of the current pixel
    input logic[9:0] pixel_x,
    // The row address of the current pixel
    input logic[8:0] pixel_y,
    // The 8-bit value to write into the character memory
    input logic[6:0] char_value,
    // Character write enable, 100MHz system Clock
    input logic char_we, clk);

    // character memory array 
    logic[7:0] mem_data[0:4095];
    // determines which location in the mem_data to to read
    logic[11:0] char_read_addr;
    // which character is represented by char_read_addr
    logic[7:0] char_read_value;
    // delayed pixel_y signal to be synched with character value
    logic[8:0] pixel_y_d;
    // delayed pixel_x signals to be synched with the output of the font ROM
    logic[9:0] pixel_x_d, pixel_x_dd;
    // signal based on current character and which line of chacter to display
    logic[10:0] font_rom_addr;
    // 8 bit output of the font rom
    logic[7:0] rom_data;

    /***********************************************************
    ***********           CHARACTER MEMORY           ***********
    ***********************************************************/

    // Intialize the contents of the memory if the FILENAME param is set
    initial begin
    if (FILENAME != "")
        $readmemh(FILENAME, mem_data, 0);
    end

    // a syncrhonous write port for the characer val in mem_data triggered by char_we
    always_ff @(posedge clk) begin
        if (char_we)
            mem_data[char_addr] <= {1'b0, char_value};
        char_read_value <= mem_data[char_read_addr]; 
    end

    // a read port for the character addr
    assign char_read_addr = {pixel_y[8:4], pixel_x[9:3]};

    /***********************************************************
    ***********           FONT ROM                   ***********
    ***********************************************************/

    // This is the font_rom module that takes in an address to figure out
    // which character to display in the font ROM and outputs that to data
    font_rom Font(.clk(clk), .addr(font_rom_addr), .data(rom_data));

    // flip flop to delay pixel_y signal to be synced with character value
    always_ff @(posedge clk)
        pixel_y_d <= pixel_y;
    // lower 7 bits of char_read_val to get value of character and lower 4 bits of
    // pixel_y_d to determine which of the 16 lines of this character to display
    assign font_rom_addr = {char_read_value[6:0], pixel_y_d[3:0]};

    /***********************************************************
    ***********            PIXEL OUT MUX             ***********
    ***********************************************************/
    
    //Syncs to get pixel_x synced with the output of the Font Rom
    //sync1
    always_ff @(posedge clk)
        pixel_x_d <= pixel_x;
    //sync2
    always_ff @(posedge clk)
        pixel_x_dd <= pixel_x_d;

    // MUX to decide which pixel of the outputted character from the ROM based
    // on the value in pixel_x_dd
    always_comb begin
        case (pixel_x_dd[2:0])
            3'b000: pixel_out = rom_data[7];
            3'b001: pixel_out = rom_data[6];
            3'b010: pixel_out = rom_data[5];
            3'b011: pixel_out = rom_data[4];
            3'b100: pixel_out = rom_data[3];
            3'b101: pixel_out = rom_data[2];
            3'b110: pixel_out = rom_data[1];
            3'b111: pixel_out = rom_data[0];
            default:
                pixel_out = 0;
        endcase
    end
    

    

endmodule