# Directory Bookmark Manager

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/python-3.6%2B-brightgreen.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)

A command-line tool to bookmark directories and quickly navigate between them.

**Author:** Hasin Hayder  
**Repository:** https://github.com/hasinhayder/bookomark.py

## Quick Start

1. Clone or download this repository
2. Run the setup script: `./setup.sh`
3. Restart your terminal or run `source ~/.zshrc`
4. Start bookmarking: `bookmark` and navigating: `goto`

## Features

- Save current directory with a friendly name
- Remove bookmarks for current directory
- List all bookmarks in alphabetical order
- Navigate to bookmarked directories using `goto` function
- Open bookmarked directories in Finder (macOS)
- Debug bookmarks file in VS Code
- Bulk operations (list all, flush all)
- Duplicate prevention for both paths and names
- Automatic setup script for easy installation

## Installation

**Easy Setup (Recommended):**

Run the setup script to automatically configure everything:

```bash
./setup.sh
```

This will:

- Add the `bookmark` alias to your shell configuration
- Source the `goto_function.sh` to enable the `goto` command
- Configure everything for immediate use

After setup, either restart your terminal or run:

```bash
source ~/.zshrc  # or ~/.bashrc for bash users
```

**Manual Setup (Advanced):**

If you prefer manual installation, add these lines to your `~/.zshrc` (or `~/.bashrc` for bash):

```bash
# Directory Bookmark Manager
alias bookmark='python3 /path/to/bookmark.py'
source /path/to/goto_function.sh
```

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
bookmark --go
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

### Example Usage for --open Feature

```bash
# Open a bookmark in Finder
bookmark --open
# Shows:
# 1. docs
# 2. myapp
# Select: 1
# Outputs: /Users/username/Documents/Important
# Opens the directory in Finder
```

### Example Usage for --debug, --flush, and --listall Features

```bash
# Debug bookmarks file
bookmark --debug
# Opens ~/.dir-bookmarks.txt in VS Code

# Clear all bookmarks
bookmark --flush
# Removes all bookmarks permanently

# List all bookmarks with paths
bookmark --listall
# Shows:
# 1. docs -> /Users/username/Documents/Important
# 2. myapp -> /Users/username/Projects/MyApp
# Total: 2 bookmark(s)
```

## Available Commands

- `bookmark` - Add current directory as bookmark
- `bookmark --remove` - Remove current directory's bookmark
- `bookmark --list` - List bookmarks and select one (outputs path)
- `bookmark --open` - List bookmarks and open selected one in Finder
- `bookmark --go` - Navigate to bookmarked directory (outputs path for shell)
- `bookmark --listall` - Display all bookmarks with their full paths
- `bookmark --debug` - Open bookmarks file in VS Code for editing
- `bookmark --flush` - Clear all bookmarks permanently
- `goto` - Navigate to bookmarked directory (shell function that changes current directory)

## File Structure

- `bookmark.py` - Main script with all bookmark management and navigation features
- `goto_function.sh` - Shell function for directory navigation (uses bookmark --go)
- `setup.sh` - Automated setup script for easy installation
- `test.sh` - Test script to verify all functionality works
- `~/.dir-bookmarks.txt` - Storage file for bookmarks (auto-created)

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
bookmark --go
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
```

## Error Handling

- Prevents duplicate directory bookmarks
- Warns about duplicate friendly names with option to overwrite
- Validates directory existence when navigating
- Handles file I/O errors gracefully
- Input validation for user selections

## Author & Repository

**Author:** Hasin Hayder  
**GitHub:** https://github.com/hasinhayder/bookomark.py  

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### MIT License Summary

- ✅ **Commercial use** - Use in commercial projects
- ✅ **Modification** - Modify the source code
- ✅ **Distribution** - Distribute copies
- ✅ **Private use** - Use privately
- ✅ **Patent use** - Grant of patent rights from contributors

**Copyright (c) 2025 Hasin Hayder**
