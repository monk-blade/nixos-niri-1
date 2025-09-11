#!/usr/bin/env bash

# Screen recording script for Niri with Audio Support and Recording Indicators (Omarchy-inspired)
# Usage: screencast.sh [region|screen|region-audio|screen-audio|stop]

RECORDING_DIR="$HOME/Videos/Recordings"
PIDFILE="/tmp/wf-recorder.pid"
INDICATOR_FILE="/tmp/recording_indicator"
mkdir -p "$RECORDING_DIR"

# Function to show recording indicator
show_recording_indicator() {
    local mode="$1"
    echo "$mode" >"$INDICATOR_FILE"
    # Send signal to waybar to update recording indicator
    pkill -RTMIN+8 waybar 2>/dev/null || true
    notify-send "󰑋 Recording" "Recording started ($mode)" -t 3000 -u normal
}

# Function to hide recording indicator
hide_recording_indicator() {
    rm -f "$INDICATOR_FILE"
    # Send signal to waybar to update recording indicator
    pkill -RTMIN+8 waybar 2>/dev/null || true
    notify-send "󰑊 Recording" "Recording stopped and saved to ~/Videos/Recordings" -t 3000 -u normal
}

case "${1:-region}" in
    "region")
        if [ -f "$PIDFILE" ]; then
            notify-send "Screen Recording" "Recording already in progress"
            exit 1
        fi

        # Area recording without audio
        GEOMETRY=$(slurp 2>/dev/null)
        if [ -n "$GEOMETRY" ]; then
            wf-recorder -g "$GEOMETRY" -f "$RECORDING_DIR/screencast-$(date +%Y%m%d-%H%M%S).mp4" &
            echo $! >"$PIDFILE"
            show_recording_indicator "Region (No Audio)"
        else
            notify-send "Screen Recording" "Region selection cancelled"
        fi
        ;;
    "screen")
        if [ -f "$PIDFILE" ]; then
            notify-send "Screen Recording" "Recording already in progress"
            exit 1
        fi

        # Full screen recording without audio
        wf-recorder -f "$RECORDING_DIR/screencast-$(date +%Y%m%d-%H%M%S).mp4" &
        echo $! >"$PIDFILE"
        show_recording_indicator "Full Screen (No Audio)"
        ;;
    "region-audio")
        if [ -f "$PIDFILE" ]; then
            notify-send "Screen Recording" "Recording already in progress"
            exit 1
        fi

        # Area recording with audio
        GEOMETRY=$(slurp 2>/dev/null)
        if [ -n "$GEOMETRY" ]; then
            wf-recorder -g "$GEOMETRY" --audio -f "$RECORDING_DIR/screencast-$(date +%Y%m%d-%H%M%S).mp4" &
            echo $! >"$PIDFILE"
            show_recording_indicator "Region + Audio"
        else
            notify-send "Screen Recording" "Region selection cancelled"
        fi
        ;;
    "screen-audio")
        if [ -f "$PIDFILE" ]; then
            notify-send "Screen Recording" "Recording already in progress"
            exit 1
        fi

        # Full screen recording with audio
        wf-recorder --audio -f "$RECORDING_DIR/screencast-$(date +%Y%m%d-%H%M%S).mp4" &
        echo $! >"$PIDFILE"
        show_recording_indicator "Full Screen + Audio"
        ;;
    "stop")
        if [ -f "$PIDFILE" ]; then
            kill "$(cat "$PIDFILE")" 2>/dev/null
            rm -f "$PIDFILE"
            hide_recording_indicator
        else
            notify-send "Screen Recording" "No recording in progress"
        fi
        ;;
    *)
        echo "Usage: $0 [region|screen|region-audio|screen-audio|stop]"
        exit 1
        ;;
esac
