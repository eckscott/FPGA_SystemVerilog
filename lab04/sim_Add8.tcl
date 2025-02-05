# /*****************************************************************************
# *
# * Filename: sim_Fulladd.tcl
# * 
# * author: Ethan Scott
# * Description: simulation of 5 different additions
# *
# *****************************************************************************/

#set Cin to 0
add_force cin 0

# Case 1: Add a positive binary number to a negative binary number
add_force a 11000101
add_force b 00011010
run 10 ns
puts "Test Case 1 - a=11000101,
              b=00011010 
           => s=[get_value -radix bin s]"


# Case 2: Add two positive binary numbers without overflow
add_force a 00010100
add_force b 00001011
run 10 ns
puts "Test Case 2 - a=00010100,
              b=00001011 
           => s=[get_value -radix bin s]"


# Case 3: Add two positive binary numbers with overflow
add_force a 01111111
add_force b 00000001
run 10 ns
puts "Test Case 3 - a=01111111,
              b=00000001 
           => s=[get_value -radix bin s]"


# Case 4: Add two negative binary numbers without overflow.
add_force a 11010100
add_force b 11101111
run 10 ns
puts "Test Case 4 - a=11010100,
              b=11101111 
           => s=[get_value -radix bin s]"


# Case 5: Add two negative binary numbers with overflow.
add_force a 10000000
add_force b 11111000
run 10 ns
puts "Test Case 5 - a=10000000,
              b=11111000 
           => s=[get_value -radix bin s]"