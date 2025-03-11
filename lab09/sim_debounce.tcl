# /*************************************************************************************
# *
# * Filename: sim_debounce.tcl
# * 
# * author: Ethan Scott
# * Description: simulation of debounce module. See individual test case comments
# *
# *************************************************************************************/

# Create an oscillating 100MHz clock signal
add_force clk {0 0} {1 5ns} -repeat_every 10ns

# Set reset pulse
add_force rst 1;
run 10 ns
add_force rst 0;

# A short noisy positive pulse that is not long enough to generate a debounce output
add_force noisy 1;
run 100ns
add_force noisy 0;
run 100ns

# A long noisy pulse long enough to generate debounce output
add_force noisy 1;
run 5000015 ns
add_force noisy 0;
run 100 ns

# A long low noisy pulse long enough to generate a low debounce output
add_force noisy 1;
run 5000015 ns
add_force noisy 0;
run 7000000 ns


