# /*****************************************************************************
# *
# * Filename: synth.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv seven_segment_top.sv seven_segment.sv
read_xdc seven_segment.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top seven_segment_top -part xc7a35tcpg236-1 -verbose
write_checkpoint -force seven_segment_synth.dcp