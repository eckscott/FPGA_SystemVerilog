# /*************************************************************************************
# *
# * Filename: sim_tx.tcl
# * 
# * author: Ethan Scott
# * Description: This is a simulation of the tx module. See individual test case comments
# *              for further specifics.
# *
# *************************************************************************************/

# Create an oscillating 100MHz clock signal
add_force clk {0 0} {1 5ns} -repeat_every 10ns

# Start with restart command
add_force rst 1
run 10 ns
add_force rst 0

# Run the circuit for a few clock cycles without any inputs set
run 50 ns

# Set the input value to 0xAA
add_force Din 10101010

# Issue the reset and run for a couple clock cycles, then repeat with rst deasserted
add_force rst 1
run 20 ns
add_force rst 0
run 20 ns

# Set the signals to send a byte over the transmitter and run until transmission finish
add_force Send 1
run 1 ms

# Deassert the Send signal to complete the handshaking and run for a few microseconds
add_force Send 0
run 5 us


