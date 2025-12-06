# Directory Bookmark Manager

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/python-3.6%2B-brightgreen.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)
![Version](https://img.shields.io/badge/version-3.0-blue.svg)
![Status](https://img.shields.io/badge/status-stable-green.svg)

A powerful command-line tool to bookmark directories and quickly navigate between them across multiple platforms.

**Author:** Hasin Hayder  
**Repository:** https://github.com/hasinhayder/bookomark.py  
**Version:** 3.0  
**License:** MIT

## Quick Start

1. Clone or download this repository
2. Run the setup script: `./setup.sh`
3. Restart your terminal or run `source ~/.zshrc` (or `source ~/.bashrc` for bash)
4. Start bookmarking: `bookmark` and navigating: `goto`

## Features

### Core Features
- Save current directory with a friendly name
- Remove bookmarks for current directory
- List all bookmarks in alphabetical order
- Navigate to bookmarked directories using `goto` function
- Cross-platform file manager integration (Finder, xdg-open, Explorer)
- Debug bookmarks file in text editor (tries VS Code, Vim, Nano, Cat)
- Bulk operations (list all, flush all)

### Advanced Features
- **Backup and restore bookmarks** - Create timestamped backups and restore from them
- Duplicate prevention for both paths and names
- Automatic setup script with validation
- Enhanced error handling and user feedback
- Interactive directory selection with numbered menus
- Cross-platform compatibility (macOS, Linux, Windows)

### What's New in v3.0
- ✨ **Cross-platform support** - Works on macOS, Linux, and Windows
- ✨ **Enhanced error handling** - Better validation and user feedback
- ✨ **Improved setup script** - Automatic validation, backup creation, and shell detection
- ✨ **Better goto function** - More reliable script location detection and error handling
- ✨ **Type hints** - Full type annotations for better code quality
- ✨ **Platform-aware file manager** - Opens directories in the native file manager
- ✨ **Editor fallback** - Tries multiple editors for debugging
- ✨ **Enhanced backup system** - Better backup file management and validation

## Installation

**Easy Setup (Recommended):**

Run the setup script to automatically configure everything:

```bash
./setup.sh
```

This will:

- ✅ Check prerequisites (Python 3.6+, required files)
- ✅ Detect your shell configuration file (.zshrc, .bashrc, .bash_profile)
- ✅ Create a backup of your existing shell configuration
- ✅ Add the `bookmark` alias to your shell configuration
- ✅ Source the `goto_function.sh` to enable the `goto` command
- ✅ Test the installation to ensure everything works
- ✅ Display helpful usage information

After setup, either restart your terminal or run:

```bash
source ~/.zshrc  # or ~/.bashrc for bash users
```

**Setup Script Options:**

```bash
./setup.sh --help     # Show help information
./setup.sh --version  # Show version information
```

**Manual Setup (Advanced):**

If you prefer manual installation, add these lines to your `~/.zshrc` (or `~/.bashrc` for bash):

```bash
# Directory Bookmark Manager v3.0
# https://github.com/hasinhayder/bookomark.py
alias bookmark='python3 /path/to/bookmark.py'
source /path/to/goto_function.sh
# End Directory Bookmark Manager
```

**Prerequisites:**

- Python 3.6 or higher
- Bash or Zsh shell
- Terminal with interactive capabilities

**Supported Shells:**
- ✅ Zsh (recommended)
- ✅ Bash (.bashrc or .bash_profile)
- ⚠️  Fish (manual configuration required)
- ❌ Other shells (manual configuration required)

## Usage

After running `./setup.sh`, you can use these commands from anywhere:

### Bookmarking Directories

**Add a bookmark for current directory:**

```bash
bookmark
```

You'll be prompted to enter a friendly name for the current directory.

**Remove bookmark for current directory:**

```bash
bookmark --remove
```

### Navigating to Bookmarks

**Navigate to bookmarks using the goto function:**

```bash
goto
```

This will:

1. Show all bookmarked directories with numbers
2. Prompt you to select a number
3. Change to the selected directory in your current shell session

### Additional Commands

**List bookmarks and select one (for scripting):**

```bash
bookmark --list
```

**Get directory path for shell navigation:**

```bash
goto
```

**Open bookmark in Finder (macOS):**

```bash
bookmark --open
```

### Debugging and Maintenance

**Debug bookmarks file:**

```bash
bookmark --debug
```

This opens the `~/.dir-bookmarks.txt` file in VS Code for manual editing or debugging.

**Clear all bookmarks:**

```bash
bookmark --flush
```

This permanently deletes all bookmarks from the file.

**List all bookmarks with paths:**

```bash
bookmark --listall
```

This displays all bookmarks with their full directory paths and a total count.

### Backup and Restore

**Create a backup of your bookmarks:**

```bash
bookmark --backup
```

This creates a timestamped backup file: `~/.dir-bookmarks-backup-YYYYMMDD_HHMMSS.txt`

**Restore bookmarks from a backup:**

```bash
bookmark --restore
```

This will:

1. Show available backup files with timestamps and bookmark counts
2. Prompt you to select which backup to restore
3. Create a backup of your current bookmarks before restore
4. Restore the selected backup file

### Example Usage for --open Feature (Cross-Platform)

```bash
# Open a bookmark in your platform's file manager
bookmark --open
# Shows:
# 1. docs
# 2. myapp
# Select: 1
# Outputs: /Users/username/Documents/Important
# Opens the directory in:
#   - macOS: Finder
#   - Linux: Default file manager (xdg-open)
#   - Windows: File Explorer

# Works across all supported platforms!
```

### Example Usage for --debug, --flush, --backup, --restore, and --listall Features

```bash
# Debug bookmarks file (tries multiple editors)
bookmark --debug
# Tries: VS Code → Vim → Nano → Cat (read-only)
# Opens ~/.dir-bookmarks.txt in the first available editor

# Create backup of bookmarks
bookmark --backup
# Creates ~/.dir-bookmarks-backup-20250620_143025.txt
# Shows: Bookmarks backed up to: ~/.dir-bookmarks-backup-20250620_143025.txt
#        Backed up 5 bookmark(s)

# Restore from backup
bookmark --restore
# Shows available backups with timestamps and counts:
# Available backup files:
# 1. 2025-06-20 14:30:25 (5 bookmarks)
# 2. 2025-06-19 10:15:30 (3 bookmarks)
# Select backup to restore (number): 1
# Creates backup of current bookmarks before restore
# Successfully restored 5 bookmark(s) from backup

# Clear all bookmarks (with safety backup)
bookmark --flush
# Current bookmarks: 3
# Are you sure you want to delete all 3 bookmarks? (type 'yes' to confirm): yes
# Backup created: /Users/username/.dir-bookmarks-before-flush-20250620_143025.txt
# All bookmarks have been cleared

# List all bookmarks with paths
bookmark --listall
# Shows:
# All bookmarked directories:
# 1. docs -> /Users/username/Documents/Important
# 2. myapp -> /Users/username/Projects/MyApp
# Total: 2 bookmark(s)
```

## Available Commands

### Bookmark Management
- `bookmark` - Add current directory as bookmark
- `bookmark --remove` - Remove current directory's bookmark
- `bookmark --list` - List bookmarks and select one (outputs path for scripting)
- `bookmark --listall` - Display all bookmarks with their full paths and counts

### Navigation
- `goto` - Navigate to bookmarked directory (shell function that changes current directory)
- `bookmark --go` - Same as goto, outputs selected directory path

### File Manager Integration
- `bookmark --open` - List bookmarks and open selected one in platform file manager
  - macOS: Opens in Finder
  - Linux: Opens with xdg-open
  - Windows: Opens in File Explorer

### Maintenance & Debugging
- `bookmark --debug` - Open bookmarks file in text editor (tries VS Code, Vim, Nano, Cat)
- `bookmark --flush` - Clear all bookmarks permanently (creates safety backup)
- `bookmark --backup` - Create timestamped backup of bookmarks
- `bookmark --restore` - Restore bookmarks from backup file (with safety backup)

### Information
- `bookmark --help` - Show comprehensive help information
- `bookmark --version` or `bookmark --info` - Show version and platform information

### Shell Function Help
- `goto_help` - Show detailed help for the goto function

## File Structure

### Core Files
- `bookmark.py` - Main Python script with all bookmark management and navigation features
- `goto_function.sh` - Enhanced shell function for directory navigation (uses bookmark --go internally)
- `setup.sh` - Automated setup script with validation, backup, and cross-platform support
- `test.sh` - Test script to verify all functionality works
- `LICENSE` - MIT License file
- `README.md` - This documentation file

### Generated Files
- `~/.dir-bookmarks.txt` - Storage file for bookmarks (auto-created)
- `~/.dir-bookmarks-backup-YYYYMMDD_HHMMSS.txt` - Timestamped backup files
- `~/.dir-bookmarks-before-flush-YYYYMMDD_HHMMSS.txt` - Safety backups before flush operations
- `~/.dir-bookmarks-before-restore-YYYYMMDD_HHMMSS.txt` - Safety backups before restore operations

### Storage Format

Bookmarks are stored in `~/.dir-bookmarks.txt` in the format:

```
# Directory Bookmarks - Format: name|path
# Generated by Bookmark Manager v3.0 on hostname

friendly_name|/full/path/to/directory
another_name|/another/full/path/to/directory
```

The file includes:
- Header comments with format information
- Generated timestamp and hostname
- Empty line for readability
- Sorted bookmark entries (by name, case-insensitive)
- Each line: `name|path` format

## Storage Format

Bookmarks are stored in `~/.dir-bookmarks.txt` in the format:

```
friendly_name|/full/path/to/directory
```

## Examples

```bash
# Navigate to your projects directory
cd ~/Projects/MyApp
bookmark
# Enter: "myapp"

# Navigate to another directory
cd ~/Documents/Important
bookmark
# Enter: "docs"

# Navigate using goto function
goto
# Shows:
# 1. docs
# 2. myapp
# Select: 2
# Changes to ~/Projects/MyApp

# Remove a bookmark
cd ~/Projects/MyApp
bookmark --remove
# Removes the "myapp" bookmark

# Get directory path for scripting
goto
# Shows:
# 1. docs
# Select: 1
# Outputs: /Users/username/Documents/Important

# List all bookmarks and get a path
bookmark --list
# Shows:
# 1. docs
# Select: 1
# Outputs: /Users/username/Documents/Important

# Open a bookmark in Finder
bookmark --open
# Shows:
# 1. docs
# Select: 1
# Outputs: /Users/username/Documents/Important
# Opens the directory in Finder

# Create backup before making changes
bookmark --backup
# Creates timestamped backup

# Restore from backup if needed
bookmark --restore
# Lists available backups and restores selected one
```

## Error Handling & Validation

### Robust Error Handling
- ✅ Prevents duplicate directory bookmarks
- ✅ Warns about duplicate friendly names with option to overwrite
- ✅ Validates directory existence when navigating
- ✅ Handles file I/O errors gracefully (permissions, encoding, etc.)
- ✅ Input validation for user selections
- ✅ Cross-platform compatibility checks
- ✅ Python version validation (requires 3.6+)
- ✅ Shell configuration validation

### Safety Features
- ✅ Automatic backup creation before destructive operations
- ✅ Confirmation prompts for dangerous operations (flush, restore)
- ✅ Shell configuration backup before modifications
- ✅ Permission checks before file operations
- ✅ Graceful fallbacks when tools are unavailable

### User Experience
- ✅ Clear, informative error messages
- ✅ Progress indicators for operations
- ✅ Success confirmation messages
- ✅ Helpful troubleshooting information
- ✅ Interactive prompts with clear instructions

## Author & Repository

**Author:** Hasin Hayder  
**GitHub:** https://github.com/hasinhayder/bookomark.py  
**Issues:** https://github.com/hasinhayder/bookomark.py/issues  
**Releases:** https://github.com/hasinhayder/bookomark.py/releases

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/bookomark.py.git`
3. Run setup: `./setup.sh`
4. Make your changes
5. Test with: `./test.sh`
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### MIT License Summary

- ✅ **Commercial use** - Use in commercial projects
- ✅ **Modification** - Modify the source code
- ✅ **Distribution** - Distribute copies
- ✅ **Private use** - Use privately
- ✅ **Patent use** - Grant of patent rights from contributors

**Copyright (c) 2025 Hasin Hayder**

## Changelog

### v3.0 (Current)
- ✨ Cross-platform support (macOS, Linux, Windows)
- ✨ Enhanced setup script with validation and backup
- ✨ Improved goto function with better reliability
- ✨ Platform-aware file manager integration
- ✨ Editor fallback system for debugging
- ✨ Enhanced error handling and user feedback
- ✨ Type hints for better code quality
- ✨ Improved backup and restore functionality
- ✨ Better shell configuration management

### v2.0 (Original)
- ✅ Basic bookmark management
- ✅ Directory navigation with goto function
- ✅ Backup and restore functionality
- ✅ Setup script for easy installation

## Support

If you encounter issues or have questions:

1. Check the [FAQ](#frequently-asked-questions) section below
2. Search [existing issues](https://github.com/hasinhayder/bookomark.py/issues)
3. [Create a new issue](https://github.com/hasinhayder/bookomark.py/issues/new) with details

### Frequently Asked Questions

**Q: The goto command doesn't work after setup. What should I do?**

A: Try these steps:
1. Run `source ~/.zshrc` (or `source ~/.bashrc` for bash)
2. Check that `bookmark --help` works
3. Verify bookmark.py exists in the expected location
4. Run the setup script again: `./setup.sh`

**Q: Can I use this with Fish shell?**

A: The setup script doesn't automatically configure Fish shell, but you can manually add the configuration to your Fish config file.

**Q: Where are my bookmarks stored?**

A: Bookmarks are stored in `~/.dir-bookmarks.txt` in your home directory.

**Q: How do I backup my bookmarks manually?**

A: Simply copy the `~/.dir-bookmarks.txt` file to a safe location. You can also use `bookmark --backup` for automatic timestamped backups.

**Q: Can I use special characters in bookmark names?**

A: Avoid using these characters in bookmark names: `< > : " | ? *` as they may cause issues with file paths.

**Q: The --open command doesn't work on my system.**

A: The --open command requires:
- macOS: The `open` command (built-in)
- Linux: The `xdg-open` command (usually available)
- Windows: Should work automatically in most environments

If it doesn't work, you may need to install the required command for your platform.

**Q: How do I completely uninstall the bookmark manager?**

A: To uninstall:
1. Remove the configuration from your shell config file (~/.zshrc or ~/.bashrc)
2. Delete the bookmarks file: `rm ~/.dir-bookmarks.txt`
3. Optionally delete the backup files: `rm ~/.dir-bookmarks-backup-*.txt`
4. Restart your terminal
