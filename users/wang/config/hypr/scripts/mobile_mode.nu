#!/usr/bin/env nu

# TODO: there is a something wrong about this script where if are in a docked mode and unplug the montiors then
# try to run this script it just won't do it
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
            hyprctl keyword "device[wacom-intuos-bt-m-pen]:output" "eDP-1"
        }
    }
}

hyprctl workspaces -j | from json | get id | each { |i| hyprctl dispatch moveworkspacetomonitor $i "eDP-1" }

# Laptop multimedia keys for volume and LCD brightness
hyprctl keyword bindel ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
hyprctl keyword bindel ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
hyprctl keyword bindel ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
hyprctl keyword bindel ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
# hyprctl keyword bindel ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
# hyprctl keyword bindel ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
