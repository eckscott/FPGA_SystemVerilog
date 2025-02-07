# /*****************************************************************************
# *
# * Filename: synth.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv arithmetic_top.sv Add8.sv FullAdd.sv
read_xdc arithmetic.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top arithmetic_top -part xc7a35tcpg236-1 -verbose
write_checkpoint -force arithmetic_top_synth.dcp