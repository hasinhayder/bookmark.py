#!/usr/bin/env python3
"""
Directory Bookmark Navigator
Lists bookmarked directories and allows selection by number
"""

import sys
from pathlib import Path


class BookmarkNavigator:
    def __init__(self):
        self.bookmark_file = Path.home() / ".dir-bookmarks.txt"

    def load_bookmarks(self):
        """Load bookmarks and return sorted list of (name, path) tuples"""
        bookmarks = []
        if self.bookmark_file.exists():
            try:
                with open(self.bookmark_file, "r") as f:
                    for line in f:
                        line = line.strip()
                        if line and "|" in line:
                            name, path = line.split("|", 1)
                            bookmarks.append((name, path))
            except Exception as e:
                print(f"Error reading bookmarks: {e}", file=sys.stderr)
                return []

        # Sort by friendly name (case-insensitive)
        bookmarks.sort(key=lambda x: x[0].lower())
        return bookmarks

    def show_bookmarks(self):
        """Display bookmarks and handle user selection"""
        bookmarks = self.load_bookmarks()

        if not bookmarks:
            print("No bookmarks found.", file=sys.stderr)
            print("Use 'bookmark' command to create bookmarks.", file=sys.stderr)
            return

        # Display bookmarks
        print("Bookmarked directories:", file=sys.stderr)
        print("-" * 40, file=sys.stderr)
        for i, (name, path) in enumerate(bookmarks, 1):
            print(f"{i:2d}. {name}", file=sys.stderr)
        print("-" * 40, file=sys.stderr)

        # Get user selection
        try:
            # Print prompt to stderr to avoid capturing it
            print("Select a directory (number): ", end="", file=sys.stderr)
            sys.stderr.flush()

            # Read input from stdin
            choice = sys.stdin.readline().strip()
            choice_num = int(choice)

            if 1 <= choice_num <= len(bookmarks):
                # Output the selected path to stdout (this will be captured by shell script)
                selected_path = bookmarks[choice_num - 1][1]
                print(selected_path)
            else:
                print(
                    f"Invalid selection. Please choose 1-{len(bookmarks)}",
                    file=sys.stderr,
                )
        except ValueError:
            print("Invalid input. Please enter a number.", file=sys.stderr)
        except KeyboardInterrupt:
            print("\nCancelled.", file=sys.stderr)
        except EOFError:
            print("\nCancelled.", file=sys.stderr)


def main():
    navigator = BookmarkNavigator()
    navigator.show_bookmarks()


if __name__ == "__main__":
    main()
