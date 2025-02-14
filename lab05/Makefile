sim_sevensegment:
	xvlog seven_segment.sv tb_sevensegment.sv -sv --nolog
	xelab tb_sevensegment -debug typical -L unisims_ver --timescale 1ns/1ps --nolog
	xsim tb_sevensegment -log sim_sevensegment.log --runall

clean:
	rm -f *.bit *.jou *.txt *.pb *.wdb *.dcp *.log *.rpt
	rm -rf xsim.dir/ .Xil/