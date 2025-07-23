#!/usr/bin/env nu

hyprctl keyword monitor "HDMI-A-1, disable"
hyprctl keyword monitor "DP-2, disable"
hyprctl keyword monitor "eDP-1, 2560x1440@240, 0x0, 1"
hyprctl keyword "device:wacom-intuos-bt-m-pen:output" "eDP-1"

1..10 | each { |i| hyprctl dispatch moveworkspacetomonitor $i "eDP-1" }
