# /*****************************************************************************
# *
# * Filename: sim_adder.tcl
# * 
# * Author: Ethan Scott
# * Description: Test all sixteen different input combinations for the
# *              binary adder circuit
# *
# *****************************************************************************/

set_value A -radix bin 00
set_value B -radix bin 00
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 00
set_value B -radix bin 01
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 00
set_value B -radix bin 10
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 00
set_value B -radix bin 11
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 01
set_value B -radix bin 00
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 01
set_value B -radix bin 01
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 01
set_value B -radix bin 10
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 01
set_value B -radix bin 11
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 10
set_value B -radix bin 00
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 10
set_value B -radix bin 01
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 10
set_value B -radix bin 10
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 10
set_value B -radix bin 11
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 11
set_value B -radix bin 00
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 11
set_value B -radix bin 01
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 11
set_value B -radix bin 10
run 10 ns
get_value -radix bin O
run 10 ns

set_value A -radix bin 11
set_value B -radix bin 11
run 10 ns
get_value -radix bin O
run 10 ns