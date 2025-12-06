#!/bin/bash
# Function-based goto that works with current shell session
# Directory Bookmark Manager - Goto Function
# Author: Hasin Hayder
# Repository: https://github.com/hasinhayder/bookomark.py
# This script should be sourced, not executed directly

# Locate bookmark.py using BOOKMARK_SCRIPT_DIR (set by setup.sh)
_get_bookmark_script() {
    # Use configured directory if present
    if [[ -n "${BOOKMARK_SCRIPT_DIR:-}" ]] && [[ -f "${BOOKMARK_SCRIPT_DIR}/bookmark.py" ]]; then
        echo "${BOOKMARK_SCRIPT_DIR}/bookmark.py"
        return 0
    fi

    # Fallback: check the same directory as this file
    if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
        local this_script_dir
        this_script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
        if [[ -f "$this_script_dir/bookmark.py" ]]; then
            echo "$this_script_dir/bookmark.py"
            return 0
        fi
    fi

    # Fallback: if a 'bookmark' command exists in PATH, use it
    if command -v bookmark >/dev/null 2>&1; then
        echo "bookmark"
        return 0
    fi

    # Nothing found
    echo "" >&2
    echo "Error: Could not locate bookmark.py. Set BOOKMARK_SCRIPT_DIR in your shell config." >&2
    return 1
}

# Enhanced goto function with better error handling
goto() {
    # Determine script directory (prefer explicit export)
    local script_dir selected_path cmd

    if [[ -n "${BOOKMARK_SCRIPT_DIR:-}" ]] && [[ -f "${BOOKMARK_SCRIPT_DIR}/bookmark.py" ]]; then
        script_dir="$BOOKMARK_SCRIPT_DIR"
    elif [[ -n "${BASH_SOURCE[0]:-}" ]]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        if [[ ! -f "$script_dir/bookmark.py" ]]; then
            script_dir=""
        fi
    fi

    # If no script_dir yet, try PATH or current dir
    if [[ -z "$script_dir" ]]; then
        if command -v bookmark >/dev/null 2>&1; then
            cmd="bookmark"
        elif [[ -f ./bookmark.py ]]; then
            script_dir="."
        else
            echo "Error: bookmark.py not found. Please set BOOKMARK_SCRIPT_DIR or run setup." >&2
            return 1
        fi
    fi

    # If cmd not set, use python3 on the script
    if [[ -z "${cmd:-}" ]]; then
        cmd="python3 \"$script_dir/bookmark.py\""
    fi

    # Run interactive selection with stdin/stdout attached to the terminal
    # Capture only the stdout (the final path)
    selected_path=$(eval $cmd --go < /dev/tty 2>/dev/tty)

    if [[ -z "$selected_path" ]]; then
        echo "No directory selected." >&2
        return 1
    fi

    if [[ ! -d "$selected_path" ]]; then
        echo "Error: Directory not found: $selected_path" >&2
        return 1
    fi

    echo "Changing to: $selected_path" >&2
    cd "$selected_path" || { echo "Error: Failed to change to directory: $selected_path" >&2; return 1; }
    pwd >&2
}

# Optional: Add tab completion for goto function
if [[ -n "${BASH_VERSION:-}" ]] && [[ $- == *i* ]] && type complete >/dev/null 2>&1; then
    _goto_completion() {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        
        # Get list of bookmark names for completion
        if command -v bookmark &> /dev/null; then
            # Try to extract bookmark names from the bookmarks file
            local bookmarks_file="$HOME/.dir-bookmarks.txt"
            if [[ -f "$bookmarks_file" ]]; then
                local names
                names=$(grep -v "^#" "$bookmarks_file" | grep "|" | cut -d"|" -f1 | sort)
                COMPREPLY=($(compgen -W "$names" -- "$cur"))
            fi
        fi
    }
    
    complete -F _goto_completion goto
fi

# Optional: Add help function
goto_help() {
    cat << 'EOF'
goto - Navigate to bookmarked directories

Usage:
    goto                    # Interactive directory selection
    goto [bookmark_name]    # Navigate directly to named bookmark (if supported)

Description:
    The goto function allows you to quickly navigate to bookmarked directories.
    When called without arguments, it displays an interactive menu of all
    bookmarked directories and allows you to select one by number.

    The function changes the current directory in your shell session.

Examples:
    goto                    # Show interactive menu
    goto                    # Same as above

Notes:
    - Bookmarks are managed by the bookmark command
    - Use 'bookmark --listall' to see all available bookmarks
    - Use 'bookmark' to add new bookmarks
    - Use 'bookmark --help' for more information

Troubleshooting:
    If goto doesn't work:
    1. Ensure setup.sh was run successfully
    2. Run 'source ~/.zshrc' or 'source ~/.bashrc'
    3. Check that bookmark.py exists and is executable
    4. Run 'bookmark --help' to verify the bookmark command works

EOF
}

# Export the function so it's available in the current shell (only in bash)
if [[ -n "${BASH_VERSION:-}" ]]; then
    export -f goto
fi

# Show a welcome message if this is an interactive shell
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Warning: This script should be sourced, not executed directly." >&2
    echo "Please run: source $0" >&2
    echo "Or add it to your shell configuration file." >&2
fi