#!/bin/bash 

notify-send "reset wallpaper"

pkill -9 hyprpaper 
hyprpaper & 
