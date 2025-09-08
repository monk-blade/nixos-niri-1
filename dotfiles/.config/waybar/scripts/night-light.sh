#!/usr/bin/env bash

STATE_FILE="$HOME/.cache/night-light-state"

# Nerd Font icons
NIGHT_ON_ICON="d"  # moon icon
NIGHT_OFF_ICON="r" # sun icon

start_night_light() {
  # Kill any existing gammastep process
  pkill gammastep

  # Start gammastep with warm temperature
  gammastep -O 3500 &

  echo "on" >"$STATE_FILE"
}

stop_night_light() {
  # Kill gammastep and reset to normal temperature
  pkill gammastep
  gammastep -x

  echo "off" >"$STATE_FILE"
}

get_status() {
  if [ -f "$STATE_FILE" ]; then
    state=$(cat "$STATE_FILE")
  else
    state="off"
  fi

  # Check if gammastep is actually running
  if pgrep gammastep >/dev/null; then
    echo "{\"text\":\"$NIGHT_ON_ICON\", \"tooltip\":\"Night light: ON\", \"class\":\"night-on\"}"
  else
    echo "{\"text\":\"$NIGHT_OFF_ICON\", \"tooltip\":\"Night light: OFF\", \"class\":\"night-off\"}"
  fi
}

toggle_night_light() {
  if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "on" ]; then
    stop_night_light
  else
    start_night_light
  fi
  get_status
}

case "$1" in
  "toggle")
    toggle_night_light
    ;;
  "status")
    get_status
    ;;
  "on")
    start_night_light
    get_status
    ;;
  "off")
    stop_night_light
    get_status
    ;;
  *)
    echo "Usage: $0 {toggle|status|on|off}"
    echo "  toggle - Toggle night light on/off"
    echo "  status - Get current status (JSON for waybar)"
    echo "  on     - Turn on night light"
    echo "  off    - Turn off night light"
    exit 1
    ;;
esac
