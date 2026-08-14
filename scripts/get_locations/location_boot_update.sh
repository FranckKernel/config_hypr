#!/usr/bin/env bash
# This script allows the reloading of hyprland to be done asynchronously. So it reloads it with the proper config file once it has gotten the correct information
# It is being executed by: $HOME/.config/systemd/user/hypr-location.service

set -eou pipefail
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

LOCATION_FILE="$HOME/.config/hypr/ignore/current_location.txt"

cd "$HOME/.config/hypr/scripts/get_locations" || {
	notify-send "Dir missing"
	exit 1
}

# Check if its present, if not try to set it
if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
	export HYPRLAND_INSTANCE_SIGNATURE="$(ls -t "$XDG_RUNTIME_DIR/hypr" 2>/dev/null | head -n1)"
fi
# Fail early if we still can't find it
if [[ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
	notify-send "Location Script" "Cannot find Hyprland instance signature!"
	exit 1
fi

geoclue_location_script="./get_location.py"
wifi_name_location_script="./get_location_wifi_pattern.py"
quick_ethernet_check_location_script="./quick_ethernet_check.py"

# used_location_script="$geoclue_location_script"
# used_location_script="$wifi_name_location_script"
used_location_script="$quick_ethernet_check_location_script"

pre_change_location="$(cat "$LOCATION_FILE")"

# If it breaks, then we can

# test=$(hyprctl monitors | head -n 1)
# notify-send "$test"

if [[ ! -f "$used_location_script" ]]; then
	notify-send "Error" "Python script not found: $used_location_script"
	exit 2
fi

python "$used_location_script" || {
	notify-send "python failed"
	exit 3
}

post_change_location="$(cat "$LOCATION_FILE")"

if [[ "$pre_change_location" != "$post_change_location" ]]; then
	hyprctl reload || {
		notify-send "Hyprland reload failed (check config syntax)"
		exit 4
	}
	notify-send "Reloading"
fi

notify-send "Script has run fully"
