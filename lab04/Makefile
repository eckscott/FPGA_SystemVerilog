sim_testbench:
	xvlog arithmetic_top.sv tb_arithmetic.sv -sv --nolog
	xelab tb_arithmetic -debug typical --nolog
	xsim tb_arithmetic -log testbench.log --runall

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

clean:
	rm -f *.bit *.jou *.txt *.pb *.wdb *.dcp *.log *.rpt
	rm -rf xsim.dir/ .Xil/