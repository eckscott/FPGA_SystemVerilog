sim_charGen:
	xvlog charGen.sv font_rom.sv -sv --nolog
	xelab charGen -debug typical --nolog
	xsim charGen -tclbatch sim_charGen.tcl --nolog

sim_chargen_tb:
	xvlog charGen.sv font_rom.sv tb_charGen.sv -sv --nolog
	xelab tb_charGen -debug typical --nolog
	xsim tb_charGen -log sim_chargen_tb.log

sim_charGen_top:
	xvlog chargen_top.sv charGen.sv font_rom -sv --nolog
	xvlog ../lab07/seven_segment4.sv -sv --nolog
	xelab charGen_top -debug typical --nolog
	xsim charGen_top -gui -tclbatch sim_charGen_top.tcl --nolog

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
	rm -f *.bit *.jou *.charGent *.pb *.wdb *.dcp *.log *.rpt *.str *.txt
	rm -rf xsim.dir/ .Xil/