# /*****************************************************************************
# *
# * Filename: sim_Fulladd.tcl
# * 
# * author: Ethan Scott
# * Description: simulation of 5 different additions
# *
# *****************************************************************************/

# Case 1: Add a positive binary number to a negative binary number
add_force a 11000101
add_force b 00011010
run 10 ns

# Case 2: Add two positive binary numbers without overflow
add_force a 00010100
add_force b 00001011
run 10 ns

# Case 3: Add two positive binary numbers with overflow
add_force a 01111111
add_force b 00000001
run 10 ns

# Case 4: Add two negative binary numbers without overflow.
add_force a 10010000
add_force b 11101111
run 10 ns

# Case 5: Add two negative binary numbers with overflow.
add_force a 10000000
add_force b 11111000
run 10 ns