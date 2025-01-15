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
    tester = test_suite_320.build_test_suite_320("lab05", start_date="02/10/2025")
    tester.add_required_tracked_files(["seven_segment.sv", "sevent_segment_top.sv", "sim_seven_segment_top.png", 
                                       "segment_lut.png"])
    tester.add_Makefile_rule("sim_sevensegment", ["seven_segment.sv"], ["sim_sevensegment.log"])
    tester.add_build_test(repo_test.file_regex_check("sim_sevensegment.log", "*** Error", "Testbench Log Test"))
    tester.add_Makefile_rule("synth", [], ["synthesis.log", "seven_segment_synth.dcp"])
    tester.add_Makefile_rule("implement", ["sevent_segment_synth.dcp"], ["implement.log", "seven_segment.bit", 
                                            "seven_segment.dcp", "utilization.rpt"])
    tester.run_tests()

if __name__ == "__main__":
    main()
