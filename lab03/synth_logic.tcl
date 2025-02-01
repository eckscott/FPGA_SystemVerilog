# /*****************************************************************************
# *
# * Filename: synth_logic.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv logic_functions.sv
read_xdc logic_functions.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top logic_functions -part xc7a35tcpg236-1 -verbose
write_checkpoint -force logic_functions_synth.dcp