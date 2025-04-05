# /*****************************************************************************
# *
# * Filename: synth.tcl
# * 
# * Author: Ethan Scott
# * Description: Runs the synthesis process
# *
# *****************************************************************************/

# Reading of files
read_verilog -sv charGen.sv chargen_top.sv font_rom.sv ../lab07/seven_segment4.sv ../lab08/vga_timing.sv ../lab09/debounce.sv ../lab11/rx.sv
read_xdc chargen.xdc

# Adjust message severity
source ../resources/messages.tcl

# Synthesis and writing of saved results
synth_design -top chargen_top -part xc7a35tcpg236-1 -verbose -generic {FILENAME=mymessage.mem}
write_checkpoint -force chargen_top_synth.dcp