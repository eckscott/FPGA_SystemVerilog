# /*****************************************************************************
# *
# * Filename: synth.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv regfile_top.sv regfile.sv reg4.sv seven_segment.sv FDCE.v
read_xdc regfile.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top regfile_top -part xc7a35tcpg236-1 -verbose
write_checkpoint -force regfile_top_synth.dcp