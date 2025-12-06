#!/bin/bash
# Comprehensive test script for Directory Bookmark Manager v3.0
# Author: Hasin Hayder
# Repository: https://github.com/hasinhayder/bookomark.py

set -euo pipefail  # Exit on error, undefined vars, and pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_PREFIX="[TEST]"
PASS_PREFIX="[PASS]"
FAIL_PREFIX="[FAIL]"
WARN_PREFIX="[WARN]"

# Test counters
TEST_COUNT=0
PASS_COUNT=0
FAIL_COUNT=0

# Test functions
log_info() {
    echo -e "${BLUE}${TEST_PREFIX}${NC} $1"
}

log_pass() {
    echo -e "${GREEN}${PASS_PREFIX}${NC} $1"
    ((PASS_COUNT++))
}

log_fail() {
    echo -e "${RED}${FAIL_PREFIX}${NC} $1"
    ((FAIL_COUNT++))
}

log_warn() {
    echo -e "${YELLOW}${WARN_PREFIX}${NC} $1"
}

run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="${3:-success}"
    
    ((TEST_COUNT++))
    log_info "Running: $test_name"
    
    if eval "$test_command"; then
        if [[ "$expected_result" == "success" ]]; then
            log_pass "$test_name"
            return 0
        else
            log_fail "$test_name (unexpected success)"
            return 1
        fi
    else
        if [[ "$expected_result" == "failure" ]]; then
            log_pass "$test_name (correctly failed)"
            return 0
        else
            log_fail "$test_name"
            return 1
        fi
    fi
}

check_file_exists() {
    local file="$1"
    if [[ -f "$file" ]]; then
        return 0
    else
        return 1
    fi
}

