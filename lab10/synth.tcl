# /*****************************************************************************
# *
# * Filename: synth.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv tx.sv tx_top.sv ../lab07/seven_segment4.sv ../lab09/debounce.sv
read_xdc tx.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top tx_top -part xc7a35tcpg236-1 -verbose
write_checkpoint -force tx_top_synth.dcp