sim_decrypt_rc4:
	xvlog decrypt_rc4.sv -sv --nolog
	xelab decrypt_rc4 -debug typical --nolog
	xsim decrypt_rc4 -gui -tclbatch sim_decrypt_rc4.tcl --nolog 

sim_tb_codebreaker:
	xvlog decrypt_rc4.sv codebreaker.sv tb_codebreaker.sv -sv --nolog
	xelab tb_codebreaker -debug typical --nolog
	xsim tb_codebreaker -log sim_chargen_tb.log -gui

sim_chargen_top:
	xvlog chargen_top.sv decrypt_rc4.sv font_rom.sv -sv --nolog
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
	python3 lab13_passoff.py --submit

download:
	python3 ../resources/openocd.py chargen_top.bit

clean:
	rm -f *.bit *.jou *.charGent *.pb *.wdb *.dcp *.log *.rpt *.str *.mem
	rm -rf xsim.dir/ .Xil/
	find . -name "*.txt" ! -name "mymessage.txt" -exec rm -f {} \;