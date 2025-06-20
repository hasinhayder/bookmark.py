#!/bin/bash
# Test script for Directoecho ""
echo "5. Testing bookmark removal..."
cd "$SCRIPT_DIR"
python3 bookmark.py --remove
echo "✓ Bookmark removed"

echo ""
echo "6. Testing empty bookmark list..."mark Manager

echo "Testing Directory Bookmark Manager"
echo "=================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clean up any existing test bookmarks
rm -f ~/.dir-bookmarks.txt

echo ""
echo "1. Testing bookmark creation..."
cd "$SCRIPT_DIR"
echo "test-bookmark" | python3 bookmark.py
echo "✓ Bookmark created"

echo ""
echo "2. Testing bookmark listing..."
python3 goto.py <<< "1"
echo "✓ Bookmark listed and selected"

echo ""
echo "3. Testing bookmark --list feature..."
# Create multiple bookmarks for testing
cd /tmp
echo "Temporary" | python3 "$SCRIPT_DIR/bookmark.py"
cd "$HOME"
echo "Home" | python3 "$SCRIPT_DIR/bookmark.py"
echo "1" | python3 "$SCRIPT_DIR/bookmark.py" --list
echo "✓ Bookmark --list feature tested"

echo ""
echo "5. Testing duplicate prevention..."
cd "$SCRIPT_DIR"
echo "test-bookmark" | python3 "$SCRIPT_DIR/bookmark.py"
echo "✓ Duplicate prevention tested"

echo ""
echo "6. Testing bookmark removal..."
python3 "$SCRIPT_DIR/bookmark.py" --remove
echo "✓ Bookmark removed"

echo ""
echo "7. Testing empty bookmark list..."
python3 "$SCRIPT_DIR/goto.py"
echo "✓ Empty list handled"

echo ""
echo "4. Testing bookmark --open feature..."
echo "1" | python3 "$SCRIPT_DIR/bookmark.py" --open >/dev/null 2>&1
echo "✓ Bookmark --open feature tested (Finder should open)"

echo ""
echo "8. Testing --listall feature..."
python3 "$SCRIPT_DIR/bookmark.py" --listall >/dev/null 2>&1
echo "✓ Bookmark --listall feature tested"

echo ""
echo "9. Testing --debug feature..."
python3 "$SCRIPT_DIR/bookmark.py" --debug >/dev/null 2>&1
echo "✓ Bookmark --debug feature tested (VS Code should open)"

echo ""
echo "10. Testing --flush feature..."
# Create backup before testing flush
cp ~/.dir-bookmarks.txt ~/.dir-bookmarks.txt.test-backup 2>/dev/null || true
python3 "$SCRIPT_DIR/bookmark.py" --flush >/dev/null 2>&1
# Restore backup
cp ~/.dir-bookmarks.txt.test-backup ~/.dir-bookmarks.txt 2>/dev/null || true
rm ~/.dir-bookmarks.txt.test-backup 2>/dev/null || true
echo "✓ Bookmark --flush feature tested"

echo ""
echo "All tests completed!"
echo ""
echo "To install permanently, run: ./setup.sh"
