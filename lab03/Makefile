sim_tb:
	xvlog logic_functions.sv tb_logic_functions.sv -sv --nolog
	xelab tb_logic_functions -debug typical --nolog
	xsim tb_logic_functions -log testbench.log --runall

synth_logic:
	vivado -mode batch -source synth_logic.tcl -log synth_logic.log -nojournal -notrace

implement_logic:
	vivado -mode batch -source implement_logic.tcl -log implement_logic.log -nojournal -notrace

clean:
	rm -f *.bit *.jou *.txt *.pb *.wdb *.dcp *.log *.rpt
	rm -rf xsim.dir/ .Xil/