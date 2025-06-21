#!/bin/bash
# /* ---- 👒 https://github.com/sandptel/nixos-config ---- */  ##
# Scripts for refreshing ags waybar, rofi, swaync, wallust

set -e  # Exit on any error

SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

# Define file_exists function
file_exists() {
    if [ -e "$1" ]; then
        return 0 # File exists
    else
        return 1 # File does not exist
    fi
}

# Kill processes function
kill_processes() {
    local processes=(waybar rofi swaync ags)
    
    echo "Stopping running processes..."
    for process in "${processes[@]}"; do
        if pidof "${process}" >/dev/null; then
            echo "Killing ${process}..."
            pkill "${process}"
        fi
    done
    
    # Additional cleanup
    ags -q 2>/dev/null || true
    killall .waybar-wrapped 2>/dev/null || true
    
    # Wait a moment for processes to fully terminate
    sleep 1
}

# Start services function
start_services() {
    echo "Starting services..."
    
    # Start waybar
    waybar &
    disown
    
    # Start swaync
    swaync >/dev/null 2>&1 &
    
    # Start ags
    ags &
    
    echo "All services started successfully!"
}

# Main execution
echo "Starting refresh process..."

# Initialize lights
"${UserScripts}/Lights.sh"

# Kill existing processes
kill_processes

# Run wallust and wait for it to complete
echo "Running wallpaper and color scheme updates..."
"${SCRIPTSDIR}/WallustSwww.sh"

# Update pywalfox after wallust completes
echo "Updating pywalfox..."
pywalfox update

# Run Obsidian script
echo "Running Obsidian configuration..."
"${UserScripts}/Obsidian.sh"

# Start all services
start_services

echo "Refresh process completed successfully!"
exit 0
