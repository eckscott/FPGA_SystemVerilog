#!/usr/bin/python3

# Manages file paths
import pathlib
import sys

sys.dont_write_bytecode = True # Prevent the bytecodes for the resources directory from being cached
# Add to the system path the "resources" directory relative to the script that was run
resources_path = pathlib.Path(__file__).resolve().parent.parent  / 'resources'
sys.path.append( str(resources_path) )

import test_suite_320
import repo_test

def main():
    tester = test_suite_320.build_test_suite_320("lab13", max_repo_files = 30, start_date="04/7/2025")
    tester.add_required_tracked_files(["codebreaker.sv","codebreaker_top.sv",
                                       "sim_decrypt_rc4.tcl", "sim_decrypt_rc4.png", "background.txt",
                                       "sim_codebreaker_top.tcl", "codebreaker_top.png", "cipher_update.png", "write_vga.png", 
                                       ])
    tester.add_Makefile_rule("sim_tb_codebreaker", ["codebreaker.sv"], ["sim_tb_codebreaker.log"])
    tester.add_build_test(repo_test.file_regex_check("sim_tb_codebreaker.log", "SUCCESS: Key found: 000005", 
                                                     "Codebreaker Testbench Test", error_on_match = False,
                                                     error_msg = "Codebreaker Testbench failed"))
    tester.add_Makefile_rule("background.mem", ["background.txt"], ["background.mem"])
    tester.add_Makefile_rule("synth", ["codebreaker.sv", "codebreaker_top.sv"], ["synthesis.log", "codebreaker_top_synth.dcp"])
    tester.add_Makefile_rule("implement", ["codebreaker_top_synth.dcp"], ["implement.log", "codebreaker_top.bit", 
                                            "codebreaker_top.dcp", "utilization.rpt", "timing.rpt"])
    tester.run_tests()

if __name__ == "__main__":
    main()

