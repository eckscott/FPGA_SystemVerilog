# /*************************************************************************************
# *
# * Filename: sim_decrpyt_rc4.tcl
# * 
# * author: Ethan Scott
# * Description: This is a simulation of the decrpyt_rc4 module on two ciphertext/key
# *              pairs
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

#Start with the ‘restart’ command


#Create an oscillating clock signal with a period of 10ns
add_force clk {0 0} {1 5ns} -repeat_every 10ns

#Set the reset to 1
add_force reset 1

#Set default values for the signals and run for a few clock cycles
add_force enable 1
add_force key 0
add_force bytes_in 0
run 30 ns

#Run the decrypt function by setting enable to ‘1’ with the following inputs:
#Key = 24’h010203
#ciphertext = 128’h5745204C4F5645204543454E20333230
#Run for 11 us (the decryption should be done by this time)
add_force bytes_in -radix hex 5745204C4F5645204543454E20333230
add_force key -radix hex 010203
add_force enable 1
run 11 us

#Set enable to ‘0’ and run for 1 us
add_force enable 0
run 1 us

#Run the decrypt function by setting enable to ‘1’ with the following inputs:
#Key = 24’h3fe21b
#ciphertext = 128’h0f844e5b0b4e42d35d063c6a1a5a1524
#Run for 11 us (the decryption should be done by this time)
add_force bytes_in -radix hex 0f844e5b0b4e42d35d063c6a1a5a1524
add_force key -radix hex 3fe21b
add_force enable 1

#Set enable to ‘0’ and run for 1 us
add_force enable 0
run 1 us