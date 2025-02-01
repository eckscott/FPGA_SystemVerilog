# /*****************************************************************************
# *
# * Filename: implement_logic.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the implementation process
# *
# *****************************************************************************/

# open synthesized checkpoint 
open_checkpoint logic_functions_synth.dcp

# run design optimization
opt_design

# Run placement
place_design

# Run routing
route_design

# generate reports
report_utilization -file utilization.rpt

# generate the design bitstream and dcp file
write_bitstream -force logic_functions.bit

# create a new checkpoint
write_checkpoint -force logic_functions.dcp