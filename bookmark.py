#!/usr/bin/env python3
"""
Directory Bookmark Manager
Saves and manages directory bookmarks in ~/.dir-bookmarks.txt
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
        """Load existing bookmarks from file"""
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
        """Save bookmarks to file"""
        try:
            with open(self.bookmark_file, "w") as f:
                for path, name in bookmarks.items():
                    f.write(f"{name}|{path}\n")
        except Exception as e:
            print(f"Error saving bookmarks: {e}")
            return False
        return True

    def add_bookmark(self):
        """Add current directory as bookmark"""
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
        """Remove bookmark for current directory"""
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

    def list_bookmarks(self):
        """List all bookmarks and allow selection by number"""
        bookmarks = self.load_bookmarks()

        if not bookmarks:
            print("No bookmarks found.", file=sys.stderr)
            print("Use 'bookmark' command to create bookmarks.", file=sys.stderr)
            return

        # Convert to list of (name, path) tuples and sort by name (case-insensitive)
        bookmark_list = [(name, path) for path, name in bookmarks.items()]
        bookmark_list.sort(key=lambda x: x[0].lower())

        # Display bookmarks in lowercase
        print("Bookmarked directories:", file=sys.stderr)
        print("-" * 40, file=sys.stderr)
        for i, (name, path) in enumerate(bookmark_list, 1):
            print(f"{i:2d}. {name.lower()}", file=sys.stderr)
        print("-" * 40, file=sys.stderr)

        # Get user selection
        try:
            # Print prompt to stderr to avoid capturing it
            print("Select a directory (number): ", end="", file=sys.stderr)
            sys.stderr.flush()

            # Read input from stdin
            choice = sys.stdin.readline().strip()
            choice_num = int(choice)

            if 1 <= choice_num <= len(bookmark_list):
                # Output the selected path to stdout (this will be captured by shell script)
                selected_path = bookmark_list[choice_num - 1][1]
                print(selected_path)
            else:
                print(
                    f"Invalid selection. Please choose 1-{len(bookmark_list)}",
                    file=sys.stderr,
                )
        except ValueError:
            print("Invalid input. Please enter a number.", file=sys.stderr)
        except KeyboardInterrupt:
            print("\nCancelled.", file=sys.stderr)
        except EOFError:
            print("\nCancelled.", file=sys.stderr)

    def open_bookmark(self):
        """List all bookmarks, allow selection, and open in Finder"""
        bookmarks = self.load_bookmarks()

        if not bookmarks:
            print("No bookmarks found.", file=sys.stderr)
            print("Use 'bookmark' command to create bookmarks.", file=sys.stderr)
            return

        # Convert to list of (name, path) tuples and sort by name (case-insensitive)
        bookmark_list = [(name, path) for path, name in bookmarks.items()]
        bookmark_list.sort(key=lambda x: x[0].lower())

        # Display bookmarks in lowercase
        print("Bookmarked directories:", file=sys.stderr)
        print("-" * 40, file=sys.stderr)
        for i, (name, path) in enumerate(bookmark_list, 1):
            print(f"{i:2d}. {name.lower()}", file=sys.stderr)
        print("-" * 40, file=sys.stderr)

        # Get user selection
        try:
            # Print prompt to stderr to avoid capturing it
            print("Select a directory to open (number): ", end="", file=sys.stderr)
            sys.stderr.flush()

            # Read input from stdin
            choice = sys.stdin.readline().strip()
            choice_num = int(choice)

            if 1 <= choice_num <= len(bookmark_list):
                # Get the selected path
                selected_path = bookmark_list[choice_num - 1][1]

                # Check if directory exists
                if not os.path.exists(selected_path):
                    print(f"Directory not found: {selected_path}", file=sys.stderr)
                    return

                # Echo the directory path
                print(selected_path)

                # Open in Finder using the 'open' command
                try:
                    subprocess.run(["open", selected_path], check=True)
                    print(f"Opened '{selected_path}' in Finder", file=sys.stderr)
                except subprocess.CalledProcessError as e:
                    print(f"Failed to open directory in Finder: {e}", file=sys.stderr)
                except FileNotFoundError:
                    print(
                        "'open' command not found. This feature requires macOS.",
                        file=sys.stderr,
                    )
            else:
                print(
                    f"Invalid selection. Please choose 1-{len(bookmark_list)}",
                    file=sys.stderr,
                )
        except ValueError:
            print("Invalid input. Please enter a number.", file=sys.stderr)
        except KeyboardInterrupt:
            print("\nCancelled.", file=sys.stderr)
        except EOFError:
            print("\nCancelled.", file=sys.stderr)

    def debug_bookmarks(self):
        """Open the bookmarks file in VS Code for debugging"""
        try:
            subprocess.run(["code", str(self.bookmark_file)], check=True)
            print(f"Opened '{self.bookmark_file}' in VS Code", file=sys.stderr)
        except subprocess.CalledProcessError as e:
            print(f"Failed to open file in VS Code: {e}", file=sys.stderr)
        except FileNotFoundError:
            print(
                "'code' command not found. Please ensure VS Code is installed and 'code' command is available in PATH.",
                file=sys.stderr,
            )

    def flush_bookmarks(self):
        """Clear all bookmarks from the file"""
        try:
            # Create empty file or truncate existing one
            with open(self.bookmark_file, "w") as f:
                pass  # Just create/truncate the file
            print("All bookmarks have been cleared.", file=sys.stderr)
        except Exception as e:
            print(f"Error clearing bookmarks: {e}", file=sys.stderr)

    def listall_bookmarks(self):
        """List all bookmarks with their full paths"""
        bookmarks = self.load_bookmarks()

        if not bookmarks:
            print("No bookmarks found.", file=sys.stderr)
            print("Use 'bookmark' command to create bookmarks.", file=sys.stderr)
            return

        # Convert to list of (name, path) tuples and sort by name (case-insensitive)
        bookmark_list = [(name, path) for path, name in bookmarks.items()]
        bookmark_list.sort(key=lambda x: x[0].lower())

        # Display all bookmarks with their paths
        print("All bookmarked directories:", file=sys.stderr)
        print("-" * 60, file=sys.stderr)
        for i, (name, path) in enumerate(bookmark_list, 1):
            print(f"{i:2d}. {name} -> {path}", file=sys.stderr)
        print("-" * 60, file=sys.stderr)
        print(f"Total: {len(bookmark_list)} bookmark(s)", file=sys.stderr)

    def show_help(self):
        """Display comprehensive help information"""
        help_text = """