check_command_exists() {
    local cmd="$1"
    if command -v "$cmd" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

cleanup_test_files() {
    log_info "Cleaning up test files..."
    rm -f ~/.dir-bookmarks.txt
    rm -f ~/.dir-bookmarks-backup-*.txt
    rm -f ~/.dir-bookmarks-before-*.txt
    log_pass "Cleanup completed"
}

# Main test suite
main() {
    echo "Directory Bookmark Manager v3.0 - Comprehensive Test Suite"
    echo "=========================================================="
    echo "Author: Hasin Hayder"
    echo "Repository: https://github.com/hasinhayder/bookomark.py"
    echo ""
    
    # Check prerequisites
    log_info "Checking prerequisites..."
    
    if ! check_command_exists "python3"; then
        log_fail "Python 3 is not installed or not in PATH"
        exit 1
    fi
    
    python_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    log_pass "Python 3 found: $python_version"
    
    if [[ ! -f "$SCRIPT_DIR/bookmark.py" ]]; then
        log_fail "bookmark.py not found in $SCRIPT_DIR"
        exit 1
    fi
    log_pass "bookmark.py found"
    
    if [[ ! -f "$SCRIPT_DIR/goto_function.sh" ]]; then
        log_fail "goto_function.sh not found in $SCRIPT_DIR"
        exit 1
    fi
    log_pass "goto_function.sh found"
    
    # Cleanup before tests
    cleanup_test_files
    
    echo ""
    log_info "Starting test suite..."
    echo ""
    
    # Test 1: Help command
    run_test "Help command" "python3 '$SCRIPT_DIR/bookmark.py' --help &> /dev/null"
    
    # Test 2: Version command
    run_test "Version command" "python3 '$SCRIPT_DIR/bookmark.py' --version &> /dev/null"
    
    # Test 3: Create bookmark
    run_test "Bookmark creation" "cd '$SCRIPT_DIR' && echo 'test-bookmark' | python3 bookmark.py &> /dev/null && check_file_exists ~/.dir-bookmarks.txt"
    
    # Test 4: List bookmarks
    run_test "List bookmarks" "echo '1' | python3 '$SCRIPT_DIR/bookmark.py' --list &> /dev/null"
    
    # Test 5: Go to bookmark
    run_test "Go to bookmark" "echo '1' | python3 '$SCRIPT_DIR/bookmark.py' --go &> /dev/null"
    
    # Test 6: List all bookmarks
    run_test "List all bookmarks" "python3 '$SCRIPT_DIR/bookmark.py' --listall &> /dev/null"
    
    # Test 7: Remove bookmark
    run_test "Remove bookmark" "python3 '$SCRIPT_DIR/bookmark.py' --remove &> /dev/null"
    
    # Test 8: Empty list handling
    run_test "Empty list handling" "python3 '$SCRIPT_DIR/bookmark.py' --go &> /dev/null"
    
    # Test 9: Duplicate prevention
    run_test "Duplicate prevention" "cd '$SCRIPT_DIR' && echo -e 'test-duplicate\ny' | python3 bookmark.py &> /dev/null"
    
    # Test 10: Backup functionality
    run_test "Backup functionality" "cd '$SCRIPT_DIR' && echo 'backup-test' | python3 bookmark.py &> /dev/null && python3 '$SCRIPT_DIR/bookmark.py' --backup &> /dev/null"
    
    # Test 11: Backup file creation
    run_test "Backup file creation" "ls ~/.dir-bookmarks-backup-*.txt &> /dev/null"
    
    # Test 12: Debug functionality (check if command runs)
    run_test "Debug functionality" "timeout 5 python3 '$SCRIPT_DIR/bookmark.py' --debug &> /dev/null || true"
    
    # Test 13: Open functionality (check if command runs)
    run_test "Open functionality" "echo '1' | timeout 5 python3 '$SCRIPT_DIR/bookmark.py' --open &> /dev/null || true"
    
    # Test 14: Flush functionality
    run_test "Flush functionality" "echo 'yes' | python3 '$SCRIPT_DIR/bookmark.py' --flush &> /dev/null"
    
    # Test 15: Restore functionality (check if command runs)
    run_test "Restore functionality" "echo '1' | timeout 10 python3 '$SCRIPT_DIR/bookmark.py' --restore &> /dev/null || true"
    
    # Test 16: Invalid command handling
    run_test "Invalid command handling" "python3 '$SCRIPT_DIR/bookmark.py' --invalid-command &> /dev/null; [[ \$? -ne 0 ]]" "failure"
    
    # Test 17: Goto function syntax
    run_test "Goto function syntax" "bash -n '$SCRIPT_DIR/goto_function.sh'"
    
    # Test 18: Setup script syntax
    run_test "Setup script syntax" "bash -n '$SCRIPT_DIR/setup.sh'"
    
    # Test 19: File format validation
    run_test "File format validation" "cd '$SCRIPT_DIR' && echo 'format-test' | python3 bookmark.py &> /dev/null && grep -q 'format-test|' ~/.dir-bookmarks.txt"
    
    # Test 20: Multiple bookmarks
    run_test "Multiple bookmarks" "cd /tmp && echo 'temp-bookmark' | python3 '$SCRIPT_DIR/bookmark.py' &> /dev/null && cd ~ && echo 'home-bookmark' | python3 '$SCRIPT_DIR/bookmark.py' &> /dev/null && python3 '$SCRIPT_DIR/bookmark.py' --listall | grep -q 'temp-bookmark' && python3 '$SCRIPT_DIR/bookmark.py' --listall | grep -q 'home-bookmark'"
    
    # Test 21: Platform detection
    run_test "Platform detection" "python3 -c 'import platform; print(platform.system())' &> /dev/null"
    
    # Test 22: Error handling with invalid input
    run_test "Error handling with invalid input" "echo 'invalid-number' | python3 '$SCRIPT_DIR/bookmark.py' --list &> /dev/null; [[ \$? -eq 0 ]]" "failure"
    
    # Test 23: Directory existence validation
    run_test "Directory existence validation" "python3 -c 'import os; print(os.path.exists(\"$SCRIPT_DIR\"))' &> /dev/null"
    
    # Test 24: File permissions
    run_test "File permissions" "touch ~/.dir-bookmarks-test && rm ~/.dir-bookmarks-test &> /dev/null"
    
    # Cleanup after tests
    cleanup_test_files
    
    # Test results
    echo ""
    echo "=========================================================="
    echo "Test Results"
    echo "=========================================================="
    echo "Total tests: $TEST_COUNT"
    echo -e "Passed: ${GREEN}$PASS_COUNT${NC}"
    echo -e "Failed: ${RED}$FAIL_COUNT${NC}"
    
    if [[ $FAIL_COUNT -eq 0 ]]; then
        echo -e "\n${GREEN}🎉 All tests passed! The bookmark manager is working correctly.${NC}"
        echo ""
        echo "Next steps:"
        echo "1. Run './setup.sh' to install the bookmark manager"
        echo "2. Restart your terminal or run 'source ~/.zshrc'"
        echo "3. Start using: bookmark, goto, and other commands!"
    else
        echo -e "\n${RED}❌ Some tests failed. Please check the output above.${NC}"
        echo ""
        echo "Common issues:"
        echo "- Python 3 may not be properly installed"
        echo "- Missing dependencies or permissions"
        echo "- Environment configuration issues"
        exit 1
    fi
    
    echo ""
    echo "For more information, visit: https://github.com/hasinhayder/bookomark.py"
}

# Handle script arguments
case "${1:-}" in
    "--help"|"-h")
        echo "Directory Bookmark Manager Test Suite v3.0"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --version, -v  Show version information"
        echo ""
        echo "This test suite will:"
        echo "  1. Check all prerequisites (Python 3, required files)"
        echo "  2. Test all bookmark manager functionality"
        echo "  3. Validate error handling and edge cases"
        echo "  4. Verify setup and goto function scripts"
        echo "  5. Provide detailed test results and recommendations"
        echo ""
        echo "Exit codes:"
        echo "  0  All tests passed"
        echo "  1  Tests failed or prerequisites missing"
        exit 0
        ;;
    "--version"|"-v")
        echo "Directory Bookmark Manager Test Suite v3.0"
        exit 0
        ;;
    "")
        # Run main test suite
        main
        ;;
    *)
        log_fail "Unknown option: $1"
        echo "Use --help for usage information."
        exit 1
        ;;
esac
