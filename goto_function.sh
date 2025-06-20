#!/bin/bash
# Function-based goto that works with current shell session

# Directory Bookmark Manager - Goto Function
# This script should be sourced, not executed directly

goto() {
    # Try to find goto.py in the same directory as this script
    # First, try to get the script directory from BASH_SOURCE
    local script_dir=""
    if [ -n "${BASH_SOURCE[0]}" ]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    fi
    
    # If that doesn't work or the file doesn't exist, use the hardcoded path
    if [ ! -f "$script_dir/goto.py" ]; then
        script_dir="/Users/hasinhayder/Projects/IC/laravel-b/class-oop-part-two/commandline"
    fi
    
    # Final fallback: try to find goto.py in PATH or common locations
    if [ ! -f "$script_dir/goto.py" ]; then
        # Try to find it via which command or in current directory
        if command -v goto.py >/dev/null 2>&1; then
            script_dir="$(dirname "$(which goto.py)")"
        elif [ -f "./goto.py" ]; then
            script_dir="."
        else
            echo "Error: goto.py not found. Please check your installation." >&2
            return 1
        fi
    fi
    
    # Run goto.py and capture only the stdout (the path)
    local selected_path=$(python3 "$script_dir/goto.py" 2>/dev/tty)
    
    # Check if a path was returned and it exists
    if [ -n "$selected_path" ] && [ -d "$selected_path" ]; then
        echo "Changing to: $selected_path" >&2
        cd "$selected_path"
        pwd  # Show current directory
    elif [ -n "$selected_path" ]; then
        echo "Directory not found: $selected_path" >&2
    fi
}
