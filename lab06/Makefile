sim_regfile:
	xvlog regfile.sv reg4.sv tb_regfile.sv -sv FDCE.v --nolog
	xelab tb_regfile -debug typical --nolog
	xsim tb_regfile -log sim_regfile.log --runall

sim_regfile_top:
	xvlog regfile_top.sv regfile.sv seven_segment.sv reg4.sv -sv FDCE.v   --nolog
	xelab regfile_top -debug typical -L unisims_ver --timescale 1ns/1ps --nolog glbl
	xsim regfile_top#work.glbl --nolog

synth:
	vivado -mode batch -source synth.tcl -log synthesis.log -nojournal -notrace

implement:
	vivado -mode batch -source implement.tcl -log implement.log -nojournal -notrace

clean:
	rm -f *.bit *.jou *.txt *.pb *.wdb *.dcp *.log *.rpt
	rm -rf xsim.dir/ .Xil/