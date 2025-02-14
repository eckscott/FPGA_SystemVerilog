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
    tester = test_suite_320.build_test_suite_320("lab07", start_date="02/24/2025")
    tester.add_required_tracked_files(["seven_segment4.sv","ssd_top.sv", "multisegment_FDCE_0.png"])
    tester.add_Makefile_rule("sim_multisegment", ["seven_segment4.sv"], ["sim_multisegment.log"])
    tester.add_build_test(repo_test.file_regex_check("sim_multisegment.log", "ERROR", "Testbench Log 'No Error' Test",
                                                     error_msg = "Error in testbench log"))
    tester.add_build_test(repo_test.file_regex_check("sim_multisegment.log", "Correct anode segment timing = ", 
                                                     "Testbench Log 'correct anode timing' test", error_on_match = False,
                                                     error_msg = "Incorrect anode segment timing"))
    tester.add_Makefile_rule("synth", ["seven_segment4.sv", "ssd_top.sv"], ["synthesis.log", "multisegment_synth.dcp"])
    tester.add_Makefile_rule("implement", ["multisegment_synth.dcp"], ["implement.log", "multisegment.bit", 
                                            "multisegment.dcp", "utilization.rpt", "timing.rpt"])

    tester.run_tests()

if __name__ == "__main__":
    main()

