#!/bin/bash
# Function-based goto that works with current shell session

# Directory Bookmark Manager - Goto Function
# This script should be sourced, not executed directly

goto() {
    # Try to find bookmark.py in the same directory as this script
    # First, try to get the script directory from BASH_SOURCE
    local script_dir=""
    if [ -n "${BASH_SOURCE[0]}" ]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    fi
    
    # If that doesn't work or the file doesn't exist, use the hardcoded path
    if [ ! -f "$script_dir/bookmark.py" ]; then
        script_dir="/Users/hasinhayder/Projects/IC/laravel-b/class-oop-part-two/commandline"
    fi
    
    # Final fallback: try to find bookmark.py in PATH or common locations
    if [ ! -f "$script_dir/bookmark.py" ]; then
        # Try to find it via which command or in current directory
        if command -v bookmark.py >/dev/null 2>&1; then
            script_dir="$(dirname "$(which bookmark.py)")"
        elif [ -f "./bookmark.py" ]; then
            script_dir="."
        else
            echo "Error: bookmark.py not found. Please check your installation." >&2
            return 1
        fi
    fi
    
    # Run bookmark --go and capture only the stdout (the path)
    local selected_path=$(python3 "$script_dir/bookmark.py" --go 2>/dev/tty)
    
    # Check if a path was returned and it exists
    if [ -n "$selected_path" ] && [ -d "$selected_path" ]; then
        echo "Changing to: $selected_path" >&2
        cd "$selected_path"
        pwd  # Show current directory
    elif [ -n "$selected_path" ]; then
        echo "Directory not found: $selected_path" >&2
    fi
}
