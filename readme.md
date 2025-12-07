# Bookmark.py - Your Directory Navigator

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/python-3.6%2B-brightgreen.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey.svg)
![Version](https://img.shields.io/badge/version-3.0-blue.svg)

Tired of typing long paths? Bookmark.py is your magical teleportation device for directories! 🪄

Jump between your favorite folders with just two commands: `bookmark` and `goto`. No more cd-ing through endless directories!

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/hasinhayder/bookomark.py.git
cd bookmark.py

# 2. Run the magic setup script
./setup.sh

# 3. Restart your terminal and start teleporting!
bookmark  # Save your current directory
goto      # Jump to any bookmarked directory
```

## How It Works

### Save Your Favorite Spots
```bash
# Navigate to a directory you love
cd ~/projects/awesome-app

# Bookmark it with a memorable name
bookmark
# Enter name: awesome

# That's it! Your spot is saved forever 
```

### Teleport Instantly
```bash
# See all your bookmarks and jump to any
goto
# 1. awesome
# 2. docs
# 3. config
# Select: 1
# Poof! You're now in ~/projects/awesome-app 
```

## Cool Tricks

| Command | What It Does |
|---------|--------------|
| `bookmark` | Save current directory |
| `bookmark --remove` | Remove current directory's bookmark |
| `bookmark --list` | Show all bookmarks |
| `bookmark --open` | Open bookmark in file manager |
| `bookmark --backup` | Create backup of bookmarks |
| `bookmark --restore` | Restore from backup |
| `bookmark --flush` | Clear all bookmarks |
| `goto` | Jump to any bookmarked directory |

## Pro Tips

### File Manager Magic
```bash
bookmark --open
# 1. awesome
# 2. docs
# Select: 1
# Opens ~/projects/awesome-app in Finder/Explorer/File Manager 
```

### Backup Your Bookmarks
```bash
bookmark --backup
# Creates: ~/.dir-bookmarks-backup-20231207_143025.txt
# Your bookmarks are safe! 
```

### Emergency Restore
```bash
bookmark --restore
# Shows all your backups with timestamps
# Pick one and restore your bookmarks 
```

## Why You'll Love It

- **Lightning Fast** - Jump to any directory in seconds
- **Cross-Platform** - Works on macOS, Linux, and Windows
- **Dead Simple** - Just two commands to remember
- **Safe & Sound** - Automatic backups before any changes
- **No More Typos** - Say goodbye to long path typing

## What's Inside

- `bookmark.py` - The magic wand 
- `goto_function.sh` - The teleportation device 
- `setup.sh` - The installation wizard 

## Contributing

Found a bug or have an idea? [Open an issue](https://github.com/hasinhayder/bookomark.py/issues) or submit a pull request!

## License

MIT License - Use it however you want! 

---

**Made with ❤️ by [Hasin Hayder](https://github.com/hasinhayder)**

*Stop walking, start teleporting!* 