sim_charGen:
	xvlog charGen.sv font_rom.sv -sv --nolog
	xelab charGen -debug typical --nolog
	xsim charGen -gui -tclbatch sim_charGen.tcl --nolog

sim_rx_tb:
	xvlog charGen.sv tb_rx.sv -sv --nolog
	xelab tb_rx -debug typical --nolog
	xsim tb_rx -log sim_rx_tb.log --runall

sim_rx_top:
	xvlog rx_top.sv charGen.sv -sv --nolog
	xvlog ../lab07/seven_segment4.sv -sv --nolog
	xelab rx_top -debug typical --nolog
	xsim rx_top -gui -tclbatch sim_rx_top.tcl --nolog

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

update:
	git fetch startercode
	git merge startercode/main -m "Merging starter code"
	git push

submit:
	python3 lab11_passoff.py --submit

clean:
	rm -f *.bit *.jou *.rxt *.pb *.wdb *.dcp *.log *.rpt *.str *.txt
	rm -rf xsim.dir/ .Xil/