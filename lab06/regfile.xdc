#xdc for regfile_top.sv

# Clock signal
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# Switches
set_property PACKAGE_PIN V17 [get_ports {data_in[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[0]}]
set_property PACKAGE_PIN V16 [get_ports {data_in[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[1]}]
set_property PACKAGE_PIN W16 [get_ports {data_in[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[2]}]
set_property PACKAGE_PIN W17 [get_ports {data_in[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {data_in[3]}]
set_property PACKAGE_PIN U1 [get_ports {addr[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {addr[0]}]
set_property PACKAGE_PIN T1 [get_ports {addr[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {addr[1]}]
set_property PACKAGE_PIN R2 [get_ports {addr[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {addr[2]}]

#Buttons
set_property PACKAGE_PIN U18 [get_ports btnc]
	set_property IOSTANDARD LVCMOS33 [get_ports btnc]
set_property PACKAGE_PIN T17 [get_ports btnr]
	set_property IOSTANDARD LVCMOS33 [get_ports btnr]
set_property PACKAGE_PIN U17 [get_ports btnd]
	set_property IOSTANDARD LVCMOS33 [get_ports btnd]

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


## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
