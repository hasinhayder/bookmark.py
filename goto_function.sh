#!/bin/bash
# Function-based goto that works with current shell session
# Directory Bookmark Manager - Goto Function
# Author: Hasin Hayder
# Repository: https://github.com/hasinhayder/bookomark.py
# This script should be sourced, not executed directly

# Find bookmark.py script with multiple fallback strategies
_find_bookmark_script() {
    local script_name="bookmark.py"
    local script_path=""
    
    # Strategy 1: Try to get script directory from BASH_SOURCE
    if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
        local this_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        script_path="$this_script_dir/$script_name"
        if [[ -f "$script_path" ]]; then
            echo "$script_path"
            return 0
        fi
    fi
    
    # Strategy 2: Try to get script directory from sourced file
    if [[ -n "${BASH_SOURCE[1]:-}" ]]; then
        local parent_script_dir="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
        script_path="$parent_script_dir/$script_name"
        if [[ -f "$script_path" ]]; then
            echo "$script_path"
            return 0
        fi
    fi
    
    # Strategy 3: Check common installation directories
    local common_dirs=(
        "$HOME/.local/share/bookmark-manager"
        "$HOME/bin"
        "/usr/local/bin"
        "/opt/bookmark-manager"
    )
    
    for dir in "${common_dirs[@]}"; do
        script_path="$dir/$script_name"
        if [[ -f "$script_path" ]]; then
            echo "$script_path"
            return 0
        fi
    done
    
    # Strategy 4: Check if bookmark command exists in PATH
    if command -v bookmark &> /dev/null; then
        # Try to find where bookmark points to
        local bookmark_cmd=$(command -v bookmark 2>/dev/null || which bookmark 2>/dev/null || true)
        if [[ -n "$bookmark_cmd" ]]; then
            # Extract the path from the alias/function
            if [[ "$bookmark_cmd" == *"python3"* ]]; then
                script_path=$(echo "$bookmark_cmd" | sed 's/.*python3 \(.*\)".*/\1/')
                if [[ -f "$script_path" ]]; then
                    echo "$script_path"
                    return 0
                fi
            fi
        fi
    fi
    
    # Strategy 5: Check current directory
    if [[ -f "./$script_name" ]]; then
        script_path="./$script_name"
        echo "$script_path"
        return 0
    fi
    
    # Strategy 6: Try to find via bookmark command output
    if command -v bookmark &> /dev/null; then
        # Try running bookmark --help to see if it works
        if bookmark --help &> /dev/null; then
            # If it works, assume the installation is correct
            # and try to find the script via the alias/function definition
            local alias_def=$(alias bookmark 2>/dev/null || true)
            if [[ -n "$alias_def" ]]; then
                script_path=$(echo "$alias_def" | sed 's/.*"\(.*\)".*/\1/')
                if [[ -f "$script_path" ]]; then
                    echo "$script_path"
                    return 0
                fi
            fi
        fi
    fi
    
    # If all strategies fail
    echo "" >&2
    echo "Error: Could not locate bookmark.py script." >&2
    echo "Please ensure bookmark.py is in the same directory as this script," >&2
    echo "or that the bookmark command is properly configured." >&2
    echo "You can run the setup script again: ./setup.sh" >&2
    return 1
}

# Enhanced goto function with better error handling
goto() {
    # Find the bookmark script
    local bookmark_script
    bookmark_script=$(_find_bookmark_script)
    
    if [[ -z "$bookmark_script" ]]; then
        return 1
    fi
    
    # Check if Python 3 is available
    if ! command -v python3 &> /dev/null; then
        echo "Error: Python 3 is required but not found in PATH." >&2
        return 1
    fi
    
    # Run bookmark --go and capture the output
    # Use a timeout to prevent hanging
    local selected_path
    if command -v timeout &> /dev/null; then
        # Use timeout if available (Linux)
        selected_path=$(timeout 30 python3 "$bookmark_script" --go 2>/dev/null)
    elif command -v gtimeout &> /dev/null; then
        # Use gtimeout on macOS (from coreutils)
        selected_path=$(gtimeout 30 python3 "$bookmark_script" --go 2>/dev/null)
    else
        # No timeout available, run without it
        selected_path=$(python3 "$bookmark_script" --go 2>/dev/null)
    fi
    
    local exit_code=$?
    
    # Check if the command was successful
    if [[ $exit_code -ne 0 ]]; then
        echo "Error: Failed to run bookmark manager." >&2
        echo "Please check that bookmark.py is working correctly." >&2
        return 1
    fi
    
    # Check if a path was returned
    if [[ -z "$selected_path" ]]; then
        echo "No directory selected." >&2
        return 1
    fi
    
    # Check if the selected path exists and is a directory
    if [[ ! -d "$selected_path" ]]; then
        echo "Error: Directory not found: $selected_path" >&2
        return 1
    fi
    
    # Check if we have permission to access the directory
    if [[ ! -r "$selected_path" ]]; then
        echo "Error: Permission denied accessing: $selected_path" >&2
        return 1
    fi
    
    # Change to the directory
    echo "Changing to: $selected_path" >&2
    cd "$selected_path" || {
        echo "Error: Failed to change to directory: $selected_path" >&2
        return 1
    }
    
    # Show the current directory
    pwd >&2
    
    # Optional: Show directory contents (commented out by default)
    # ls -la >&2
}

# Optional: Add tab completion for goto function
if [[ -n "${BASH_VERSION:-}" ]]; then
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

# Export the function so it's available in the current shell
export -f goto

# Show a welcome message if this is an interactive shell
if [[ "${PS1:-}" != "" ]] && [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Warning: This script should be sourced, not executed directly." >&2
    echo "Please run: source $0" >&2
    echo "Or add it to your shell configuration file." >&2
fi
