#!/usr/bin/env nu

if (hyprctl monitors | str contains "eDP-1") {
    hyprctl keyword monitor "eDP-1, 2560x1440@60, 0x0, 1"
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:shadow:enabled false
    hyprctl keyword misc:vfr true
    
    notify-send "Battery saver on"
} else {
    notify-send "Battery saver skipped" "Built-in display is disabled"
}