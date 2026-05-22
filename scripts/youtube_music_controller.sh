#!/usr/bin/env bash

MUSIC_PATTERN="chromium"
VIDEO_PATTERN="firefox"

# Require first argument
if [[ $# -lt 1 ]]; then
	echo "Usage: $0 {music|video} <playerctl command>"
	exit 1
fi

case "$1" in
music)
	player_pattern="$MUSIC_PATTERN"
	;;
video)
	player_pattern="$VIDEO_PATTERN"
	;;
*)
	echo "First argument must be 'music' or 'video'"
	exit 1
	;;
esac

# Remove selector argument
shift

# Ensure a playerctl command remains
if [[ $# -eq 0 ]]; then
	echo "Provide a playerctl command (play, pause, next, metadata, etc.)"
	exit 1
fi

player=$(playerctl -l | grep "^$player_pattern" | head -n1)

if [[ -z "$player" ]]; then
	echo "No active player found for $player_pattern"
	exit 1
fi

playerctl --player="$player" "$@"
