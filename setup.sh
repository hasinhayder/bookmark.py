#!/bin/bash
# Setup script for Directory Bookmark Manager v2.0
# Author: Hasin Hayder
# Repository: https://github.com/hasinhayder/bookomark.py

VERSION="2.0"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_CONFIG=""

# Detect shell configuration file
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    echo "Unsupported shell. Please manually add the configuration."
    exit 1
fi

echo "Directory Bookmark Manager Setup v$VERSION"
echo "========================================="
echo "Author: Hasin Hayder"
echo "Repository: https://github.com/hasinhayder/bookomark.py"
echo ""
echo "This will add the bookmark commands to your shell configuration."
echo "Shell config file: $SHELL_CONFIG"
echo "Script directory: $SCRIPT_DIR"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

# Check if already installed
if grep -q "# Directory Bookmark Manager" "$SHELL_CONFIG" 2>/dev/null; then
    echo "Directory Bookmark Manager appears to already be installed in $SHELL_CONFIG"
    read -p "Do you want to reinstall/update? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo "Updating existing installation..."
fi

# Add aliases to shell config
echo "" >> "$SHELL_CONFIG"
echo "# Directory Bookmark Manager" >> "$SHELL_CONFIG"
echo "alias bookmark='python3 \"$SCRIPT_DIR/bookmark.py\"'" >> "$SHELL_CONFIG"
echo "source \"$SCRIPT_DIR/goto_function.sh\"" >> "$SHELL_CONFIG"

echo "Setup complete!"
echo ""
echo "To start using the commands, either:"
echo "1. Restart your terminal, or"
echo "2. Run: source $SHELL_CONFIG"
echo ""
echo "Usage:"
echo "  bookmark               - Add current directory as bookmark"
echo "  bookmark --remove      - Remove current directory bookmark"
echo "  bookmark --list        - List bookmarks and select one (outputs path)"
echo "  bookmark --open        - List bookmarks and open selected one in Finder"
echo "  bookmark --listall     - Display all bookmarks with their full paths"
echo "  bookmark --debug       - Open bookmarks file in VS Code for editing"
echo "  bookmark --flush       - Clear all bookmarks permanently"
echo "  bookmark --backup      - Create timestamped backup of bookmarks"
echo "  bookmark --restore     - Restore bookmarks from backup file"
echo "  goto                   - Navigate to a bookmarked directory (shell function)"
echo ""
echo "Additional Features:"
echo "  • Use --list to get directory paths for scripting"
echo "  • Use --open to quickly open directories in Finder (macOS)"
echo "  • Use --listall to see all bookmarks with their full paths"
echo "  • Use --debug to edit the bookmark file directly in VS Code"
echo "  • Use --flush to clear all bookmarks (use with caution!)"
echo "  • Use --backup to create timestamped backups of your bookmarks"
echo "  • Use --restore to restore bookmarks from backup files"
echo "  • The 'goto' command is a shell function that changes directory in your current session"
echo ""
echo "Bookmark file location: ~/.dir-bookmarks.txt"
