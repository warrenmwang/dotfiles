#!/bin/bash
cp ~/.Xresources ./.Xresources
cp ~/.xinitrc ./.xinitrc
rsync -avh --delete ~/.config/i3/* .
