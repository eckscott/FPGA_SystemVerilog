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
    tester = test_suite_320.build_test_suite_320("lab10", start_date="03/17/2025")
    tester.add_required_tracked_files(["tx.sv","tx_top.sv", "sim_tx.tcl",
                                       "sim_tx.png", "sim_tx_top.tcl", "sim_tx_top.png",
                                       "tx_demo.png"])
    tester.add_Makefile_rule("sim_tx_tb", ["tx.sv"], ["sim_tx_tb.log"])
    tester.add_build_test(repo_test.file_regex_check("sim_tx_tb.log", "Simulation done with 0 errors", 
                                                     "Tx Testbench Test", error_on_match = False,
                                                     error_msg = "Tx Test failed"))
    tester.add_Makefile_rule("synth", ["tx.sv", "tx_top.sv"], ["synthesis.log", "tx_top_synth.dcp"])
    tester.add_Makefile_rule("implement", ["tx_top_synth.dcp"], ["implement.log", "tx_top.bit", 
                                            "tx_top.dcp", "utilization.rpt", "timing.rpt"])
    tester.run_tests()

if __name__ == "__main__":
    main()

