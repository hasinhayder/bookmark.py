# Directory Bookmark Manager

A command-line tool to bookmark directories and quickly navigate between them.

## Features

- Save current directory with a friendly name
- Remove bookmarks for current directory
- List all bookmarks in alphabetical order
- Navigate to bookmarked directories by selecting a number
- Duplicate prevention for both paths and names

## Installation

1. Copy the files to a directory in your PATH or use them from the current location
2. Make the scripts executable (already done):

   ```bash
   chmod +x bookmark.py goto.py goto
   ```

3. For the `goto` command to work properly, you have two options:

   **Option A: Add to your shell profile (Recommended)**
   Add this line to your `~/.zshrc` (or `~/.bashrc` if using bash):

   ```bash
   source /path/to/commandline/goto_function.sh
   ```

   Then reload your shell: `source ~/.zshrc`

   **Option B: Create aliases**
   Add these aliases to your `~/.zshrc`:

   ```bash
   alias bookmark='/path/to/commandline/bookmark.py'
   alias goto='source /path/to/commandline/goto_function.sh && goto'
   ```

## Usage

### Bookmarking Directories

**Add a bookmark for current directory:**

```bash
python3 bookmark.py
# or if you set up aliases:
bookmark
```

You'll be prompted to enter a friendly name for the current directory.

**Remove bookmark for current directory:**

```bash
python3 bookmark.py --remove
# or if you set up aliases:
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

**Navigate to bookmarks (for shell scripting):**

```bash
python3 bookmark.py --go
# or if you set up aliases:
bookmark --go
```

This will:

1. Show all bookmarked directories with names in lowercase
2. Display them sorted alphabetically with numbers
3. Prompt you to select a number
4. Echo the corresponding directory path (used by goto shell function)

**List all bookmarks and select one:**

```bash
python3 bookmark.py --list
# or if you set up aliases:
bookmark --list
```

This will:

1. Show all bookmarked directories with names in lowercase
2. Display them sorted alphabetically with numbers
3. Prompt you to select a number
4. Echo the corresponding directory path

**Open bookmark in Finder:**

```bash
python3 bookmark.py --open
# or if you set up aliases:
bookmark --open
```

This will:

1. Show all bookmarked directories with names in lowercase
2. Display them sorted alphabetically with numbers
3. Prompt you to select a number
4. Echo the corresponding directory path
5. Open the selected directory in Finder (macOS only)

### Debugging and Maintenance

**Debug bookmarks file:**

```bash
python3 bookmark.py --debug
# or if you set up aliases:
bookmark --debug
```

This opens the `~/.dir-bookmarks.txt` file in VS Code for manual editing or debugging.

**Clear all bookmarks:**

```bash
python3 bookmark.py --flush
# or if you set up aliases:
bookmark --flush
```

This permanently deletes all bookmarks from the file.

**List all bookmarks with paths:**

```bash
python3 bookmark.py --listall
# or if you set up aliases:
bookmark --listall
```

This displays all bookmarks with their full directory paths and a total count.

### Example Usage for --open Feature

```bash
# Open a bookmark in Finder
python3 bookmark.py --open
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
python3 bookmark.py --debug
# Opens ~/.dir-bookmarks.txt in VS Code

# Clear all bookmarks
python3 bookmark.py --flush
# Removes all bookmarks permanently

# List all bookmarks with paths
python3 bookmark.py --listall
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
python3 bookmark.py
# Enter: "myapp"

# Navigate to another directory
cd ~/Documents/Important
python3 bookmark.py
# Enter: "docs"

# Later, from anywhere:
goto
# Shows:
# 1. docs
# 2. myapp
# Select: 2
# Changes to ~/Projects/MyApp

# Remove a bookmark
cd ~/Projects/MyApp
python3 bookmark.py --remove
# Removes the "myapp" bookmark

# Navigate using goto function
goto
# Shows:
# 1. docs
# 2. myapp
# Select: 2
# Changes to ~/Projects/MyApp

# Get directory path for scripting
python3 bookmark.py --go
# Shows:
# 1. docs
# 2. myapp
# Select: 1
# Outputs: /Users/username/Documents/Important

# List all bookmarks and get a path
python3 bookmark.py --list
# Shows:
# 1. docs
# 2. myapp
# Select: 1
# Outputs: /Users/username/Documents/Important

# Open a bookmark in Finder
python3 bookmark.py --open
# Shows:
# 1. docs
# 2. myapp
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
