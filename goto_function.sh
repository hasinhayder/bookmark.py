#!/bin/bash
# Function-based goto that works with current shell session
# Directory Bookmark Manager - Goto Function
# Author: Hasin Hayder
# Repository: https://github.com/hasinhayder/bookomark.py
# This script should be sourced, not executed directly

# Locate bookmark.py using BOOKMARK_SCRIPT_DIR (set by setup.sh)
_get_bookmark_script() {
    if [[ -n "${BOOKMARK_SCRIPT_DIR:-}" ]] && [[ -f "${BOOKMARK_SCRIPT_DIR}/bookmark.py" ]]; then
        echo "${BOOKMARK_SCRIPT_DIR}/bookmark.py"
        return 0
    fi

    if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
        local this_script_dir
        this_script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
        if [[ -f "$this_script_dir/bookmark.py" ]]; then
            echo "$this_script_dir/bookmark.py"
            return 0
        fi
    fi

    if command -v bookmark >/dev/null 2>&1; then
        echo "bookmark"
        return 0
    fi

    echo "" >&2
    echo "Error: Could not locate bookmark.py. Set BOOKMARK_SCRIPT_DIR in your shell config." >&2
    return 1
}

_goto_resolve_cmd() {
    # Sets global _GOTO_CMD to either "bookmark" or "python3 /path/bookmark.py"
    _GOTO_CMD=""
    local script_dir=""

    if [[ -n "${BOOKMARK_SCRIPT_DIR:-}" ]] && [[ -f "${BOOKMARK_SCRIPT_DIR}/bookmark.py" ]]; then
        script_dir="$BOOKMARK_SCRIPT_DIR"
    elif [[ -n "${BASH_SOURCE[0]:-}" ]]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        if [[ ! -f "$script_dir/bookmark.py" ]]; then
            script_dir=""
        fi
    fi

    if [[ -z "$script_dir" ]]; then
        if command -v bookmark >/dev/null 2>&1; then
            _GOTO_CMD="bookmark"
            return 0
        elif [[ -f ./bookmark.py ]]; then
            script_dir="."
        else
            echo "Error: bookmark.py not found. Please set BOOKMARK_SCRIPT_DIR or run setup." >&2
            return 1
        fi
    fi

    _GOTO_CMD="python3 \"$script_dir/bookmark.py\""
    return 0
}

# Navigate to a bookmarked directory
# Usage:
#   goto              Interactive menu (↑/↓, type-to-filter, Enter)
#   goto <name>       Jump directly (exact or unique partial name)
#   goto -h|--help    Show help
goto() {
    local selected_path arg

    if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
        goto_help
        return 0
    fi

    _goto_resolve_cmd || return 1

    if [[ -n "${1:-}" ]]; then
        # Direct jump by name (pass remaining args as the name)
        arg="$1"
        selected_path=$(eval $_GOTO_CMD --go "$arg" < /dev/tty 2>/dev/tty)
    else
        # Interactive selection
        selected_path=$(eval $_GOTO_CMD --go < /dev/tty 2>/dev/tty)
    fi

    if [[ -z "$selected_path" ]]; then
        return 1
    fi

    if [[ ! -d "$selected_path" ]]; then
        echo "Error: Directory not found: $selected_path" >&2
        return 1
    fi

    echo "→ $selected_path" >&2
    cd "$selected_path" || {
        echo "Error: Failed to change to directory: $selected_path" >&2
        return 1
    }
}

# Bash tab completion for bookmark names
if [[ -n "${BASH_VERSION:-}" ]] && [[ $- == *i* ]] && type complete >/dev/null 2>&1; then
    _goto_completion() {
        local cur names bookmarks_file
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        bookmarks_file="${HOME}/.dir-bookmarks.txt"
        if [[ -f "$bookmarks_file" ]]; then
            names=$(grep -v "^#" "$bookmarks_file" | grep "|" | cut -d"|" -f1 | sort -u)
            COMPREPLY=($(compgen -W "$names" -- "$cur"))
        fi
    }
    complete -F _goto_completion goto
fi

# Zsh tab completion for bookmark names
if [[ -n "${ZSH_VERSION:-}" ]] && [[ -o interactive ]]; then
    _goto_zsh_completion() {
        local bookmarks_file names
        bookmarks_file="${HOME}/.dir-bookmarks.txt"
        if [[ -f "$bookmarks_file" ]]; then
            names=(${(f)"$(grep -v "^#" "$bookmarks_file" | grep "|" | cut -d"|" -f1 | sort -u)"})
            compadd -a names
        fi
    }
    # Only register if compdef is available (compinit loaded)
    if typeset -f compdef >/dev/null 2>&1; then
        compdef _goto_zsh_completion goto
    fi
fi

goto_help() {
    cat << 'EOF'
goto - Navigate to bookmarked directories

Usage:
    goto                    Interactive menu
    goto <name>             Jump by exact or unique partial name
    goto -h, --help         Show this help

Interactive keys:
    ↑ / ↓                   Move selection
    type                    Filter by name/path
    Backspace / Ctrl-U      Edit / clear filter
    1-9…                    Jump by number (multi-digit, e.g. 12)
    PgUp / PgDn             Page up/down
    Home / End              First / last item
    Enter                   Select
    Esc                     Clear filter, or quit if empty
    q                       Quit (when filter empty)

Examples:
    goto                    # open interactive menu
    goto tyro               # unique partial match
    goto "tyro dashboard"   # exact name with spaces

Notes:
    - Bookmarks: bookmark / bookmark --listall / bookmark --help
    - Storage: ~/.dir-bookmarks.txt
EOF
}

if [[ -n "${BASH_VERSION:-}" ]]; then
    export -f goto
fi

if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]]; then
    echo "Warning: This script should be sourced, not executed directly." >&2
    echo "Please run: source $0" >&2
fi
