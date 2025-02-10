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
    tester = test_suite_320.build_test_suite_320("lab08", start_date="03/03/2025")
    tester.add_required_tracked_files(["vga_timing.sv","vga_top.sv", "sim_top_vga.tcl",
                                       "sim_vga_top.png", "pixel_x.png"])
    tester.add_Makefile_rule("sim_vga_timing", ["vga_timing.sv"], ["sim_vga_timing.log"])
    tester.add_build_test(repo_test.file_regex_check("sim_vga_timing.log", "COMPLETED SUCCESSFULLY with 0 errors", 
                                                     "VGA Timing Test", error_on_match = False,
                                                     error_msg = "VGA Timing Test failed"))
    tester.add_Makefile_rule("synth", ["vga_timing.sv", "vga_top.sv"], ["synthesis.log", "vga_top_synth.dcp"])
    tester.add_Makefile_rule("implement", ["vga_top_synth.dcp"], ["implement.log", "vga_top.bit", 
                                            "vga_top.dcp", "utilization.rpt", "timing.rpt"])
    tester.run_tests()

if __name__ == "__main__":
    main()

