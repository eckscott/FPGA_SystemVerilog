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
    tester = test_suite_320.build_test_suite_320("lab12", max_repo_files = 30, start_date="03/31/2025")
    tester.add_required_tracked_files(["charGen.sv","sim_charGen.tcl","sim_charGen.png", 
                                       "chargen_top.sv", "sim_chargen_top.tcl", "sim_chargen_top.png", 
                                       "mymessage.txt","fontrom.png",])
    tester.add_Makefile_rule("sim_chargen_tb", ["charGen.sv"], ["sim_chargen_tb.log"])
    tester.add_build_test(repo_test.file_regex_check("sim_chargen_tb.log", "Simulation done with 0 errors", 
                                                     "CharGen Testbench Test", error_on_match = False,
                                                     error_msg = "CharGen Testbench failed"))
    tester.add_Makefile_rule("mymessage.mem", ["mymessage.txt"], ["mymessage.mem"])
    tester.add_Makefile_rule("synth", ["charGen.sv", "chargen_top.sv"], ["synthesis.log", "chargen_top_synth.dcp"])
    tester.add_Makefile_rule("implement", ["chargen_top_synth.dcp"], ["implement.log", "chargen_top.bit", 
                                            "chargen_top.dcp", "utilization.rpt", "timing.rpt"])
    tester.run_tests()

if __name__ == "__main__":
    main()

