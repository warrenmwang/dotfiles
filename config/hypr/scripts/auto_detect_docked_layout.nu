#!/usr/bin/env nu

let found_monitors = hyprctl monitors -j | from json | get name

if "HDMI-A-1" in $found_monitors and "DP-2" in $found_monitors {
    const docked_mode_script = path self ./docked_mode_0.nu
    run-external $docked_mode_script
    exit
}

if "DP-1" in $found_monitors {
    const docked_mode_script = path self ./docked_mode_1.nu
    run-external $docked_mode_script
    exit
}