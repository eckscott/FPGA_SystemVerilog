# /*****************************************************************************
# *
# * Filename: synth_adder.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv binary_adder.sv
read_xdc binary_adder.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top binary_adder -part xc7a35tcpg236-1 -verbose
write_checkpoint -force binary_adder_synth.dcp