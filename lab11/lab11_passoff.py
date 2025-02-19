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
    tester = test_suite_320.build_test_suite_320("lab11", start_date="03/24/2025")
    tester.add_required_tracked_files(["rx.sv","rx_top.sv", "sim_rx.tcl",
                                       "sim_rx.png", "sim_rx_top.tcl", "sim_rx_top.png", 
                                       "rx_ibuf.png",])
    tester.add_Makefile_rule("sim_rx_tb", ["rx.sv"], ["sim_rx_tb.log"])
    tester.add_build_test(repo_test.file_regex_check("sim_rx_tb.log", "Simulation done with 0 errors", 
                                                     "Rx Testbench Test", error_on_match = False,
                                                     error_msg = "Rx Testbench failed"))
    tester.add_Makefile_rule("synth", ["rx.sv", "rx_top.sv"], ["synthesis.log", "rx_top_synth.dcp"])
    tester.add_Makefile_rule("implement", ["rx_top_synth.dcp"], ["implement.log", "rx_top.bit", 
                                            "rx_top.dcp", "utilization.rpt", "timing.rpt"])
    tester.run_tests()

if __name__ == "__main__":
    main()

