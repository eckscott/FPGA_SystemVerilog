# /*****************************************************************************
# *
# * Filename: sim_arithmetic_top.tcl
# * 
# * author: Ethan Scott
# * Description: simulation of 5 different additions
# *              in the arithmetic_top module
# *
# *****************************************************************************/

# set Cin to 0
add_force btnc 0

# Case 1: Add a positive binary number to a negative binary number
add_force sw[7:0] 11000101
add_force sw[15:8] 00011010
run 10 ns
puts "Test Case 1 - a=11000101,
              b=00011010 
           => s=[get_value -radix bin led[7:0]]

Overflow detection => [get_value -radix bin led[8]]"


# Case 2: Add two positive binary numbers without overflow
add_force sw[7:0] 00010100
add_force sw[15:8] 00001011
run 10 ns
puts "Test Case 2 - a=00010100,
              b=00001011 
           => s=[get_value -radix bin led[7:0]]

Overflow detection => [get_value -radix bin led[8]]"


# Case 3: Add two positive binary numbers with overflow
add_force sw[7:0] 01111111
add_force sw[15:8] 00000001
run 10 ns
puts "Test Case 3 - a=01111111,
              b=00000001 
           => s=[get_value -radix bin led[7:0]]

Overflow detection => [get_value -radix bin led[8]]"


# Case 4: Add two negative binary numbers without overflow.
add_force sw[7:0] 11010100
add_force sw[15:8] 11101111
run 10 ns
puts "Test Case 4 - a=11010100,
              b=11101111 
           => s=[get_value -radix bin led[7:0]]

Overflow detection => [get_value -radix bin led[8]]"


# Case 5: Add two negative binary numbers with overflow.
add_force sw[7:0] 10000000
add_force sw[15:8] 11111000
run 10 ns
puts "Test Case 5 - a=10000000,
              b=11111000 
           => s=[get_value -radix bin led[7:0]]
        
Overflow detection => [get_value -radix bin led[8]]"

# set Cin to 0 to indicate subtraction
add_force btnc 1


# Case 6: Subtract two positive numbers without overflow
add_force sw[7:0] 01111111
add_force sw[15:8] 01100111
run 10 ns
puts "Test Case 6 - 
     expect_val=00011000 
           => s=[get_value -radix bin led[7:0]]
    
     Overflow detection => [get_value -radix bin led[8]]"


# Case 7: Subtract two negative numbers without overflow
add_force sw[7:0] 11100110
add_force sw[15:8] 10110111
run 10 ns
puts "Test Case 7 - 
     expect_val=00101111
           => s=[get_value -radix bin led[7:0]]
     
     Overflow detection => [get_value -radix bin led[8]]"

# Case 8: Subtract with overflow
add_force sw[7:0] 10000100
add_force sw[15:8] 01100100
run 10 ns
puts "Test Case 8 - 
     expect_val=00100000
           => s=[get_value -radix bin led[7:0]]

     Overflow detection => [get_value -radix bin led[8]]"