sim_debounce:
	xvlog debounce.sv -sv --nolog
	xelab debounce -debug typical --nolog
	xsim debounce --nolog

sim_vga_top:
	xvlog vga_top.sv vga_timing.sv -sv --nolog
	xelab vga_top -debug typical --nolog
	xsim vga_top -gui --nolog

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

clean:
	rm -f *.bit *.jou *.txt *.pb *.wdb *.dcp *.log *.rpt *.str
	rm -rf xsim.dir/ .Xil/