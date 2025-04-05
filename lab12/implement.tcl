# /*****************************************************************************
# *
# * Filename: implement.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the implementation process
# *
# *****************************************************************************/

# open synthesized checkpoint 
open_checkpoint chargen_top_synth.dcp

# run design optimization
opt_design

# Run placement
place_design

# Run routing
route_design

# generate reports
report_utilization -file utilization.rpt
report_timing_summary -max_paths 2 -report_unconstrained -file timing.rpt -warn_on_violation

# generate the design bitstream and dcp file
write_bitstream -force chargen_top.bit

# create a new checkpoint
write_checkpoint -force chargen_top.dcp