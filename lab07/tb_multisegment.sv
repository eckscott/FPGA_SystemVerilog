//////////////////////////////////////////////////////////////////////////////////
//
//  Filename: tb_multisegment.sv
//
//////////////////////////////////////////////////////////////////////////////////

module tb_multisegment #(parameter REFRESH_RATE = 500_000,  // default high refresh rate for simulation 
    parameter CLK_FREQUENCY=100_000_000) ();

    localparam REFRESH_CLOCKS = CLK_FREQUENCY / REFRESH_RATE;
    localparam SEGMENT_CLOCKS = REFRESH_CLOCKS / 4;
    localparam MIN_SEGMENT_CLOCKS = SEGMENT_CLOCKS - 1;
    localparam MAX_SEGMENT_CLOCKS = SEGMENT_CLOCKS + 1;

    logic clk, rst;
    logic [15:0] tb_data;
    logic [7:0] tb_segment;
    logic [3:0] tb_anode, tb_anode_d, tb_dp, tb_blank;
    int errors = 0;

    // reg [6:0] segment_const [15:0];

    // Instance seven segment display with display counter bits of 5
    seven_segment4 #(.REFRESH_RATE(REFRESH_RATE),.CLK_FREQUENCY(CLK_FREQUENCY)) 
    ss4(.clk(clk), .rst(rst), .data_in(tb_data),
        .blank(tb_blank), .dp_in(tb_dp), .segment(tb_segment), .anode(tb_anode));

    logic valid_anode, new_valid_anode; // indicates we have a valid anode and can check the segments
    assign valid_anode = !(^tb_anode === 1'bX) && ($countones(~tb_anode) == 1);
    assign new_valid_anode = !(^tb_anode === 1'bX) &&  !(^tb_anode_d  === 1'bX)
        && valid_anode && (tb_anode != tb_anode_d);
    always_ff @(posedge clk) begin
        tb_anode_d = tb_anode;
    end

    // Check to see if more than one anode is being displayed at a time and give a warning
    logic more_than_one_anode_error = 0;
    always_ff @(posedge clk) begin
        if (tb_anode != 4'hf && $countones(~tb_anode) > 1 && more_than_one_anode_error == 0) begin
            $display("ERROR: More than one anode is being displayed at a time: %b", tb_anode);
            more_than_one_anode_error = 1;
            errors = errors + 1;
        end
        else
            more_than_one_anode_error = 0;
    end

    // Check to see if blanking is applied correctly
    logic blanking_error = 0;
    always_ff @(posedge clk) begin
        if ( !(^tb_anode === 1'bX) && (~tb_anode & tb_blank) > 0 && blanking_error == 0) begin
            $display("ERROR: digit is not blanked: anode=%b, blank=%b", tb_anode, tb_blank);
            blanking_error <= 1;
            errors = errors + 1;
        end
    end

    // Check the segments and digit point to make sure they are ok
    logic [3:0] current_data_to_display;
    int anode_index;
    assign anode_index = anode_to_index(tb_anode);
    assign current_data_to_display = tb_data[4*anode_index +: 4]; // the data that should be displayed
    always_ff @(negedge clk) begin
        if (new_valid_anode) begin
            $write("[%0t]  ",$time);
            display_ssd_status();
            // Have a valid anode index. CHeck the digit point
            if (tb_segment[7] != ~tb_dp[anode_index]) begin
                $write(" ERROR: Invalid digit point: %b expecting %b",
                    tb_segment[7], ~tb_dp[anode_index]);
                errors = errors + 1;
            end
            // Check the segments
            if (segment_to_hex(tb_segment[6:0]) != current_data_to_display) begin
                $write(" ERROR: Invalid segments: %b expecting %b",
                    tb_segment[6:0], hex_to_segment(current_data_to_display));
                errors = errors + 1;
            end
            $display();
        end
    end

    // Check anode time
    integer anode_clk_count = -1; // Unknown start time
    logic timing_message = 0;
    always_ff @(negedge clk) begin
        if (new_valid_anode) begin
            if (anode_clk_count >= 0) begin // Not the first time
                if (anode_clk_count < SEGMENT_CLOCKS - 1) begin
                    $display("[%0t]  ERROR: Too few segment clocks: %d expecting %d", $time, 
                        anode_clk_count+1,SEGMENT_CLOCKS);
                    errors = errors + 1;
                end
                else if (anode_clk_count >= SEGMENT_CLOCKS - 1 && ~timing_message ) begin
                    timing_message = 1;
                    $display("[%0t] Correct anode segment timing = %0d clocks", $time,
                        anode_clk_count+1);
                end
            end
            anode_clk_count = 0;
        end
        else begin
            if (valid_anode && anode_clk_count >= 0) begin
                if (anode_clk_count > SEGMENT_CLOCKS - 1) begin
                    $display("[%0t]  ERROR: Too many segment clocks: %d expecting %d", $time, 
                        anode_clk_count+1,SEGMENT_CLOCKS);
                    errors = errors + 1;
                    anode_clk_count = 0;
                end
                else
                    anode_clk_count = anode_clk_count + 1;
            end
            else
                anode_clk_count = -1;
        end
    end

    // Convert standard segment settings to the corresonding hex values
    function automatic logic [3:0] segment_to_hex(input logic [6:0] segments);
        begin
            case(segments)
                7'b1000000: segment_to_hex = 4'b0000; // 0
                7'b1111001: segment_to_hex = 4'b0001; // 1
                7'b0100100: segment_to_hex = 4'b0010; // 2
                7'b0110000: segment_to_hex = 4'b0011; // 3
                7'b0011001: segment_to_hex = 4'b0100; // 4
                7'b0010010: segment_to_hex = 4'b0101; // 5
                7'b0000010: segment_to_hex = 4'b0110; // 6
                7'b1111000: segment_to_hex = 4'b0111; // 7
                7'b0000000: segment_to_hex = 4'b1000; // 8
                7'b0010000: segment_to_hex = 4'b1001; // 9
                7'b0001000: segment_to_hex = 4'b1010; // A
                7'b0000011: segment_to_hex = 4'b1011; // B
                7'b1000110: segment_to_hex = 4'b1100; // C
                7'b0100001: segment_to_hex = 4'b1101; // D
                7'b0000110: segment_to_hex = 4'b1110; // E
                7'b0001110: segment_to_hex = 4'b1111; // F
                default: segment_to_hex = 4'bxxxx; // 0
            endcase
        end
    endfunction

    // Convert standard segment settings to the corresonding hex values
    function automatic logic [6:0] hex_to_segment(input logic [3:0] data);
        begin
            case(data)
                4'b0000: hex_to_segment = 7'b1000000; // 7'b0000001; // 0
                4'b0001: hex_to_segment = 7'b1111001; // 7'b1001111; // 1
                4'b0010: hex_to_segment = 7'b0100100; // 7'b0010010; // 2
                4'b0011: hex_to_segment = 7'b0110000; // 7'b0000110; // 3
                4'b0100: hex_to_segment = 7'b0011001; // 7'b1001100; // 4
                4'b0101: hex_to_segment = 7'b0010010; // 7'b0100100; // 5
                4'b0110: hex_to_segment = 7'b0000010; // 7'b0100000; // 6
                4'b0111: hex_to_segment = 7'b1111000; // 7'b0001111; // 7
                4'b1000: hex_to_segment = 7'b0000000; // 7'b0000000; // 8
                4'b1001: hex_to_segment = 7'b0010000; // 7'b0000100; // 9
                4'b1010: hex_to_segment = 7'b0001000; // 7'b0001000; // A
                4'b1011: hex_to_segment = 7'b0000011; // 7'b1100000; // B
                4'b1100: hex_to_segment = 7'b1000110; // 7'b0110001; // C
                4'b1101: hex_to_segment = 7'b0100001; // 7'b1000010; // D
                4'b1110: hex_to_segment = 7'b0000110; // 7'b0110000; // E
                4'b1111: hex_to_segment = 7'b0001110; // 7'b0111000; // F
                default: hex_to_segment = 7'bxxxxxxx; // 0
            endcase
        end
    endfunction

    // Convert standard segment settings to the corresonding hex values
    function automatic int anode_to_index(input logic [3:0] anode);
        begin
            case(anode)
                4'b1110: anode_to_index = 0;
                4'b1101: anode_to_index = 1;
                4'b1011: anode_to_index = 2;
                4'b0111: anode_to_index = 3;
                default: anode_to_index = 0;
            endcase
        end
    endfunction

    function void display_ssd_status();
    begin
        static int index = anode_to_index(tb_anode);
        logic cur_dp;
        logic [3:0] current_data;
        current_data = tb_data[4*index +: 4];
        assign cur_dp = tb_dp[index];
        $write("anode=%b (digit %0d), segment=%b, dp=%b (%b), data=%h (%h)", 
            tb_anode, index, tb_segment, tb_dp, cur_dp, tb_data, current_data);
    end
    endfunction

    //logic new_segment, new_refresh;

    task automatic display_value_cycle( input [15:0] data, input [3:0] dp, input [3:0] blank);
        // Set the data
        tb_data = data;
        tb_dp = dp;
        tb_blank = blank;
        // Wait for four digits to be displayed
        if (blank[0])
            repeat(SEGMENT_CLOCKS+1) @(negedge clk);
        else
            wait (new_valid_anode == 1 && tb_anode == 4'he);
        if (blank[1])
            repeat(SEGMENT_CLOCKS+1) @(negedge clk);
        else
            wait (new_valid_anode == 1 && tb_anode == 4'hd);
        if (blank[2])
            repeat(SEGMENT_CLOCKS+1) @(negedge clk);
        else
            wait (new_valid_anode == 1 && tb_anode == 4'hb);
        if (blank[3])
            repeat(SEGMENT_CLOCKS+1) @(negedge clk);
        else
            wait (new_valid_anode == 1 && tb_anode == 4'h7);
        repeat(10) @(negedge clk);
    endtask

    always
    begin
        clk <=1; #5ns;
        clk <=0; #5ns;
    end

    initial begin

        //shall print %t with scaled in ns (-9), with 2 precision digits, and would print the " ns" string
        $timeformat(-9, 0, " ns", 20);
        $display("*** Start of Simulation ***");

        // Simulation with no assigned values
        #100ns;

        // Initial values
        tb_data = 16'h0000;
        tb_dp = 4'b0000;
        tb_blank = 4'b0000;
        rst = 0;
        repeat(2) @(negedge clk);
        rst = 1;
        repeat(2) @(negedge clk);
        rst = 0;

        // Test all digits with various digit points
        display_value_cycle(16'h0123, 4'b0001, 4'b0000);
        display_value_cycle(16'h4567, 4'b0010, 4'b0000);
        display_value_cycle(16'h89ab, 4'b0100, 4'b0000);
        display_value_cycle(16'hcdef, 4'b1000, 4'b0000);
        // Test individual blanking
        display_value_cycle(16'h1234, 4'b1111, 4'b0001);
        display_value_cycle(16'h5678, 4'b1111, 4'b0010);
        display_value_cycle(16'h9abc, 4'b1111, 4'b0100);
        display_value_cycle(16'hdef0, 4'b1111, 4'b1000);
        // test full blanking
        tb_blank = 4'b1111;
        repeat(SEGMENT_CLOCKS * 3 + 1) @(negedge clk);
        // display_value_cycle(16'h8800, 4'b1100, 4'b0011);
        //display_value_cycle(16'h4567, 4'b0010, 4'b1111);
        // Test digits
        display_value_cycle(16'h2345, 4'b0101, 4'b0000);
        display_value_cycle(16'h6789, 4'b0101, 4'b0000);
        display_value_cycle(16'habcd, 4'b0101, 4'b0000);
        display_value_cycle(16'hef01, 4'b0101, 4'b0000);

        repeat(100) @(negedge clk);

        $display("*** Simulation done with %0d errors at time %0t ***", errors, $time);
        $finish;

    end  // end begin

endmodule