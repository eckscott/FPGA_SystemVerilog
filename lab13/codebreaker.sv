/***************************************************************************************
* 
* Filename: codebreaker.sv
*
* Author: Ethan Scott
* Description: This is the codebreaker module that performs the 'decrypt' function
*              multiple times until it finds the key that was used to encrypt the
*              message.
*
***************************************************************************************/
module codebreaker (
    // Input bytes (cipher text)
    input logic[127:0] bytes_in,
    // 100 MHz Clock, Active-high reset, Set high to start running the codebreaker
    input logic clk, reset, start,

    // Output bytes (plain text), Encryption key
    output logic[127:0] bytes_out, output logic[23:0] key,
    // Active-high for one cycle when the encryption/decryption completes,
    // Indicates the previous codebreak resulted in no match
    output logic done, error);

    // signal flag that goes high when all bytes are valid ascii characters
    logic all_ascii;
    // 128 bit register to store original bytes_in and 24 bit register
    // to store the value of the key being tested
    logic[127:0] orig_cipher;
    logic[23:0] temp_key;
    // decrypt signal that starts the decryption process and done sig indicates when done
    logic decrypt, done_decrypt;
    // signal goes high if the key did not work
    logic fail;
    // Determines whether the input byte is an ASCII character
    function logic isAscii(input logic [7:0] byte_in);
        isAscii = ((byte_in >= "A" && byte_in <= "Z") || 
                   (byte_in >= "0" && byte_in <= "9") ||
                   (byte_in == " "));
    endfunction

    // states for SM logic
    typedef enum logic[2:0] {IDLE, START, DECRYPT, CHECK, FINISH} StateType;
    StateType ns, cs;

    decrypt_rc4 decryptMod(.clk(clk), .reset(reset), .key(key),
                           .bytes_out(bytes_out), .enable(decrypt),
                           .bytes_in(orig_cipher), .done(done_decrypt));

    // a logic expression that checks all the 16 bytes of the message simultaneously 
    // to determine if all bytes are ascii
    assign all_ascii =  isAscii(bytes_out[7:0])     && isAscii(bytes_out[15:8])    &&
                        isAscii(bytes_out[23:16])   && isAscii(bytes_out[31:24])   &&
                        isAscii(bytes_out[39:32])   && isAscii(bytes_out[47:40])   &&
                        isAscii(bytes_out[55:48])   && isAscii(bytes_out[63:56])   &&
                        isAscii(bytes_out[71:64])   && isAscii(bytes_out[79:72])   &&
                        isAscii(bytes_out[87:80])   && isAscii(bytes_out[95:88])   &&
                        isAscii(bytes_out[103:96])  && isAscii(bytes_out[111:104]) &&
                        isAscii(bytes_out[119:112]) && isAscii(bytes_out[127:120]);

    // increment temp key everytime the previous key failed
    always_ff @(posedge clk) begin
        if (reset)
            temp_key <= 0;
        else
            if (done || error)
                temp_key <= 0;
            else if (fail)
                temp_key <= temp_key + 1;
    end
    
    // state machine logic for cs
    always_ff @(posedge clk)
        cs <= ns;
    
    // FINISHED HERE. SET DEFAULT VALUES FOR SIGNALS AND FINISH STATE MACHINE THEN RUN TB
    always_comb begin
        orig_cipher = 0;
        decrypt = 0;
        fail = 0;
        error = 0;
        done = 0;
        key = 0;
        if (reset)
            ns = IDLE;
        else begin
            case(cs)
                // wait here until start signal is asserted, then go to START state
                IDLE: begin
                    if (start)
                        ns = START;
                end
                // init temp_key to 0 and set orig_cipher to bytes_in sig, go to DECRYPT
                START: begin
                    key = temp_key;
                    orig_cipher = bytes_in;
                    ns = DECRYPT;
                end 
                // run decryption process. When finished, move to check state
                DECRYPT: begin
                    key = temp_key;
                    orig_cipher = bytes_in;
                    decrypt = 1;
                    fail = 0;
                    if (done_decrypt)
                        ns = CHECK;
                end
                // check if decryption worked. If the output text is all ascii, set done
                // sig high and go to finish state. If not, give a fail flag for key to
                // inc and go back to decrypt state. If all key values tried, raise
                // error sig and go to finish state
                CHECK: begin
                    key = temp_key;
                    decrypt = 0;
                    if (all_ascii) begin
                        done = 1;
                        ns = FINISH;
                    end
                    else if (key < 24'hffffff) begin
                        fail = 1;
                        ns = START;
                    end
                    else begin
                        error = 1;
                        ns = FINISH;
                    end
                end
                // wait for start to go low then return to idle state
                FINISH: begin
                    if (!start)
                        ns = IDLE;
                end
                default:
                    ns = IDLE;
            endcase
        end 
    end

    

    

    

endmodule