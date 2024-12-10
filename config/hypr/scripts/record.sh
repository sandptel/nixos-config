#!/bin/bash

# Temporary file to track recording state
RECORDING_STATE_FILE="/tmp/wf-recording.state"

# Output file for the recording
OUTPUT_DIR="$HOME/Videos"
OUTPUT_FILE="$OUTPUT_DIR/recording_$(date '+%Y-%m-%d_%H-%M-%S').mp4"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Function to run wf-recorder in nix-shell
run_wf_recorder() {
    nix-shell -p wf-recorder slurp --run "wf-recorder -g '$1' -f '$2'"
}

if [ -f "$RECORDING_STATE_FILE" ]; then
    # Stop the recording
    WF_PID=$(cat "$RECORDING_STATE_FILE")
    kill "$WF_PID" 2>/dev/null
    rm -f "$RECORDING_STATE_FILE"
    killall wf-recorder
    # Wait for the process to terminate completely
    wait "$WF_PID" 2>/dev/null

    # Add a delay to avoid capturing the notification
    sleep 2

    # Notify the user
    notify-send "Screen Recording" "Recording stopped. Saved to $OUTPUT_FILE"
else
    # Start the recording
    GEOMETRY=$(nix-shell -p slurp --run "slurp")
    if [ -z "$GEOMETRY" ]; then
        notify-send "Screen Recording" "No area selected for recording."
        exit 1
    fi

    run_wf_recorder "$GEOMETRY" "$OUTPUT_FILE" &
    echo $! > "$RECORDING_STATE_FILE"
fi

