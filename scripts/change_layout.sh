#!/bin/bash

LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

case $LAYOUT in
"master")
	hyprctl keyword general:layout dwindle
	# notify-send -i "$HOME/.config/hypr/mako/icons/hyprland.png" -t 1000 "Layout" "Dwindle"
	$HOME/.config/hypr/refresh_layout.sh
	;;
"dwindle")
	hyprctl keyword general:layout master
	# notify-send -i "$HOME/.config/hypr/mako/icons/hyprland.png" -t 1000 "Layout" "Master"
	$HOME/.config/hypr/refresh_layout.sh
	;;
*) ;;

esac




