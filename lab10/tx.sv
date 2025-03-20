/***************************************************************************************
* 
* Filename: tx.sv
*
* Author: Ethan Scott
* Description: This is a UART transmitter that runs at a baud rate of 19200
*              and uses odd parity.
*
***************************************************************************************/
module tx #(CLK_FREQUENCY=100_000_000, BAUD_RATE=19_200)(
    output logic Sout, Sent,         // transmitter serial output signal & signal to
                                    // acknowledge that transmitter is done transmitting

    input logic[7:0] Din,           // 8-bit data in to send over transmitter
    input logic clk, rst, Send);    // 100MHz clk, reset signal that is active high, &
                                    // control signal to request data transmission

    // Determine the number of clock cycles for a single baud period
    localparam CLK_CYCLE_BAUD = CLK_FREQUENCY / BAUD_RATE;

    // Determine the number of bits needed to represent the maximum count value
    localparam BAUD_COUNTER_WIDTH = $clog2(CLK_CYCLE_BAUD);

    // bit used to xor with parity to ensure odd parity
    localparam ODD = 1'b1;

    logic [BAUD_COUNTER_WIDTH-1:0] timer;    // Signal used for free counter signal
    logic clrTimer, timerDone;                    // Descriptions found in BLOCK #1
    logic clrBit, incBit, bitDone;                // Descriptions found in BLOCK #2
    logic[3:0] bitCounter;
    logic[9:0] bitReg;                            // Descriptions found in BLOCK #3
    logic load, shift, parity;

    // State type and state register
    typedef enum logic[2:0] {IDLE, START, BITS, PAR, STOP, WAIT} StateType;
    StateType ns, cs;

    // BLOCK #1
    // increment timer and reset it to 0 on indication
    // of clrTimer signal or when it reaches the last clock cyle of the baud period
    always_ff @(posedge clk) begin
        if (rst)               
            timer <= 0;
        else begin
            timerDone <= 0;
            timer <= timer + 1;
            if (clrTimer) begin        
                timer <= 0;
            end
            else if (timer == CLK_CYCLE_BAUD - 1) begin
                timerDone <= 1;
                timer <= 0;
            end
        end
    end

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
    // Shift register which stores contents of the bits to be sent over serial line.
    // Supports a parallel load when starting a transmission and shifts the bits out
    // one bit at a time during transmission. Sets the register to all 1's if rstReg is
    // asserted. If load is asserted, loads the register with a constant 0 as start bit,
    // the 8 bits of data from Din, and the parity bit. If shift is asserted, shifts
    // the bits of bitReg to the right by one and adds a constant 1 for the stop bit.
    // Sout is then assigned the LSB of the register, or current bit being transmitted
    assign parity = (^Din) ^ ODD;
    always_ff @(posedge clk) begin
        if (rst)
            bitReg <= 10'b1111111111;
        else begin
            if (load)
                bitReg <= {parity, Din, 1'b0};
            else if (shift)
                bitReg <= {1'b1, bitReg[9:1]};
        end
    end 
    assign Sout = bitReg[0];

    // BLOCK #4
    // FSM used to determine transmission process
    // SM logic to debounce the signal
    // State register
    always_ff @(posedge clk)
        cs <= ns;
    always_comb begin
        ns = cs;
        clrTimer = 0;
        clrBit = 0;
        load = 0;
        shift = 0;
        incBit = 0;
        Sent = 0;
        if(rst)
            ns = IDLE;
        else
            case (cs)
                IDLE: begin         // wait for send signal
                    clrTimer = 1;
                    clrBit = 1;
                    if (Send) begin // begin transmission process by loading Din
                        ns = START;
                        load = 1;
                    end
                end
                START: begin                // wait for timerDone
                    if (timerDone) begin
                        ns = BITS;
                        shift = 1;          // shift in start bit
                    end
                end
                BITS: begin                 // shift in all 8 bits from transmission
                    if (timerDone && !bitDone) begin
                        shift = 1;
                        incBit = 1;
                    end 
                    // when all bits transmitted, go to
                    // parity bit transmission
                    else if (timerDone && bitDone) begin 
                        ns = PAR;
                        shift = 1;
                    end 
                end
                PAR: begin                  // parity bit transmission
                    if (timerDone) begin
                        ns = STOP;
                        shift = 1;
                    end 
                end
                STOP: begin                 // finish transmission process
                    if (timerDone)
                        ns = WAIT;
                end
                WAIT: begin                 // Sent signal goes high indicating 
                                            // the complete transmission process is
                                            // finished
                    Sent = 1;
                    if (!Send)
                        ns = IDLE;
                end
            endcase
        
    end 




endmodule