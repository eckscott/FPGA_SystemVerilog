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
    tester = test_suite_320.build_test_suite_320("lab04", start_date="02/03/2025")
    tester.add_required_tracked_files(["sim_FullAdd.tcl", "sim_Add8.tcl", "hierarchy.png", 
                                       "post-schematic.png"])
    tester.add_Makefile_rule("sim_testbench", [], ["testbench.log"])
    tester.add_build_test(repo_test.file_regex_check("testbench.log", "Error:", "Testbench Test"))
    tester.add_Makefile_rule("synth", [], ["synthesis.log", "arithmetic_top_synth.dcp"])
    tester.add_Makefile_rule("implement", [], ["implement.log", "arithmetic_top.bit", 
                                            "arithmetic_top.dcp", "utilization.rpt"])
    tester.run_tests()

if __name__ == "__main__":
    main()