# /*****************************************************************************
# *
# * Filename: sim_reg4.tcl
# * 
# * author: Ethan Scott
# * Description: Test reg4 module. See comments over different test cases
# *
# *****************************************************************************/

# Create an oscillating clock input
add_force clk {0 0} {1 5ns} -repeat_every 10ns

# Run the clock for at least two clock cycles without setting any input signals
run 10 ns
run 10 ns

# Set all non-clock input signals to zero
add_force load 0
add_force clr 0
add_force din[3:0] 0000

# Run the clock for at least 10 clock cycles with all the non-clock input
# signals set to zero
run 100 ns

# Set the ‘din’ input to a non-zero value
add_force din[3:0] 1111

# Set the ‘load’ signal to one for at least one clock cycle and then set
# ‘load’ back to zero for at least one clock signal
# (make sure the ‘din’ propagates to q)
add_force load 1
run 10 ns
add_force load 0
run 10 ns

# Demonstrate the loading of at least three other values to the register
add_force din[3:0] 1001
run 10 ns
add_force load 1
run 10 ns

add_force load 0
add_force din[3:0] 0110
run 10 ns
add_force load 1
run 10 ns

add_force load 0
add_force din[3:0] 1010
run 10 ns
add_force load 1
run 10 ns

# Clear the register by asserting the ‘clr’ signal to demonstrate the
# clear functionality
add_force clr 1
run 10 ns
add_force load 0
run 10 ns
add_force clr 0

# Load at least one more value to the register
add_force din[3:0] 0011
run 10 ns
add_force load 1
run 10 ns