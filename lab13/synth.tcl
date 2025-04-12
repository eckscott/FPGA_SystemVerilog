# /*****************************************************************************
# *
# * Filename: synth.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Adjust message severity
source ../resources/messages.tcl

# Reading of files
read_verilog -sv codebreaker_top.sv codebreaker.sv write_vga.sv decrypt_rc4.sv
read_verilog -sv ../lab12/charGen.sv ../lab12/font_rom.sv ../lab07/seven_segment4.sv
read_verilog -sv ../lab08/vga_timing.sv ../lab09/debounce.sv ../lab11/rx.sv
read_xdc codebreaker.xdc

# Synthesis and writing of saved results
synth_design -top codebreaker_top -part xc7a35tcpg236-1 -verbose -generic {FILENAME=background.mem}
write_checkpoint -force codebreaker_top_synth.dcp