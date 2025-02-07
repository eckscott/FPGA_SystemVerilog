sim_testbench:
	xvlog arithmetic_top.sv tb_arithmetic.sv -sv --nolog
	xelab tb_arithmetic -debug typical --nolog
	xsim tb_arithmetic -log testbench.log --runall

synth_logic:
	vivado -mode batch -source synth_logic.tcl -log synth_logic.log -nojournal -notrace

implement_logic:
	vivado -mode batch -source implement_logic.tcl -log implement_logic.log -nojournal -notrace

clean:
	rm -f *.bit *.jou *.txt *.pb *.wdb *.dcp *.log *.rpt
	rm -rf xsim.dir/ .Xil/