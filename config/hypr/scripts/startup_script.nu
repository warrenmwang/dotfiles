#!/usr/bin/env nu

let found_monitors = hyprctl monitors -j | from json | get name
let expected_monitors = ["HDMI-A-1" "DP-2"]

mut found_docked_monitor = false
for monitor in $expected_monitors {
    if $monitor in $found_monitors {
        $found_docked_monitor = true
    }
}

if $found_docked_monitor {
    const docked_mode_script = path self ./docked_mode.nu
    run-external $docked_mode_script
}