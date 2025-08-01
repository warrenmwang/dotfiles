#!/usr/bin/env nu

hyprctl keyword monitor "eDP-1, 2560x1440@240, 0x0, 1.25"

let found_monitors = hyprctl monitors -j | from json | get name
for monitor in $found_monitors {
    match $monitor {
        "HDMI-A-1" => {
            hyprctl keyword monitor "HDMI-A-1, disable"
        }
        "DP-2" => {
            hyprctl keyword monitor "DP-2, disable"
        }
    }
}

let found_named_tablets = hyprctl devices -j | from json | get tablets | each { |row| $row.name? }
for tablet in found_named_tablets {
    match $tablet {
        "wacom-intuos-bt-m-pen" => {
            hyprctl keyword "device:wacom-intuos-bt-m-pen:output" "eDP-1"
        }
    }
}

1..10 | each { |i| hyprctl dispatch moveworkspacetomonitor $i "eDP-1" }
