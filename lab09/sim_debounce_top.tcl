# /*************************************************************************************
# *
# * Filename: sim_debounce.tcl
# * 
# * author: Ethan Scott
# * Description: Tests one button press that includes at least three "btnc" transitions
# *
# *************************************************************************************/

# Create an oscillating 100MHz clock signal
add_force clk {0 0} {1 5ns} -repeat_every 10ns

# Set reset pulse
add_force btnd 1
run 10 ns
add_force btnd 0

# A short btnc positive pulse that is not long enough to generate a debounce output
add_force btnc 1
run 100ns
add_force btnc 0
run 100ns

# A long btnc pulse long enough to generate debounce output
add_force btnc 1
run 5000100 ns
add_force btnc 0
run 100 ns

# A long low btnc pulse long enough to generate a low debounce output
add_force btnc 1
run 5000100 ns
add_force btnc 0
run 7000000 ns


