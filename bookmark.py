#!/usr/bin/env python3
"""
Directory Bookmark Manager
Saves and manages directory bookmarks in ~/.dir-bookmarks.txt

Author: Hasin Hayder
Repository: https://github.com/hasinhayder/bookomark.py
"""

import os
import sys
import subprocess
from pathlib import Path


class BookmarkManager:
    def __init__(self):
        self.bookmark_file = Path.home() / ".dir-bookmarks.txt"
        self.current_dir = os.getcwd()

    def load_bookmarks(self):
        # Load existing bookmarks from file
        bookmarks = {}
        if self.bookmark_file.exists():
            try:
                with open(self.bookmark_file, "r") as f:
                    for line in f:
                        line = line.strip()
                        if line and "|" in line:
                            name, path = line.split("|", 1)
                            bookmarks[path] = name
            except Exception as e:
                print(f"Error reading bookmarks: {e}")
        return bookmarks

    def save_bookmarks(self, bookmarks):
        # Save bookmarks to file
        try:
            with open(self.bookmark_file, "w") as f:
                for path, name in bookmarks.items():
                    f.write(f"{name}|{path}\n")
        except Exception as e:
            print(f"Error saving bookmarks: {e}")
            return False
        return True

    def add_bookmark(self):
        # Add current directory as bookmark
        bookmarks = self.load_bookmarks()

        # Check if current directory is already bookmarked
        if self.current_dir in bookmarks:
            print(
                f"Directory '{self.current_dir}' is already bookmarked as '{bookmarks[self.current_dir]}'"
            )
            return

        # Ask for friendly name
        while True:
            friendly_name = input("Enter a friendly name for this directory: ").strip()
            if friendly_name:
                break
            print("Please enter a valid name.")

        # Check if friendly name already exists
        existing_names = set(bookmarks.values())
        if friendly_name in existing_names:
            print(f"A bookmark with the name '{friendly_name}' already exists.")
            overwrite = input("Do you want to overwrite it? (y/N): ").strip().lower()
            if overwrite != "y":
                print("Bookmark not saved.")
                return
            # Remove existing bookmark with same name
            bookmarks = {
                path: name for path, name in bookmarks.items() if name != friendly_name
            }

        # Add new bookmark
        bookmarks[self.current_dir] = friendly_name

        if self.save_bookmarks(bookmarks):
            print(f"Bookmark '{friendly_name}' saved for '{self.current_dir}'")
        else:
            print("Failed to save bookmark.")

    def remove_bookmark(self):
        # Remove bookmark for current directory
        bookmarks = self.load_bookmarks()

        if self.current_dir not in bookmarks:
            print(f"No bookmark found for current directory: {self.current_dir}")
            return

        bookmark_name = bookmarks[self.current_dir]
        del bookmarks[self.current_dir]

        if self.save_bookmarks(bookmarks):
            print(f"Bookmark '{bookmark_name}' removed for '{self.current_dir}'")
        else:
            print("Failed to remove bookmark.")

    def _get_sorted_bookmark_list(self):
        # Get sorted list of bookmarks as (name, path) tuples
        bookmarks = self.load_bookmarks()
        bookmark_list = [(name, path) for path, name in bookmarks.items()]
        bookmark_list.sort(key=lambda x: x[0].lower())
        return bookmark_list

    def _check_bookmarks_exist(self):
        # Check if bookmarks exist and show message if empty
        bookmarks = self.load_bookmarks()
        if not bookmarks:
            print("No bookmarks found.", file=sys.stderr)
            print("Use 'bookmark' command to create bookmarks.", file=sys.stderr)
            return False
        return True

    def _display_bookmark_menu(
        self, title="Bookmarked directories", width=40, show_lowercase=True
    ):
        # Display bookmarks menu with numbers
        bookmark_list = self._get_sorted_bookmark_list()

        print(f"{title}:", file=sys.stderr)
        print("-" * width, file=sys.stderr)
        for i, (name, path) in enumerate(bookmark_list, 1):
            display_name = name.lower() if show_lowercase else name
            print(f"{i:2d}. {display_name}", file=sys.stderr)
        print("-" * width, file=sys.stderr)
        return bookmark_list

    def _get_user_selection(
        self, bookmark_list, prompt="Select a directory (number): "
    ):
        # Get user selection from bookmark list
        try:
            print(prompt, end="", file=sys.stderr)
            sys.stderr.flush()

            choice = sys.stdin.readline().strip()
            choice_num = int(choice)

            if 1 <= choice_num <= len(bookmark_list):
                return bookmark_list[choice_num - 1][1]  # Return path
            else:
                print(
                    f"Invalid selection. Please choose 1-{len(bookmark_list)}",
                    file=sys.stderr,
                )
                return None
        except ValueError:
            print("Invalid input. Please enter a number.", file=sys.stderr)
            return None
        except KeyboardInterrupt:
            print("\nCancelled.", file=sys.stderr)
            return None
        except EOFError:
            print("\nCancelled.", file=sys.stderr)
            return None

    def list_bookmarks(self):
        # List all bookmarks and allow selection by number
        if not self._check_bookmarks_exist():
            return

        bookmark_list = self._display_bookmark_menu()
        selected_path = self._get_user_selection(bookmark_list)

        if selected_path:
            print(selected_path)

    def open_bookmark(self):
        # List all bookmarks, allow selection, and open in Finder
        if not self._check_bookmarks_exist():
            return

        bookmark_list = self._display_bookmark_menu()
        selected_path = self._get_user_selection(
            bookmark_list, "Select a directory to open (number): "
        )

        if selected_path:
            # Check if directory exists
            if not os.path.exists(selected_path):
                print(f"Directory not found: {selected_path}", file=sys.stderr)
                return

            # Echo the directory path
            print(selected_path)

            # Open in Finder using the 'open' command
            self._run_command(
                ["open", selected_path],
                f"Opened '{selected_path}' in Finder",
                "Failed to open directory in Finder",
                "'open' command not found. This feature requires macOS.",
            )

    def _run_command(self, command, success_msg, error_msg_prefix, not_found_msg):
        # Run a subprocess command with error handling
        try:
            subprocess.run(command, check=True)
            print(success_msg, file=sys.stderr)
        except subprocess.CalledProcessError as e:
            print(f"{error_msg_prefix}: {e}", file=sys.stderr)
        except FileNotFoundError:
            print(not_found_msg, file=sys.stderr)

    def debug_bookmarks(self):
        # pen the bookmarks file in VS Code for debugging
        self._run_command(
            ["code", str(self.bookmark_file)],
            f"Opened '{self.bookmark_file}' in VS Code",
            "Failed to open file in VS Code",
            "'code' command not found. Please ensure VS Code is installed and 'code' command is available in PATH.",
        )

    def _handle_file_operation(self, operation, success_msg, error_prefix="Error"):
        # Handle file operations with error handling
        try:
            operation()
            print(success_msg, file=sys.stderr)
            return True
        except Exception as e:
            print(f"{error_prefix}: {e}", file=sys.stderr)
            return False

    def flush_bookmarks(self):
        # Clear all bookmarks from the file

        def clear_file():
            with open(self.bookmark_file, "w") as f:
                pass  # Just create/truncate the file

        self._handle_file_operation(
            clear_file, "All bookmarks have been cleared.", "Error clearing bookmarks"
        )

    def listall_bookmarks(self):
        # List all bookmarks with their full paths
        if not self._check_bookmarks_exist():
            return

        bookmark_list = self._get_sorted_bookmark_list()

        # Display all bookmarks with their paths
        print("All bookmarked directories:", file=sys.stderr)
        print("-" * 60, file=sys.stderr)
        for i, (name, path) in enumerate(bookmark_list, 1):
            print(f"{i:2d}. {name} -> {path}", file=sys.stderr)
        print("-" * 60, file=sys.stderr)
        print(f"Total: {len(bookmark_list)} bookmark(s)", file=sys.stderr)

    def show_help(self):
        # Display comprehensive help information
        help_text = """
Directory Bookmark Manager v2.0
===============================
Author: Hasin Hayder
Repository: https://github.com/hasinhayder/bookomark.py

USAGE:
    bookmark [OPTION]

OPTIONS:
    (no option)     Add current directory as bookmark
                    - Prompts for a friendly name
                    - Prevents duplicate directories and names
                    - Saves to ~/.dir-bookmarks.txt

    --remove        Remove bookmark for current directory
                    - Deletes the bookmark for the current working directory
                    - Shows confirmation message

    --list          List bookmarks and select one
                    - Shows bookmarks in lowercase, sorted alphabetically
                    - Prompts for number selection
                    - Outputs selected directory path (useful for scripting)

    --open          List bookmarks and open selected directory in Finder
                    - Same interface as --list
                    - Opens selected directory in macOS Finder
                    - Requires macOS and 'open' command

    --go            Navigate to bookmarked directory
                    - Shows bookmarks in lowercase, sorted alphabetically
                    - Prompts for number selection
                    - Outputs selected directory path for shell navigation
                    - Used by goto shell function

    --listall       Display all bookmarks with their full paths
                    - Shows name -> path mapping
                    - Includes total count
                    - No selection required

    --debug         Open bookmarks file in VS Code
                    - Opens ~/.dir-bookmarks.txt in VS Code for manual editing
                    - Requires VS Code with 'code' command in PATH

    --flush         Clear all bookmarks permanently
                    - Deletes all bookmarks from the file
                    - Use with caution - this action cannot be undone

    --backup        Create a timestamped backup of bookmarks
                    - Saves current bookmarks to ~/.dir-bookmarks-backup-YYYYMMDD_HHMMSS.txt
                    - Shows count of backed up bookmarks
                    - Safe operation - doesn't modify existing bookmarks

    --restore       Restore bookmarks from a backup file
                    - Lists available backup files with timestamps and bookmark counts
                    - Prompts for backup selection
                    - Creates backup of current bookmarks before restore
                    - Confirms before overwriting current bookmarks

    --help          Show this help message

EXAMPLES:
    bookmark                    # Add current directory as bookmark
    bookmark --remove           # Remove current directory's bookmark
    bookmark --list             # List and select bookmark (outputs path)
    bookmark --open             # List and open bookmark in Finder
    bookmark --listall          # Show all bookmarks with paths
    bookmark --debug            # Edit bookmarks file in VS Code
    bookmark --flush            # Clear all bookmarks
    bookmark --backup           # Create timestamped backup of bookmarks
    bookmark --restore          # Restore bookmarks from backup
    bookmark --help             # Show this help
    goto                        # Navigate to bookmarked directory (shell function)

RELATED COMMANDS:
    goto                        # Navigate to bookmarked directory (shell function)
                                # Uses 'bookmark --go' internally

FILES:
    ~/.dir-bookmarks.txt        # Bookmark storage file

NOTES:
    - Bookmarks are stored as: friendly_name|/full/path/to/directory
    - Directory names are displayed in lowercase but stored with original case
    - Duplicate directory paths and friendly names are prevented
    - The --open feature requires macOS
    - The --debug feature requires VS Code with 'code' command available
"""
        print(help_text.strip())

    def go_bookmark(self):
        # Navigate to bookmarked directory (same as goto.py functionality)
        if not self._check_bookmarks_exist():
            return

        bookmark_list = self._display_bookmark_menu()
        selected_path = self._get_user_selection(bookmark_list)

        if selected_path:
            print(selected_path)

    def backup_bookmarks(self):
        # Create a backup of current bookmarks
        if not self.bookmark_file.exists():
            print("No bookmarks file found to backup.", file=sys.stderr)
            return

        # Get timestamp for backup filename
        import datetime

        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = Path.home() / f".dir-bookmarks-backup-{timestamp}.txt"

        try:
            # Copy bookmarks file to backup
            import shutil

            shutil.copy2(self.bookmark_file, backup_file)
            print(f"Bookmarks backed up to: {backup_file}", file=sys.stderr)

            # Also show current bookmark count
            bookmarks = self.load_bookmarks()
            print(f"Backed up {len(bookmarks)} bookmark(s)", file=sys.stderr)

        except Exception as e:
            print(f"Error creating backup: {e}", file=sys.stderr)

    def restore_bookmarks(self):
        # Restore bookmarks from a backup file
        backup_dir = Path.home()
        backup_files = list(backup_dir.glob(".dir-bookmarks-backup-*.txt"))

        if not backup_files:
            print("No backup files found.", file=sys.stderr)
            print(
                "Backup files should be named: ~/.dir-bookmarks-backup-YYYYMMDD_HHMMSS.txt",
                file=sys.stderr,
            )
            return

        # Sort backup files by modification time (newest first)
        backup_files.sort(key=lambda x: x.stat().st_mtime, reverse=True)

        print("Available backup files:", file=sys.stderr)
        print("-" * 50, file=sys.stderr)

        for i, backup_file in enumerate(backup_files, 1):
            # Extract timestamp from filename
            filename = backup_file.name
            timestamp_part = filename.replace(".dir-bookmarks-backup-", "").replace(
                ".txt", ""
            )

            try:
                # Parse timestamp for display
                from datetime import datetime

                dt = datetime.strptime(timestamp_part, "%Y%m%d_%H%M%S")
                formatted_date = dt.strftime("%Y-%m-%d %H:%M:%S")

                # Count bookmarks in backup file
                backup_count = 0
                try:
                    with open(backup_file, "r") as f:
                        backup_count = sum(
                            1 for line in f if line.strip() and "|" in line
                        )
                except:
                    backup_count = "?"

                print(
                    f"{i:2d}. {formatted_date} ({backup_count} bookmarks)",
                    file=sys.stderr,
                )

            except ValueError:
                # If timestamp parsing fails, just show filename
                print(f"{i:2d}. {filename}", file=sys.stderr)

        print("-" * 50, file=sys.stderr)

        # Get user selection
        try:
            print("Select backup to restore (number): ", end="", file=sys.stderr)
            sys.stderr.flush()

            choice = sys.stdin.readline().strip()
            choice_num = int(choice)

            if 1 <= choice_num <= len(backup_files):
                selected_backup = backup_files[choice_num - 1]

                # Show current bookmarks count before restore
                current_bookmarks = self.load_bookmarks()
                current_count = len(current_bookmarks)

                # Confirm restore operation
                print(
                    f"This will replace your current {current_count} bookmark(s).",
                    file=sys.stderr,
                )
                confirm = (
                    input("Are you sure you want to restore? (y/N): ").strip().lower()
                )

                if confirm == "y":
                    try:
                        import shutil

                        # Create backup of current file before restore
                        if self.bookmark_file.exists():
                            current_backup = (
                                Path.home()
                                / f".dir-bookmarks-before-restore-{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
                            )
                            shutil.copy2(self.bookmark_file, current_backup)
                            print(
                                f"Current bookmarks backed up to: {current_backup}",
                                file=sys.stderr,
                            )

                        # Restore from selected backup
                        shutil.copy2(selected_backup, self.bookmark_file)

                        # Verify restore
                        restored_bookmarks = self.load_bookmarks()
                        print(
                            f"Successfully restored {len(restored_bookmarks)} bookmark(s) from backup.",
                            file=sys.stderr,
                        )

                    except Exception as e:
                        print(f"Error restoring backup: {e}", file=sys.stderr)
                else:
                    print("Restore cancelled.", file=sys.stderr)
            else:
                print(
                    f"Invalid selection. Please choose 1-{len(backup_files)}",
                    file=sys.stderr,
                )

        except ValueError:
            print("Invalid input. Please enter a number.", file=sys.stderr)
        except KeyboardInterrupt:
            print("\nCancelled.", file=sys.stderr)
        except EOFError:
            print("\nCancelled.", file=sys.stderr)


def main():
    manager = BookmarkManager()

    # Command mapping for cleaner main function
    commands = {
        "--remove": manager.remove_bookmark,
        "--list": manager.list_bookmarks,
        "--open": manager.open_bookmark,
        "--go": manager.go_bookmark,
        "--debug": manager.debug_bookmarks,
        "--flush": manager.flush_bookmarks,
        "--listall": manager.listall_bookmarks,
        "--backup": manager.backup_bookmarks,
        "--restore": manager.restore_bookmarks,
        "--help": manager.show_help,
    }

    if len(sys.argv) > 1:
        command = sys.argv[1]
        if command in commands:
            commands[command]()
        else:
            print(f"Unknown option: {command}", file=sys.stderr)
            print(
                "Usage: bookmark [--remove|--list|--open|--go|--debug|--flush|--listall|--backup|--restore|--help]",
                file=sys.stderr,
            )
            sys.exit(1)
    else:
        # Add bookmark mode (default)
        manager.add_bookmark()


if __name__ == "__main__":
    main()
