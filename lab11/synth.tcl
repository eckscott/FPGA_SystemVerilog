# /*****************************************************************************
# *
# * Filename: synth.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv rx.sv rx_top.sv ../lab07/seven_segment4.sv
read_xdc rx.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top rx_top -part xc7a35tcpg236-1 -verbose
write_checkpoint -force rx_top_synth.dcp