#!/usr/bin/env nu

hyprctl reload
sleep 500ms

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
