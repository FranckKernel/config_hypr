#!/bin/bash


# Get the YouTube Music Chromium MPRIS player instance
YoutubeMusicPlayer=$(playerctl -l | grep chromium | head -n 1)

# Check if a Chromium-based player was found
if [[ -z $YoutubeMusicPlayer ]]; then
  echo "YouTube Music player not found. Ensure the YouTube Music tab is active and playing."
  exit 1
fi

# Pass arguments to the identified player
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <command>"
  echo "Example commands: play, pause, next, previous, metadata or -h for playerctl help"
  exit 1
fi

playerctl --player="$YoutubeMusicPlayer" "$@"

