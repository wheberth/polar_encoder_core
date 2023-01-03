# package require fileutil

create_project -force $::env(TOP) ./$::env(TOP)_prj ; #-part {xczu27dr-fsvg1517-1-e}

# Add various sources to the project
add_files -fileset sources_1 $::env(SRCS)
add_files -fileset sim_1 $::env(SIM_SRCS)
#add_files -fileset constrs_1 ./Sources/bft_full.xdc

# Import/copy the files into the project
# import_files -force

set_property "top" $::env(TOP) [get_filesets sources_1]
set_property "top" $::env(SIM_TOP) [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

start_gui
launch_simulation

# Add waveform config
source $::env(PRJROOT)/tcl/show_wave.tcl
add_files -fileset sim_1 $wave_config_file
