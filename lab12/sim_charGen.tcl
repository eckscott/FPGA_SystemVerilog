# /*************************************************************************************
# *
# * Filename: sim_charGen.tcl
# * 
# * author: Ethan Scott
# * Description: This is a simulation of the charGen module. See individual test case comments
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

# Run the simulation for 100ns without setting any values
run 100 ns

# Create an oscillating 100MHz clock signal
add_force clk {0 0} {1 5ns} -repeat_every 10ns

# Run the circuit for a few clock cycles without any inputs set
run 100 ns

# Perform a character write to location 0x000 with the value 0x41 (ASCII ‘A’) and run
# for a few clock cycles
add_force char_value 01000001
add_force char_addr 0
add_force char_we 1
run 50 ns

# Set the pixel_y value to ‘2’ and set pixel_x to values 0 through 7 to see the
# character ‘A’ displayed for row 2
add_force pixel_y 10
add_force pixel_x 0
run 30 ns
add_force pixel_x 01
run 30 ns
add_force pixel_x 10
run 30 ns
add_force pixel_x 11
run 30 ns
add_force pixel_x 100
run 30 ns
add_force pixel_x 101
run 30 ns
add_force pixel_x 110
run 30 ns
add_force pixel_x 111
run 30 ns

# Set the pixel_y value to ‘3’ and set pixel_x to values 0 through 7 to see the
# character ‘A’ displayed for row 3
add_force pixel_y 11
add_force pixel_x 0
run 30 ns
add_force pixel_x 01
run 30 ns
add_force pixel_x 10
run 30 ns
add_force pixel_x 11
run 30 ns
add_force pixel_x 100
run 30 ns
add_force pixel_x 101
run 30 ns
add_force pixel_x 110
run 30 ns
add_force pixel_x 111
run 30 ns
