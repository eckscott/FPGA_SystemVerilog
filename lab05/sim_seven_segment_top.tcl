# /*****************************************************************************
# *
# * Filename: sim_seven_segment_top.tcl
# * 
# * author: Ethan Scott
# * Description: simulation of all different data inputs
# *
# *****************************************************************************/

#button testing
add_force btnc 1
run 10ns
add_force btnl 1
run 10 ns
add_force btnr 1
run 10ns
add_force btnl 0
add_force btnr 0
run 10 ns
add_force btnr 1
run 10 ns

#16 different input test cases
run 10ns
add_force sw[3:0] 0000
puts "Expected 100000
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 0001
puts "Expected 1111001
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 0010
puts "Expected 0100100
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 0011
puts "Expected 0110000
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 0100
puts "Expected 0011001
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 0101
puts "Expected 0010010
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 0110
puts "Expected 0000010
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 0111
puts "Expected 1111000
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 1000
puts "Expected 0000000
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 1001
puts "Expected 0010000
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 1010
puts "Expected 0001000
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 1011
puts "Expected 0000011
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 1100
puts "Expected 1000110
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 1101
puts "Expected 0100001
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 1110
puts "Expected 0000110
segment =[get_value -radix bin segment[6:0]]"
run 10ns

run 10ns
add_force sw[3:0] 1111
puts "Expected 0001110
segment =[get_value -radix bin segment[6:0]]"
run 10ns