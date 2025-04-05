sim_charGen:
	xvlog charGen.sv font_rom.sv -sv --nolog
	xelab charGen -debug typical --nolog
	xsim charGen -tclbatch sim_charGen.tcl --nolog 

sim_chargen_tb:
	xvlog charGen.sv font_rom.sv tb_charGen.sv -sv --nolog
	xelab tb_charGen -debug typical --nolog
	xsim tb_charGen -log sim_chargen_tb.log --runall

sim_chargen_top:
	xvlog chargen_top.sv charGen.sv font_rom.sv -sv --nolog
	xvlog ../lab07/seven_segment4.sv -sv --nolog
	xvlog ../lab08/vga_timing.sv -sv --nolog
	xvlog ../lab09/debounce.sv -sv --nolog
	xvlog ../lab11/rx.sv -sv --nolog
	xelab --debug typical chargen_top --generic_top "WAIT_TIME_US=50" --nolog
	xsim chargen_top -gui -tclbatch sim_chargen_top.tcl --nolog

mymessage.mem:
	python3 gen_initial_chars.py mymessage.txt mymessage.mem

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

update:
	git fetch startercode
	git merge startercode/main -m "Merging starter code"
	git push

submit:
	python3 lab12_passoff.py --submit

clean:
	rm -f *.bit *.jou *.charGent *.pb *.wdb *.dcp *.log *.rpt *.str *.mem
	rm -rf xsim.dir/ .Xil/
	find . -name "*.txt" ! -name "mymessage.txt" -exec rm -f {} \;