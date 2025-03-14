// Testbench for codebreaker

module tb_codebreaker #(
    parameter logic [127:0] CYPHERTEXT=128'hca7d05cd7e096d91acaf6fd347ef4994,
    parameter logic [23:0] EXPECTED_KEY = 24'h0005,
    parameter logic [127:0] EXPECTED_PLAINTEXT=128'h52205520484156494e472046554e2020) ();

    // Estimate the maximum amount of time to complete the testbench
    localparam time MAX_TIMER_PER_DECRYPT = 12us;
    localparam time MAX_SIMULATION_TIME = MAX_TIMER_PER_DECRYPT * EXPECTED_KEY;

    logic clk, reset, start, done;
    logic [23:0] key;
    logic [127:0] bytes_in, bytes_out;
    int errors = 0;
    logic error;

    codebreaker DUT (
        .clk(clk),
        .reset(reset),
        .start(start),
        .bytes_in(bytes_in),
        .key(key),
        .bytes_out(bytes_out),
        .done(done),
        .error(error)
    );

    // Clock
    initial begin
        #100ns; // wait 100 ns before starting clock (after inputs have settled)
        clk = 0;
        forever
            #5ns  clk = ~clk;
    end

    // Main test block
    initial begin

        // errors = 0;
        //shall print %t with scaled in ns (-9), with 2 precision digits, and would print the " ns" string
        $timeformat(-9, 0, " ns", 20);
        $display("*** Start of Simulation ***");

        reset = 0;
        start = 0;
        bytes_in = 0;
        repeat (10) @(negedge clk);
        reset = 1;
        repeat (10) @(negedge clk);
        reset = 0;

        // Simulate your brute-force design on the cyphertext below. HINT: the key is 000005 -- be sure your circuit finds that one.
        bytes_in = 128'hca7d05cd7e096d91acaf6fd347ef4994;
        start = 1;
        repeat (10) @(negedge clk);
        start = 0;

        wait(done);
        if (key != EXPECTED_KEY) begin
            $display("ERROR: Expected key %h, got %h", EXPECTED_KEY, key);
            errors = errors + 1;
        end
        if (bytes_out != EXPECTED_PLAINTEXT) begin
            $display("ERROR: Expected plaintext %h, got %h", EXPECTED_PLAINTEXT, bytes_out);
            errors = errors + 1;
        end
        if (errors == 0) begin
            $display("SUCCESS: Key found: %h at time %0t ***", key, $time);
        end
        $finish;

   end  // end initial begin

    // Timeout
    initial begin
        wait(start);
        #MAX_SIMULATION_TIME;
        $display("ERROR: Timeout after %0t", $time);
        $finish;
    end

endmodule // tb
