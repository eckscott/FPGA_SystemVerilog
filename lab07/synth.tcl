# /*****************************************************************************
# *
# * Filename: synth.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv seven_segment4.sv ssd_top.sv
read_xdc multisegment.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top ssd_top -part xc7a35tcpg236-1 -verbose
write_checkpoint -force multisegment_synth.dcp