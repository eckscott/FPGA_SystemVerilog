# /*************************************************************************************
# *
# * Filename: sim_rx.tcl
# * 
# * author: Ethan Scott
# * Description: This is a simulation of the rx module. See individual test case comments
# *              for further specifics.
# *
# *************************************************************************************/
# Check if a waveform configuration is already present
set curr_wave [current_wave_config]
if { [string length $curr_wave] == 0 } {
    # If no waveform configuration exists, create one and add top-level signals
    if { [llength [get_objects]] > 0 } {
        add_wave /
        set_property needs_save false [current_wave_config]
    } else {
        # Warning if no top-level signals are found
        send_msg_id Add_Wave-1 WARNING "No top-level signals found. Simulator will start
        without a wave window. If you want to open a wave window, go to 
        'File->New Waveform Configuration' or type 'create_wave_config' in 
        the Tcl console."
    }
}

# Create an oscillating 100MHz clock signal
add_force clk {0 0} {1 5ns} -repeat_every 10ns

# Run the circuit for a few clock cycles without any inputs set
run 100 ns

# Start with restart command
add_force rst 1
add_force ReceiveAck 0
add_force Sin 0
run 50 ns
add_force rst 0
add_force Sin 1
run 50 ns

# Emulate the transmission of the byte 0x41 (ASCII 'A') and correct ODD parity
add_force Sin 0
run 52.083 us
add_force Sin 1
run 52.083 us
add_force Sin 0
run 52.083 us
add_force Sin 0
run 52.083 us
add_force Sin 0
run 52.083 us
add_force Sin 0
run 52.083 us
add_force Sin 0
run 52.083 us
add_force Sin 1
run 52.083 us
add_force Sin 1
run 52.083 us
add_force Sin 1
run 52.083 us
add_force Sin 1
run 52.083 us

# run for another 100 us after end of serial transmission
run 100 us

# Assert 'ReceiveAck' and run for 10 us
add_force ReceiveAck 1
run 10 us
add_force ReceiveAck 0
run 10 us

# Emulate the transmission of the byte 0x5e (ASCII '^') and incorrect EVEN parity
add_force Sin 0
run 52.083 us
add_force Sin 0
run 52.083 us
add_force Sin 1
run 52.083 us
add_force Sin 1
run 52.083 us
add_force Sin 1
run 52.083 us
add_force Sin 1
run 52.083 us
add_force Sin 0
run 52.083 us
add_force Sin 1
run 52.083 us
add_force Sin 0
run 52.083 us
add_force Sin 1
run 52.083 us
add_force Sin 1
run 52.083 us

# run for another 100 us after end of serial transmission
run 100 us

# Assert 'ReceiveAck' and run for 10 us
add_force ReceiveAck 1
run 10 us
add_force ReceiveAck 0
run 10 us


