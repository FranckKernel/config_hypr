#!/bin/bash

LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

case $LAYOUT in
"dwindle")
	# hyprctl keyword unbind SUPER,I
	# hyprctl keyword unbind SUPER,D

	hyprctl keyword unbind SUPER, E
	hyprctl keyword unbind SUPER, R
	hyprctl keyword unbind SUPER, U
	hyprctl keyword unbind SUPER, I

	hyprctl keyword unbind SUPER, J
	hyprctl keyword unbind SUPER, K
	hyprctl keyword unbind SUPERSHIFT, J
	hyprctl keyword unbind SUPERSHIFT, K
	hyprctl keyword unbind SUPER, M
	hyprctl keyword unbind SUPERSHIFT, M
	hyprctl keyword unbind SUPER, period
	hyprctl keyword unbind SUPER, comma

	hyprctl keyword bind SUPER, J, cyclenext
	hyprctl keyword bind SUPER, K, cyclenext,prev
	hyprctl keyword bind SUPER, V, togglesplit
	hyprctl keyword bind SUPER, O, pseudo
	hyprctl keyword bind SUPERSHIFT, O, exec, hyprctl dispatch workspaceopt allpseudo
	# notify-send -i "$HOME/.config/hypr/mako/icons/hyprland.png" -t 1000 "Layout" "Dwindle"
	;;
"master")
	hyprctl keyword unbind SUPER,J
	hyprctl keyword unbind SUPER,K
	hyprctl keyword unbind SUPER,V
	hyprctl keyword unbind SUPER,O
	hyprctl keyword unbind SUPERSHIFT,O

	# hyprctl keyword bind SUPER,I,layoutmsg,addmaster
	# hyprctl keyword bind SUPER,D,layoutmsg,removemaster

	hyprctl keyword bind SUPER, E, layoutmsg, mfact -0.025
	hyprctl keyword bind SUPER, R, layoutmsg, mfact +0.025
	hyprctl keyword bind SUPER, U, layoutmsg, rollprev
	hyprctl keyword bind SUPER, I, layoutmsg, rollnext

	hyprctl keyword bind SUPER, J, layoutmsg, cyclenext
	hyprctl keyword bind SUPER, K, layoutmsg, cycleprev
	hyprctl keyword bind SUPERSHIFT, J, layoutmsg, swapnext
	hyprctl keyword bind SUPERSHIFT, K, layoutmsg, swapprev
	hyprctl keyword bind SUPER, M, layoutmsg, focusmaster
	hyprctl keyword bind SUPERSHIFT, M, layoutmsg, swapwithmaster
	hyprctl keyword bind SUPER, period, layoutmsg, orientationnext
	hyprctl keyword bind SUPER, comma, layoutmsg, orientationprev
	# notify-send -i "$HOME/.config/hypr/mako/icons/hyprland.png" -t 1000 "Layout" "Master"
	;;
*) ;;

esac

