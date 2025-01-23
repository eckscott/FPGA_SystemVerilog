# /*****************************************************************************
# *
# * Filename: sim_adder.tcl
# * 
# * Author: Ethan Scott
# * Description: Test all sixteen different input combinations for the
# *              binary adder circuit
# *
# *****************************************************************************/

run 10 ns
set_value A -radix bin 00
set_value B -radix bin 00
run 10 ns
puts "Test Case 1 - A=00, B=00 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 00
set_value B -radix bin 01
run 10 ns
puts "Test Case 2 - A=00, B=01 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 00
set_value B -radix bin 10
run 10 ns
puts "Test Case 3 - A=00, B=10 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 00
set_value B -radix bin 11
run 10 ns
puts "Test Case 4 - A=00, B=11 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 01
set_value B -radix bin 00
run 10 ns
puts "Test Case 5 - A=01, B=00 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 01
set_value B -radix bin 01
run 10 ns
puts "Test Case 6 - A=01, B=01 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 01
set_value B -radix bin 10
run 10 ns
puts "Test Case 7 - A=01, B=10 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 01
set_value B -radix bin 11
run 10 ns
puts "Test Case 8 - A=01, B=11 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 10
set_value B -radix bin 00
run 10 ns
puts "Test Case 9 - A=10, B=00 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 10
set_value B -radix bin 01
run 10 ns
puts "Test Case 10 - A=10, B=01 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 10
set_value B -radix bin 10
run 10 ns
puts "Test Case 11 - A=10, B=10 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 10
set_value B -radix bin 11
run 10 ns
puts "Test Case 12 - A=10, B=11 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 11
set_value B -radix bin 00
run 10 ns
puts "Test Case 13 - A=11, B=00 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 11
set_value B -radix bin 01
run 10 ns
puts "Test Case 14 - A=11, B=01 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 11
set_value B -radix bin 10
run 10 ns
puts "Test Case 15 - A=11, B=10 => O=[get_value -radix bin O]"
run 10 ns

set_value A -radix bin 11
set_value B -radix bin 11
run 10 ns
puts "Test Case 16 - A=11, B=11 => O=[get_value -radix bin O]"
run 10 ns