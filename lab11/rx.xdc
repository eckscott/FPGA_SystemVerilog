# /*************************************************************************************
# *
# * Filename: rx.xdc
# * 
# * author: Ethan Scott
# * Description: This is a .xdc file to connect the rx_top module to the BASYS3 board
# *              
# *
# *************************************************************************************/
# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -period 10.00 [get_ports clk]

## LEDs
set_property PACKAGE_PIN U16 [get_ports {rx_debug}]
	set_property IOSTANDARD LVCMOS33 [get_ports {rx_debug}]
set_property PACKAGE_PIN L1 [get_ports {parityErr}]
	set_property IOSTANDARD LVCMOS33 [get_ports {parityErr}]

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
set_property PACKAGE_PIN U17 [get_ports btnd]
	set_property IOSTANDARD LVCMOS33 [get_ports btnd]

#USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports rx_in]
	set_property IOSTANDARD LVCMOS33 [get_ports rx_in]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
