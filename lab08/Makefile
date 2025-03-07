sim_vga_timing:
	xvlog vga_timing.sv tb_vga_timing.sv -sv --nolog
	xelab tb_vga_timing -debug typical --nolog
	xsim tb_vga_timing -runall

sim_ssd_top:
	xvlog ssd_top.sv seven_segment4.sv -sv --nolog
	xelab ssd_top -debug typical --nolog
	xsim ssd_top --nolog

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

clean:
	rm -f *.bit *.jou *.txt *.pb *.wdb *.dcp *.log *.rpt
	rm -rf xsim.dir/ .Xil/