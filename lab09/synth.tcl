# /*****************************************************************************
# *
# * Filename: synth.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv debounce.sv debounce_top.sv ../lab07/seven_segment4.sv
read_xdc debounce.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top debounce_top -part xc7a35tcpg236-1 -verbose
write_checkpoint -force debounce_top_synth.dcp