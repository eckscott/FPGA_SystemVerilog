/***************************************************************************************
* 
* Filename: rx.sv
*
* Author: Ethan Scott
* Description: This is a UART receiver that runs at a baud rate of 19200
*              and uses odd parity.
*
***************************************************************************************/
module rx #(CLK_FREQUENCY=100_000_000, BAUD_RATE=19_200)(
    // 8-bit data received by module. Valid when Receive is high
    output logic[7:0] Dout,
    // indicates the receiver now has a byte to hand off on Dout pins,
    // indicates there was a parity error. Valid when Receive is high          
    output logic Receive, parityErr 
    // 100MHZ clk, system rst active high, receiver serial input signal,
    // indicates that the host has accepted the byte on the Dout pins
    input logic clk, rst, Sin, ReceiveAck);    

    // Determine the number of clock cycles for a single baud period
    localparam CLK_CYCLE_BAUD = CLK_FREQUENCY / BAUD_RATE;

    // Determine the number of bits needed to represent the maximum count value
    localparam BAUD_COUNTER_WIDTH = $clog2(CLK_CYCLE_BAUD);

    // bit used to xor with parity to ensure odd parity
    localparam ODD = 1'b1;

    logic [BAUD_COUNTER_WIDTH-1:0] timer;    // Signal used for free counter signal
    logic clrTimer, timerDone, timerHalfDone;     // Descriptions found in BLOCK #1
    logic clrBit, incBit, bitDone;                // Descriptions found in BLOCK #2
    logic[3:0] bitCounter;
    logic[9:0] bitReg;                            // Descriptions found in BLOCK #3
    logic shift;

    // State type and state register
    typedef enum logic[2:0] {INIT, IDLE, START, BITS, PAR, STOP, WAIT} StateType;
    StateType ns, cs;

    // BLOCK #1
    // increment timer and reset it to 0 on indication of clrTimer signal or when it
    // reaches the last clock cyle of the baud period. When it reaches the last clock
    // cycle of the baud period, timerDone goes high. When it reaches last clock cycle
    // of half the baud period, timerHalfDone goes high
    always_ff @(posedge clk) begin
        if (rst)               
            timer <= 0;
        else begin
            timer <= timer + 1;
            if (clrTimer)       
                timer <= 0;
            else if (timer == CLK_CYCLE_BAUD - 1)
                timer <= 0;
        end
    end
    assign timerDone = (timer == CLK_CYCLE_BAUD - 1);
    assign timerHaflDone = (timer == (CLK_CYCLE_BAUD - 1) / 2);

    // BLOCK #2
    // Bit counter responsible for counting number of data bits transmitted. Set to 0
    // on assertion of clrBit signal, increments on incBit signal, and releases a signal
    // bitDone which indicates when the counter has reached the last bit of data
    always_ff @(posedge clk) begin
        if (rst)
            bitCounter <= 0;
        else begin
            if (clrBit)
                bitCounter <= 0;
            else if (incBit)
                bitCounter <= bitCounter + 1;
        end 
    end
    assign bitDone = (bitCounter >= 8);

    // BLOCK #3
    // Shift register which stores contents of the bits being received over serial line.
    // Supports a parallel load when receiving a transmission and shifts the bits in
    // one bit at a time during transmission. Sets the register to all 1's if rst is
    // asserted. If shift is asserted, shifts the signal from Sin in to the right. Dout
    // is then loaded with the 8 right most digits of bitReg, and parityErr is triggered
    // depending on the values in Dout to ensure odd parity
    always_ff @(posedge clk) begin
        if (rst)
            bitReg <= 10'b1111111111;
        else begin
            if (shift)
                bitReg <= {Sin, bitReg[9:1]};
        end
    end
    assign Dout = bitReg[7:0];
    assign parityErr = ((^Dout) ^ ODD) == Dout[8];

    // BLOCK #4
    // FSM used to determine receive process
    always_ff @(posedge clk)
        cs <= ns;
    always_comb begin
        ns = cs;
        clrTimer = 0;
        clrBit = 0;
        shift = 0;
        incBit = 0;
        Receive = 0;
        if (rst)
            ns = INIT;
        else
            case (cs)
                // wait for Sin to go high 
                INIT: begin         
                    if (Sin)
                        ns = IDLE;
                end
                // wait for Sin to go low to indicate start bit. Reset timer
                // and bit counter
                IDLE: begin                
                    if (!Sin) begin
                        ns = START;
                        clrTimer = 1;
                        clrBit = 1;
                    end          
                end
                // wait for half the baud period, indicating first measurement
                // or halfway through start bit then go next to BITS state
                START: begin    
                    if (timerHalfDone) begin
                        ns = BITS;
                        clrTimer = 1;
                    end
                end
                // cycle through all 8 bits of data being received. Once finished,
                // go to parity bit
                BITS: begin                 
                    if (timerDone && !bitDone) begin
                        shift = 1;
                        incBit = 1;
                    end
                    else if (timerDone && bitDone) begin 
                        ns = PAR;
                        shift = 1;
                    end 
                end
                // receive the parity bit
                PAR: begin   
                    if (timerDone) begin
                        ns = STOP;
                        shift = 1;
                    end
                end
                // finish transmission process on stop bit
                STOP: begin
                    if (timerDone)
                        ns = WAIT;
                end 
                // Receive signal goes high indicating complete reception of signal.
                // Now parityErr and Dout are validbegin values. Wait for ReceiveAck sig
                // before returning to INIT state for retrieval of next character
                WAIT: begin                 
                    Receive = 1;
                    if (ReceiveAck)
                        ns = INIT;
                end
            endcase       
    end 

endmodule