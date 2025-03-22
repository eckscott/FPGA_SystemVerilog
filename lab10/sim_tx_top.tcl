# /*************************************************************************************
# *
# * Filename: sim_tx_top.tcl
# * 
# * author: Ethan Scott
# * Description: This is a simulation of the tx_top module. See individual test case
# *              comments for further specifics.
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

# Start with restart command
add_force btnd 1
run 50 ns
add_force btnd 0

# Run the circuit for a few clock cycles without any inputs set
run 50 ns

# Set the switches input value to 0xAA
add_force sw 01000101

# Issue the reset and run for a couple clock cycles, then repeat with btnd deasserted
add_force btnd 1
run 50 ns
add_force btnd 0
run 50 ns

# Set the signals to btnc a byte over the transmitter and run until transmission finish
add_force btnc 1
run 10 ms

# Deassert the btnc signal to complete the handshaking and run for a few microseconds
add_force btnc 0
run 5 ms


