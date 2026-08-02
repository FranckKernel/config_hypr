#!/bin/bash

LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

case $LAYOUT in
"master")
	hyprctl eval 'hl.config({ general = { layout = "dwindle" } })'
	# notify-send -i "$HOME/.config/hypr/mako/icons/hyprland.png" -t 1000 "Layout" "Dwindle"
	"$HOME/.config/hypr/scripts/refresh_layout.sh"
	;;
"dwindle")
	hyprctl eval 'hl.config({ general = { layout = "master" } })'
	# notify-send -i "$HOME/.config/hypr/mako/icons/hyprland.png" -t 1000 "Layout" "Master"
	"$HOME/.config/hypr/scripts/refresh_layout.sh"
	;;
*) ;;

esac
