#!/usr/bin/env bash

feh --bg-fill \
    ~/Pictures/main_monitor_wallpaper.jpg \
    ~/Pictures/left_monitor_wallpaper.jpg \
    ~/Pictures/right_monitor_wallpaper.jpg

xrandr \
    --output DP-2 --off \
    --output DP-0 --primary --mode 3840x2160 --rate 144 --pos 2304x0 --scale 1x1 \
    --output HDMI-0 --mode 1920x1080 --rate 144 --pos 0x0 --scale 1.2x1.2 \
    --output DP-3 --mode 1920x1080 --rotate left --pos 6144x0 --scale 1.2x1.2
