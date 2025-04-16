# /*************************************************************************************
# *
# * Filename: codebreaker.xdc
# * 
# * author: Ethan Scott
# * Description: This is a .xdc file to connect the codebreaker_top module to the basys3
# *              FPGA
# *
# *************************************************************************************/

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -period 10.00 [get_ports clk]

# Switches
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]

# LEDs
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property PACKAGE_PIN L1 [get_ports error]
	set_property IOSTANDARD LVCMOS33 [get_ports error]


#7 segment display
set_property PACKAGE_PIN W7 [get_ports {segment[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {segment[0]}]
set_property PACKAGE_PIN W6 [get_ports {segment[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {segment[1]}]
set_property PACKAGE_PIN U8 [get_ports {segment[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {segment[2]}]
set_property PACKAGE_PIN V8 [get_ports {segment[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {segment[3]}]
set_property PACKAGE_PIN U5 [get_ports {segment[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {segment[4]}]
set_property PACKAGE_PIN V5 [get_ports {segment[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {segment[5]}]
set_property PACKAGE_PIN U7 [get_ports {segment[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {segment[6]}]

set_property PACKAGE_PIN V7 [get_ports {segment[7]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {segment[7]}]

set_property PACKAGE_PIN U2 [get_ports {anode[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {anode[0]}]
set_property PACKAGE_PIN U4 [get_ports {anode[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {anode[1]}]
set_property PACKAGE_PIN V4 [get_ports {anode[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {anode[2]}]
set_property PACKAGE_PIN W4 [get_ports {anode[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {anode[3]}]


#Buttons
set_property PACKAGE_PIN U18 [get_ports btnc]
	set_property IOSTANDARD LVCMOS33 [get_ports btnc]
set_property PACKAGE_PIN W19 [get_ports btnl]
	set_property IOSTANDARD LVCMOS33 [get_ports btnl]
set_property PACKAGE_PIN T17 [get_ports btnr]
	set_property IOSTANDARD LVCMOS33 [get_ports btnr]
set_property PACKAGE_PIN U17 [get_ports btnd]
	set_property IOSTANDARD LVCMOS33 [get_ports btnd]


#VGA Connector
set_property PACKAGE_PIN G19 [get_ports {vgaRed[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[0]}]
set_property PACKAGE_PIN H19 [get_ports {vgaRed[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[1]}]
set_property PACKAGE_PIN J19 [get_ports {vgaRed[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[2]}]
set_property PACKAGE_PIN N19 [get_ports {vgaRed[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaRed[3]}]
set_property PACKAGE_PIN N18 [get_ports {vgaBlue[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[0]}]
set_property PACKAGE_PIN L18 [get_ports {vgaBlue[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[1]}]
set_property PACKAGE_PIN K18 [get_ports {vgaBlue[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[2]}]
set_property PACKAGE_PIN J18 [get_ports {vgaBlue[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaBlue[3]}]
set_property PACKAGE_PIN J17 [get_ports {vgaGreen[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[0]}]
set_property PACKAGE_PIN H17 [get_ports {vgaGreen[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[1]}]
set_property PACKAGE_PIN G17 [get_ports {vgaGreen[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[2]}]
set_property PACKAGE_PIN D17 [get_ports {vgaGreen[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {vgaGreen[3]}]
set_property PACKAGE_PIN P19 [get_ports Hsync]
	set_property IOSTANDARD LVCMOS33 [get_ports Hsync]
set_property PACKAGE_PIN R19 [get_ports Vsync]
	set_property IOSTANDARD LVCMOS33 [get_ports Vsync]


#USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports rx_in]
	set_property IOSTANDARD LVCMOS33 [get_ports rx_in]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
