/***************************************************************************
* 
* Filename: seven_segment4.sv
*
* Author: Ethan Scott
* Description: a multi-segment display controller that will drive the
*              four-digit seven segment display on the Basys3 board
*
****************************************************************************/
module seven_segment4 #(CLK_FREQUENCY=100_000_000, REFRESH_RATE=200)(
    output logic[7:0] segment,      // Cathode signals for seven-segment
                                    // display (including digit point). 
                                    // segment[0] corresponds to CA and
                                    // segment[6] corresponds to CG, and
                                    // segment[7] corresponds to DP.
    output logic[3:0] anode,        // Anode signals for each of 4 digits

    input logic[15:0] data_in,      // Indicates the 16-bit value to display
                                    // on the 4 digits
    input logic[3:0] blank,         // Indicates which digits to blank
    input logic[3:0] dp_in,         // Indicates which digit points displayed
    input logic rst, clk);          // Reset input, clock input

    // Determine the number of clock cycles to display each digit
    localparam DIGIT_DISPLAY_CLOCKS = CLK_FREQUENCY / REFRESH_RATE / 4;

    // Determine the number of bits needed to represent the maximum count value
    localparam DIGIT_COUNTER_WIDTH = $clog2(DIGIT_DISPLAY_CLOCKS);

    // Signal used for free counter signal
    logic [DIGIT_COUNTER_WIDTH-1:0] digit_display_counter;

    // Signal for 4 digit display
    logic [1:0] digit_select;

    // 4-bit data_in signals to be used
    logic [3:0] display_data;

    // free counter
    always_ff @(posedge clk) begin   
        if (rst)
            digit_display_counter <= 0;
        else begin
            if (digit_display_counter == DIGIT_DISPLAY_CLOCKS - 1)
                digit_display_counter <= 0;
            else
                digit_display_counter <= digit_display_counter + 1;
        end
    end

    // digit display counter
    always_ff @(posedge clk) begin  
        if (rst)
            digit_select <= 0;
        else if (digit_display_counter == DIGIT_DISPLAY_CLOCKS - 1)
            digit_select <= digit_select + 1;
    end

    // data in MUX
    always_comb begin
        display_data = 4'b0000;  
        if (digit_select == 0)
            display_data = data_in[3:0];
        else if (digit_select == 1)
            display_data = data_in[7:4];
        else if (digit_select == 2)
            display_data = data_in[11:8];
        else if (digit_select == 3)
            display_data = data_in[15:12];
    end

    // seven segment decoder
    always_comb begin
        case(display_data)
            4'b0000: segment[6:0] = 7'b1000000; //0
            4'b0001: segment[6:0] = 7'b1111001; //1
            4'b0010: segment[6:0] = 7'b0100100; //2
            4'b0011: segment[6:0] = 7'b0110000; //3
            4'b0100: segment[6:0] = 7'b0011001; //4
            4'b0101: segment[6:0] = 7'b0010010; //5
            4'b0110: segment[6:0] = 7'b0000010; //6
            4'b0111: segment[6:0] = 7'b1111000; //7
            4'b1000: segment[6:0] = 7'b0000000; //8
            4'b1001: segment[6:0] = 7'b0010000; //9
            4'b1010: segment[6:0] = 7'b0001000; //A
            4'b1011: segment[6:0] = 7'b0000011; //b
            4'b1100: segment[6:0] = 7'b1000110; //C
            4'b1101: segment[6:0] = 7'b0100001; //d
            4'b1110: segment[6:0] = 7'b0000110; //E
            4'b1111: segment[6:0] = 7'b0001110; //F
        endcase 
    end

    // Digit point MUX
    always_comb begin
        case(digit_select)
            2'b00: segment[7] = ~dp_in[0];
            2'b01: segment[7] = ~dp_in[1];
            2'b10: segment[7] = ~dp_in[2];
            2'b11: segment[7] = ~dp_in[3];
        endcase
    end

    // anode logic
    always_comb begin
        anode = 4'b1111;
        if ((digit_select == 0) && (blank[0] == 0))
            anode[0] = 0;
        if ((digit_select == 1) && (blank[1] == 0))
            anode[1] = 0;
        if ((digit_select == 2) && (blank[2] == 0))
            anode[2] = 0;
        if ((digit_select == 3) && (blank[3] == 0))
            anode[3] = 0;       
    end

endmodule