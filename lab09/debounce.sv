/***************************************************************************
* 
* Filename: seven_segment4.sv
*
* Author: Ethan Scott
* Description: a multi-segment display controller that will drive the
*              four-digit seven segment display on the Basys3 board
*
****************************************************************************/
module debounce #(CLK_FREQUENCY=100_000_000, WAIT_TIME_US=5000)(
    output logic debounced,     // debounced output
    input logic clk, rst, noisy);   //clock, active high sync reset, noisy input

    // Indicates the number of clock cycles used for the timer in SM
    localparam TIMER_CLOCK_COUNT = (CLK_FREQUENCY / 1_000_000) * WAIT_TIME_US;

    // Determine the number of bits needed to represent the maximum count value
    localparam TIMER_CLOCK_WIDTH = $clog2(TIMER_CLOCK_COUNT);

    // Signal used for the free counter
    logic[TIMER_CLOCK_WIDTH-1:0] timer;

    // Flags to indicate when to clr the timer and when the timer is done
    logic clrTimer, timerDone;

    // State type and state register
    typedef enum logic[2:0] {S0, S1, S2, S3} StateType;
    StateType ns, cs;

    // Signal for the sync version of the async input
    logic syncNoisy;

    // Block to increment timer and reset it to 0 on indication and when it reaches
    // timer done val
    always_ff @(posedge clk) begin
        if (clrTimer)               
            timer <= 0;
        else begin
            timer <= timer + 1;
            if (timer == TIMER_CLOCK_COUNT - 1) begin
                timerDone <= 1;
                timer <= 0;
            end
        end
    end

    // Synchronize the async input
    always_ff @(posedge clk)
        syncNoisy <= noisy;

    // State register
    always_ff @(posedge clk)
        cs <= ns;

    // SM logic to debounce the signal
    always_comb begin
        ns = cs;
        debounced = 0;
        clrTimer = 0;
        if (rst)
            ns = S0;
        else
            case(cs)
                // wait for noisy signal, then clr timer and go to S1
                S0: begin
                    clrTimer = 1;
                    if (syncNoisy)
                        ns = S1;
                    else
                        ns = S0;
                end 
                // wait for timer to expire, then go s2. If noisy signal not held,
                // return to S0 and start timer over
                S1: begin
                    if (!syncNoisy)
                        ns = S0;
                    else if (!timerDone)
                        ns = S1;
                    else
                        ns = S2;
                end
                // debounced signal goes high and the timer resets. If noisy signal
                // goes low, go to S3. If not, stay in S2
                S2: begin
                    debounced = 1;
                    clrTimer = 1;
                    if (!syncNoisy)
                        ns = S3;
                    else
                        ns = S2;
                end
                // debounced signal goes low again. If noisy signal comes back go back
                // to S2. If noisy signal stays low and timer expires, go to S0
                S3: begin
                    debounced = 0;
                    if (syncNoisy)
                        ns = S2;
                    else if (!timerDone)
                        ns = S3;
                    else
                        ns = S0;
                end   
            endcase
    end 

    





endmodule