# /*************************************************************************************
# *
# * Filename: sim_chargen_top.tcl
# * 
# * author: Ethan Scott
# * Description: This is a simulation of the chargen top module. See individual test
# *              case comments for further specifics.
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

# Run the simulation for 100ns without setting any values
run 100 ns

# Create an oscillating 100MHz clock signal
add_force clk {0 0} {1 5ns} -repeat_every 10ns

# Run the circuit for a few clock cycles without any inputs set
run 100 ns

# test the rst
add_force btnd 1
run 100 ns
add_force btnd 0
run 100 ns

# Simulate loading the character ‘S’ into the character memory by pressing btnc
add_force sw 01010011
run 50 ns
add_force btnc 1
run 10 ms
add_force btnc 0
run 10 ms

# Simulate loading the charcter ‘A’ into the character memory over the UART receiver
add_force rx_in 0
run 52.085 us
add_force rx_in 1
run 52.085 us
add_force rx_in 0
run 52.085 us
add_force rx_in 0
run 52.085 us
add_force rx_in 0
run 52.085 us
add_force rx_in 0
run 52.085 us
add_force rx_in 0
run 52.085 us
add_force rx_in 1
run 52.085 us
add_force rx_in 1
run 52.085 us
add_force rx_in 1
run 52.085 us
add_force rx_in 1
run 52.085 us
run 5 ms