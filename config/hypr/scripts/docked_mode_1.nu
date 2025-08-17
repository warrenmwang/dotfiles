#!/usr/bin/env nu

let found_monitors = hyprctl monitors -j | from json | get name
let found_named_tablets = hyprctl devices -j | from json | get tablets | each { |row| $row.name? }

if "DP-1" in $found_monitors {
    hyprctl keyword monitor "DP-1, 3840x2160@144, 0x0, 1.5"
    hyprctl keyword monitor "eDP-1, 2560x1440@240, 2560x0, 1.25"
    if "wacom-intuos-bt-m-pen" in $found_named_tablets {
        hyprctl keyword "device:wacom-intuos-bt-m-pen:output" "DP-1"
    }
}