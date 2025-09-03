#!/usr/bin/env bash

# Screen recording script for Niri
# Usage: screencast.sh [start|stop|area|window]

RECORDING_DIR="$HOME/Videos/Recordings"
PIDFILE="/tmp/wf-recorder.pid"
mkdir -p "$RECORDING_DIR"

case "${1:-start}" in
    "start")
        if [ -f "$PIDFILE" ]; then
            notify-send "Screen Recording" "Recording already in progress"
            exit 1
        fi
        
        # Full screen recording
        wf-recorder -f "$RECORDING_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4" &
        echo $! > "$PIDFILE"
        notify-send "Screen Recording" "Started full screen recording"
        ;;
    "area")
        if [ -f "$PIDFILE" ]; then
            notify-send "Screen Recording" "Recording already in progress"
            exit 1
        fi
        
        # Area recording
        wf-recorder -g "$(slurp)" -f "$RECORDING_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4" &
        echo $! > "$PIDFILE"
        notify-send "Screen Recording" "Started area recording"
        ;;
    "window")
        if [ -f "$PIDFILE" ]; then
            notify-send "Screen Recording" "Recording already in progress"
            exit 1
        fi
        
        # Window recording
        GEOMETRY=$(niri msg focused-window | jq -r '.geometry | "\(.x),\(.y) \(.width)x\(.height)"')
        wf-recorder -g "$GEOMETRY" -f "$RECORDING_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4" &
        echo $! > "$PIDFILE"
        notify-send "Screen Recording" "Started window recording"
        ;;
    "stop")
        if [ -f "$PIDFILE" ]; then
            kill "$(cat "$PIDFILE")"
            rm "$PIDFILE"
            notify-send "Screen Recording" "Recording stopped and saved"
        else
            notify-send "Screen Recording" "No recording in progress"
        fi
        ;;
    *)
        echo "Usage: $0 [start|stop|area|window]"
        exit 1
        ;;
esac
