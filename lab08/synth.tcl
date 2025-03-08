# /*****************************************************************************
# *
# * Filename: synth.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv vga_timing.sv vga_top.sv
read_xdc vga.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top vga_top -part xc7a35tcpg236-1 -verbose
write_checkpoint -force vga_top_synth.dcp