sim_debounce:
	xvlog debounce.sv tb_debounce.sv -sv --nolog
	xelab tb_debounce -debug typical --nolog
	xsim tb_debounce -log sim_debounce.log --runall

sim_debounce_50:
	xvlog debounce.sv tb_debounce.sv -sv --nolog
	xelab --debug typical tb_debounce --generic_top "WAIT_TIME_US=50" --nolog
	xsim tb_debounce -log sim_debounce.log --runall

sim_debounce_top:
	xvlog debounce_top.sv debounce.sv -sv --nolog
	xvlog ../lab07/seven_segment4.sv -sv --nolog
	xelab debounce_top -debug typical --nolog
	xsim debounce_top -gui --nolog

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

clean:
	rm -f *.bit *.jou *.txt *.pb *.wdb *.dcp *.log *.rpt *.str
	rm -rf xsim.dir/ .Xil/