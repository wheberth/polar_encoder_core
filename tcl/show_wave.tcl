package require fileutil
set wave_config_file $::env(PRJROOT)/tb/$::env(SIM_TOP).wcfg

if {! [file exist $wave_config_file]} {
    create_wave_config
    add_wave /
    save_wave_config $wave_config_file
    # set_property needs_save false [current_wave_config]
} else {
    open_wave_config $wave_config_file
}


