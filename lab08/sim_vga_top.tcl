# /*************************************************************************************
# *
# * Filename: sim_vga_top.tcl
# * 
# * author: Ethan Scott
# * Description: Simulation of vga_top module. See individual test case comments
# *
# *************************************************************************************/

# Create an oscillating 100MHz clock signal
add_force clk {0 0} {1 10ns} -repeat_every 20ns

# Set all buttons off and switches to 0
add_force btnr 0
add_force btnd 0
add_force btnl 0
add_force btnc 0
add_force sw[11:0] 0

# Issue the reset for a few clock cycles
add_force btnd 1
run 100 ns
add_force btnd 0
run 20 ns

# Run the simulation for 10 vertical lines (32000 clock cycles) to make sure
# the colors are correct
run 640000 ns

# Set btnl to high and simulate for 10 lines to make sure the colors are white
add_force btnl 1
run 640000 ns
add_force btnl 0

# Set btnr to high and simulate for 10 lines to make sure the colors are black
add_force btnr 1
run 640000 ns
add_force btnr 0

# Set btnc to high and simulate for 10 lines to make sure the colors are the same
# as the switches

# red
add_force sw[11:0] 111100000000
add_force btnc 1
run 640000 ns
add_force btnc 0
add_force sw[11:0] 0

# green
add_force sw[11:0] 000011110000
add_force btnc 1
run 640000 ns
add_force btnc 0
add_force sw[11:0] 0



