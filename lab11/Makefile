sim_rx:
	xvlog rx.sv -sv --nolog
	xelab rx -debug typical --nolog
	xsim rx -gui -tclbatch sim_rx.tcl --nolog

sim_rx_tb:
	xvlog rx.sv tb_rx.sv -sv --nolog
	xelab tb_rx -debug typical --nolog
	xsim tb_rx -log sim_rx_tb.log --runall

sim_rx_top:
	xvlog rx_top.sv rx.sv -sv --nolog
	xvlog ../lab07/seven_segment4.sv -sv --nolog
	xelab rx_top -debug typical --nolog
	xsim rx_top -gui -tclbatch sim_rx_top.tcl --nolog

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

clean:
	rm -f *.bit *.jou *.rxt *.pb *.wdb *.dcp *.log *.rpt *.str
	rm -rf xsim.dir/ .Xil/