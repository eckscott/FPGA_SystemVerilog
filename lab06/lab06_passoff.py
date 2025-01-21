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
    tester = test_suite_320.build_test_suite_320("lab06", start_date="02/17/2025")
    tester.add_required_tracked_files(["sim_reg4.tcl", "sim_reg4.png", "regfile.sv", "regfile_top.sv",])
    tester.add_Makefile_rule("sim_regfile", ["regfile.sv"], ["sim_regfile.log"])
    tester.add_build_test(repo_test.file_regex_check("sim_regfile.log", "\*\*\* Error", "Testbench Log Test"))
    tester.add_Makefile_rule("synth", [], ["synthesis.log", "regfile_top_synth.dcp"])
    tester.add_Makefile_rule("implement", ["regfile_top_synth.dcp"], ["implement.log", "regfile_top.bit", 
                                            "regfile_top.dcp", "utilization.rpt"])
    tester.run_tests()

if __name__ == "__main__":
    main()

