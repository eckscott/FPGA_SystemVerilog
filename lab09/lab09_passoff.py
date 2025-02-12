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
    # Check on vivado
    tester = test_suite_320.build_test_suite_320("lab09", start_date="03/10/2025")
    tester.add_required_tracked_files(["debounce.sv","debounce_top.sv", "sim_vga_top.tcl",
                                       "sim_debounce.png", "sim_debounce_top.tcl"])
    tester.add_Makefile_rule("sim_debounce", ["debounce.sv"], ["sim_debounce.log"])
    tester.add_build_test(repo_test.file_regex_check("sim_debounce.log", "Simulation done, WAIT_TIME_US=5000 with 0 errors", 
                                                     "Debounce Testbench Test", error_on_match = False,
                                                     error_msg = "Debounce Test failed"))
    tester.add_Makefile_rule("sim_debounce_50", ["debounce.sv"], ["sim_debounce_50.log"])
    tester.add_build_test(repo_test.file_regex_check("sim_debounce_50.log", "Simulation done, WAIT_TIME_US=50 with 0 errors", 
                                                     "Debounce 50us Testbench Test", error_on_match = False,
                                                     error_msg = "Debounce 50us Test failed"))
    tester.add_Makefile_rule("synth", ["debounce.sv", "debounce_top.sv"], ["synthesis.log", "debounce_top_synth.dcp"])
    tester.add_Makefile_rule("implement", ["debounce_top_synth.dcp"], ["implement.log", "debounce_top.bit", 
                                            "debounce_top.dcp", "utilization.rpt", "timing.rpt"])
    tester.run_tests()

if __name__ == "__main__":
    main()