Directory Bookmark Manager v2.0
===============================

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

    --help          Show this help message

EXAMPLES:
    bookmark                    # Add current directory as bookmark
    bookmark --remove           # Remove current directory's bookmark
    bookmark --list             # List and select bookmark (outputs path)
    bookmark --open             # List and open bookmark in Finder
    bookmark --listall          # Show all bookmarks with paths
    bookmark --debug            # Edit bookmarks file in VS Code
    bookmark --flush            # Clear all bookmarks
    bookmark --help             # Show this help

RELATED COMMANDS:
    goto                        # Navigate to bookmarked directory (interactive)

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


def main():
    manager = BookmarkManager()

    if len(sys.argv) > 1:
        if sys.argv[1] == "--remove":
            # Remove bookmark mode
            manager.remove_bookmark()
        elif sys.argv[1] == "--list":
            # List bookmarks mode
            manager.list_bookmarks()
        elif sys.argv[1] == "--open":
            # Open bookmark in Finder mode
            manager.open_bookmark()
        elif sys.argv[1] == "--debug":
            # Debug bookmarks in VS Code
            manager.debug_bookmarks()
        elif sys.argv[1] == "--flush":
            # Flush all bookmarks
            manager.flush_bookmarks()
        elif sys.argv[1] == "--listall":
            # List all bookmarks with paths
            manager.listall_bookmarks()
        elif sys.argv[1] == "--help":
            # Show help
            manager.show_help()
        else:
            print(f"Unknown option: {sys.argv[1]}", file=sys.stderr)
            print(
                "Usage: bookmark [--remove|--list|--open|--debug|--flush|--listall|--help]",
                file=sys.stderr,
            )
            sys.exit(1)
    else:
        # Add bookmark mode
        manager.add_bookmark()


if __name__ == "__main__":
    main()
