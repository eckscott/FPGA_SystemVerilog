# Case 1: Simulate A=0, B=0, C=0 for 10 ns
set_value A 0
set_value B 0
set_value C 0
run 10 ns

# Case 2: Simulate A=0, B=0, C=1 for 10 ns
set_value A 0
set_value B 0
set_value C 1
run 10 ns

# Case 3: Simulate A=0, B=1, C=0 for 10 ns
set_value A 0
set_value B 1
set_value C 0
run 10 ns

# Case 4: Simulate A=0, B=1, C=1 for 10 ns
set_value A 0
set_value B 1
set_value C 1
run 10 ns

# Case 5: Simulate A=1, B=0, C=0 for 10 ns
set_value A 1
set_value B 0
set_value C 0
run 10 ns

# Case 6: Simulate A=1, B=0, C=1 for 10 ns
set_value A 1
set_value B 0
set_value C 1
run 10 ns

# Case 7: Simulate A=1, B=1, C=0 for 10 ns
set_value A 1
set_value B 1
set_value C 0
run 10 ns

# Case 8: Simulate A=1, B=1, C=1 for 10 ns
set_value A 1
set_value B 1
set_value C 1
run 10 ns