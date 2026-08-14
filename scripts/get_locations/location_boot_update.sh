#!/usr/bin/env bash
# This script allows the reloading of hyprland to be done asynchronously. So it reloads it with the proper config file once it has gotten the correct information
# It is being executed by: $HOME/.config/systemd/user/hypr-location.service

set -eou pipefail
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

LOCATION_FILE="$HOME/.config/hypr/ignore/current_location.txt"
MONITOR_FILE="$HOME/.config/hypr/ignore/plugged_monitors.txt"

NOTIFY_APP_NAME="Location Script"
NOTIFY_DURATION_MS=5000
NOTIFY_FALLBACK_FILE="$HOME/.config/hypr/ignore/location_notifications.log"

NOTIFY_READY=false
NOTIFY_TIMEOUT_SECONDS=10

wait_for_notifications() {
	local deadline=$((SECONDS + NOTIFY_TIMEOUT_SECONDS))

	while ! busctl --user --quiet status org.freedesktop.Notifications >/dev/null 2>&1; do
		if ((SECONDS >= deadline)); then
			return 1
		fi

		sleep 0.2
	done
}

init_notifications() {
	mkdir -p "$(dirname "$NOTIFY_FALLBACK_FILE")"

	if wait_for_notifications; then
		NOTIFY_READY=true
	else
		NOTIFY_READY=false
	fi
}

notify_msg() {
	local content="$1"
	local title2="${2:-}"
	# One day if i switch my config of
	# mako or another notification daemon, we might use title2

	# simply comment out this line, and then title2 will be usable. Do so when appname is already visible in the
	# notification deamon. Appname will be title1
	local display_title2="$NOTIFY_APP_NAME"

	if [[ "$NOTIFY_READY" == true ]]; then
		notify-send \
			-a "$NOTIFY_APP_NAME" \
			-t "$NOTIFY_DURATION_MS" \
			"$display_title2" \
			"$content"
	else
		printf '[%s] %s: %s — %s\n' \
			"$(date '+%Y-%m-%d %H:%M:%S')" \
			"$content" \
			"$NOTIFY_APP_NAME" \
			"$title2" >>"$NOTIFY_FALLBACK_FILE"
	fi

}

init_notifications

cd "$HOME/.config/hypr/scripts/get_locations" || {
	notify_msg "Dir missing"
	exit 1
}

# Check if its present, if not try to set it
if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
	export HYPRLAND_INSTANCE_SIGNATURE="$(ls -t "$XDG_RUNTIME_DIR/hypr" 2>/dev/null | head -n1)"
fi
# Fail early if we still can't find it
if [[ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
	notify_msg "Location Script" "Cannot find Hyprland instance signature!"
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
# notify_msg "$test"

if [[ ! -f "$used_location_script" ]]; then
	notify_msg "Error" "Python script not found: $used_location_script"
	exit 2
fi

python "$used_location_script" || {
	notify_msg "python failed"
	exit 3
}

post_change_location="$(cat "$LOCATION_FILE")"

# Always update monitor information
monitors=$(hyprctl monitors -j | jq -r '.[].name')
monitor_count=$(printf '%s\n' "$monitors" | sed '/^$/d' | wc -l)

{
	echo "$monitor_count"
	printf '%s\n' "$monitors"
} >"$MONITOR_FILE"

if [[ "$pre_change_location" != "$post_change_location" ]]; then
	hyprctl reload || {
		notify_msg "Hyprland reload failed (check config syntax)"
		exit 4
	}
	notify_msg "Reloading"
fi

notify_msg "Script has run fully"
