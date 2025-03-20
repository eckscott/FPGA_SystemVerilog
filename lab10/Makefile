sim_tx:
	xvlog tx.sv -sv --nolog
	xelab tx -debug typical --nolog
	xsim tx -gui --nolog

sim_tx_tb:
	xvlog tx.sv tb_tx.sv -sv --nolog
	xelab tb_tx -debug typical --nolog
	xsim tb_tx -log sim_tx.log --runall

sim_tx_top:
	xvlog tx_top.sv tx.sv -sv --nolog
	xvlog ../lab07/seven_segment4.sv -sv --nolog
	xvlog ../lab09/debounce.sv -sv --nolog
	xelab tx_top -debug typical --nolog
	xsim tx_top -gui -tclbatch sim_tx_top.tcl --nolog

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

clean:
	rm -f *.bit *.jou *.txt *.pb *.wdb *.dcp *.log *.rpt *.str
	rm -rf xsim.dir/ .Xil/