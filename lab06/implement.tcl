# /*****************************************************************************
# *
# * Filename: implement.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the implementation process
# *
# *****************************************************************************/

# open synthesized checkpoint 
open_checkpoint regfile_top_synth.dcp

# run design optimization
opt_design

# Run placement
place_design

# Run routing
route_design

# generate reports
report_utilization -file utilization.rpt

# generate the design bitstream and dcp file
write_bitstream -force regfile_top.bit

# create a new checkpoint
write_checkpoint -force regfile_top.dcp