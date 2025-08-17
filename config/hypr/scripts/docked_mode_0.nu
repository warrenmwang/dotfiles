#!/usr/bin/env nu

hyprctl reload
sleep 500ms

mut found_external_monitor = false
let found_monitors = hyprctl monitors -j | from json | get name
let found_named_tablets = hyprctl devices -j | from json | get tablets | each { |row| $row.name? }

if ($found_monitors | length) == 0 {
    notify-send "No external monitor found"
}

if "HDMI-A-1" in $found_monitors {
    hyprctl keyword monitor "HDMI-A-1, 1920x1080@144, 1920x0, 1"
    hyprctl keyword workspace "1,monitor:HDMI-A-1,default:true"
    if "wacom-intuos-bt-m-pen" in $found_named_tablets {
        hyprctl keyword "device:wacom-intuos-bt-m-pen:output" "HDMI-A-1"
    }
    $found_external_monitor = true
}

if "DP-2" in $found_monitors {
    hyprctl keyword monitor "DP-2, 1920x1080@60, 0x0, 1"
    hyprctl keyword workspace "5,monitor:DP-2,default:true"
    $found_external_monitor = true
}

if $found_external_monitor {
    hyprctl keyword monitor "eDP-1, disable"
} else {
    notify-send "No external monitor found for this docked config." "Leaving built-in display connected and on!"
}

# map workspaces from singular monitor mode to assumed multiple monitors docked setup
let workspace_mapping = [
    [workspace, monitor];
    [1, "HDMI-A-1"]
    [2, "HDMI-A-1"] 
    [3, "HDMI-A-1"]
    [4, "HDMI-A-1"]
    [5, "DP-2"]
    [6, "DP-2"]
    [7, "HDMI-A-1"]
    [8, "HDMI-A-1"]
    [9, "HDMI-A-1"]
    [10, "HDMI-A-1"]
]
$workspace_mapping | each { |row| hyprctl dispatch moveworkspacetomonitor $row.workspace $row.monitor }
