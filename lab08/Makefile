sim_vga_timing:
	xvlog vga_timing.sv tb_vga_timing.sv -sv --nolog
	xelab tb_vga_timing -debug typical --nolog
	xsim tb_vga_timing -log sim_vga_timing.log --runall

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