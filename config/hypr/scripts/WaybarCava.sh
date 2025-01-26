#!/bin/bash

# Optimized bars animation without much CPU usage increase
bar="▁▂▃▄▅▆▇█"
dict="s/;//g"

# Calculate the length of the bar outside the loop
bar_length=${#bar}

# Create dictionary to replace char with bar
for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

# Create cava config
config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
bars = 10

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Function to get the number of monitors
get_monitor_count() {
    local monitors
    if ! monitors=$(hyprctl monitors -j | jq '. | length'); then
        printf "Error: Failed to retrieve monitor count\n" >&2
        return 1
    fi
    printf "%d" "$monitors"
}

# Function to manage cava sessions
start_cava_sessions() {
    local monitor_count existing_sessions session_diff

    # Get monitor count
    monitor_count=$(get_monitor_count) || return 1

    # Get existing cava sessions
    existing_sessions=$(pgrep -cf "cava -p $config_file")

    # Calculate session difference
    session_diff=$((monitor_count - existing_sessions))

    # Stop extra cava sessions if any
    if ((session_diff < 0)); then
        pkill -f "cava -p $config_file"
        existing_sessions=0
        session_diff=$monitor_count
    fi

    # Start new cava sessions if needed
    if ((session_diff > 0)); then
        for ((i = 0; i < session_diff; i++)); do
            cava -p "$config_file" | sed -u "$dict" &
        done
    fi

    # printf "Monitor count: %d, Running cava sessions: %d\n" "$monitor_count" "$(pgrep -cf "cava -p $config_file")"
}

# Main function
main() {
    if ! command -v hyprctl &>/dev/null || ! command -v jq &>/dev/null; then
        printf "Error: Required commands 'hyprctl' and 'jq' are not installed\n" >&2
        return 1
    fi

    # Start or adjust cava sessions based on monitor count
    start_cava_sessions || return 1
}

main
