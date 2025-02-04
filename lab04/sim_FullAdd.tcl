# /*****************************************************************************
# *
# * Filename: sim_Fulladd.tcl
# * 
# * author: Ethan Scott
# * Description: simulation of all 8 inputs
# *
# *****************************************************************************/

# Case 1: Simulate a=0, b=0, cin=0 for 10 ns
add_force a 0
add_force b 0
add_force cin 0
run 10 ns

# Case 2: Simulate a=0, b=0, cin=1 for 10 ns
add_force a 0
add_force b 0
add_force cin 1
run 10 ns

# Case 3: Simulate a=0, b=1, cin=0 for 10 ns
add_force a 0
add_force b 1
add_force cin 0
run 10 ns

# Case 4: Simulate a=0, b=1, cin=1 for 10 ns
add_force a 0
add_force b 1
add_force cin 1
run 10 ns

# Case 5: Simulate a=1, b=0, cin=0 for 10 ns
add_force a 1
add_force b 0
add_force cin 0
run 10 ns

# Case 6: Simulate a=1, b=0, cin=1 for 10 ns
add_force a 1
add_force b 0
add_force cin 1
run 10 ns

# Case 7: Simulate a=1, b=1, cin=0 for 10 ns
add_force a 1
add_force b 1
add_force cin 0
run 10 ns

# Case 8: Simulate a=1, b=1, cin=1 for 10 ns
add_force a 1
add_force b 1
add_force cin 1
run 10 ns