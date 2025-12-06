#!/bin/bash
# Setup script for Directory Bookmark Manager v3.0
# Author: Hasin Hayder
# Repository: https://github.com/hasinhayder/bookomark.py

set -euo pipefail  # Exit on error, undefined vars, and pipe failures

VERSION="3.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHELL_CONFIG=""
INSTALL_TYPE="new"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running in interactive mode
is_interactive() {
    [[ $- == *i* ]]
}

# Detect shell configuration file
detect_shell_config() {
    local shell_name=$(basename "$SHELL")
    
    case "$shell_name" in
        "zsh")
            SHELL_CONFIG="$HOME/.zshrc"
            ;;
        "bash")
            # Check if .bash_profile exists (macOS convention)
            if [[ -f "$HOME/.bash_profile" ]]; then
                SHELL_CONFIG="$HOME/.bash_profile"
            else
                SHELL_CONFIG="$HOME/.bashrc"
            fi
            ;;
        "fish")
            SHELL_CONFIG="$HOME/.config/fish/config.fish"
            log_warning "Fish shell detected. You'll need to manually add the configuration."
            return 1
            ;;
        *)
            log_error "Unsupported shell: $shell_name"
            log_info "Supported shells: bash, zsh"
            log_info "For other shells, please manually add the configuration."
            return 1
            ;;
    esac
    
    return 0
}

# Validate prerequisites
validate_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if Python 3 is available
    if ! command -v python3 &> /dev/null; then
        log_error "Python 3 is required but not installed."
        log_info "Please install Python 3 and try again."
        return 1
    fi
    
    # Check Python version
    local python_version
    python_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    log_info "Found Python $python_version"
    
    if [[ $(python3 -c "import sys; print(1 if sys.version_info < (3, 6) else 0)") -eq 1 ]]; then
        log_error "Python 3.6+ is required. Found: $python_version"
        return 1
    fi
    
    # Check if bookmark.py exists
    if [[ ! -f "$SCRIPT_DIR/bookmark.py" ]]; then
        log_error "bookmark.py not found in $SCRIPT_DIR"
        return 1
    fi
    
    # Check if goto_function.sh exists
    if [[ ! -f "$SCRIPT_DIR/goto_function.sh" ]]; then
        log_error "goto_function.sh not found in $SCRIPT_DIR"
        return 1
    fi
    
    log_success "Prerequisites check passed"
    return 0
}

# Check if already installed
check_existing_installation() {
    if [[ -f "$SHELL_CONFIG" ]] && grep -q "# Directory Bookmark Manager" "$SHELL_CONFIG" 2>/dev/null; then
        INSTALL_TYPE="update"
        log_warning "Directory Bookmark Manager appears to already be installed in $SHELL_CONFIG"
        
        if is_interactive; then
            read -p "Do you want to reinstall/update? (y/N): " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "Installation cancelled."
                exit 0
            fi
            log_info "Updating existing installation..."
        else
            log_info "Non-interactive mode: Updating existing installation..."
        fi
    fi
}

# Create backup of shell config
backup_shell_config() {
    if [[ -f "$SHELL_CONFIG" ]]; then
        local backup_file="${SHELL_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Creating backup: $backup_file"
        cp "$SHELL_CONFIG" "$backup_file"
        log_success "Backup created"
    fi
}

# Remove old bookmark manager configuration
remove_old_config() {
    if [[ -f "$SHELL_CONFIG" ]]; then
        log_info "Removing old bookmark manager configuration..."
        
        # Create a temporary file without the bookmark manager section
        local temp_file=$(mktemp)
        local in_bookmark_section=false
        
        while IFS= read -r line; do
            if [[ "$line" == "# Directory Bookmark Manager" ]]; then
                in_bookmark_section=true
                continue
            fi
            
            if [[ "$in_bookmark_section" == "true" ]] && [[ -z "$line" ]]; then
                # Skip empty lines within the section
                continue
            fi
            
            if [[ "$in_bookmark_section" == "true" ]] && [[ -n "$line" ]] && [[ "${line:0:1}" != "#" ]]; then
                # End of bookmark section, start writing again
                in_bookmark_section=false
            fi
            
            if [[ "$in_bookmark_section" == "false" ]]; then
                echo "$line" >> "$temp_file"
            fi
        done < "$SHELL_CONFIG"
        
        # Replace the original file
        mv "$temp_file" "$SHELL_CONFIG"
        log_success "Old configuration removed"
    fi
}

# Add configuration to shell config
add_configuration() {
    log_info "Adding configuration to $SHELL_CONFIG..."
    
    # Add a comment and the configuration
    {
        echo ""
        echo "# Directory Bookmark Manager v$VERSION"
        echo "# https://github.com/hasinhayder/bookomark.py"
        echo "# Export the script directory so functions can find bookmark.py"
        echo "export BOOKMARK_SCRIPT_DIR=\"${SCRIPT_DIR}\""
        echo "# Prepend the script directory to PATH so 'bookmark' can be called directly"
        echo "export PATH=\"\$BOOKMARK_SCRIPT_DIR:\$PATH\""
        echo "# Source the goto function (uses BOOKMARK_SCRIPT_DIR)"
        echo "source \"\$BOOKMARK_SCRIPT_DIR/goto_function.sh\""
        echo "# End Directory Bookmark Manager"
    } >> "$SHELL_CONFIG"
    
    log_success "Configuration added to $SHELL_CONFIG"
}

# Test the installation
test_installation() {
    log_info "Testing installation..."
    
    # Test if bookmark command works
    if python3 "$SCRIPT_DIR/bookmark.py" --help &> /dev/null; then
        log_success "Bookmark manager is working correctly"
    else
        log_error "Bookmark manager test failed"
        return 1
    fi
    
    # Test if goto function file is readable
    if [[ -r "$SCRIPT_DIR/goto_function.sh" ]]; then
        log_success "Goto function file is accessible"
    else
        log_error "Goto function file is not accessible"
        return 1
    fi
}

# Display completion information
show_completion_info() {
    echo ""
    echo "========================================="
    echo "Directory Bookmark Manager Setup v$VERSION"
    echo "========================================="
    echo ""
    log_success "Setup complete!"
    echo ""
    echo "Configuration added to: $SHELL_CONFIG"
    echo "Script directory: $SCRIPT_DIR"
    echo ""
    echo "To start using the commands, either:"
    echo "1. Restart your terminal, or"
    echo "2. Run: source $SHELL_CONFIG"
    echo ""
    echo "Available commands:"
    echo "  bookmark               - Add current directory as bookmark"
    echo "  bookmark --remove      - Remove current directory bookmark"
    echo "  bookmark --list        - List bookmarks and select one (outputs path)"
    echo "  bookmark --open        - List bookmarks and open selected one in file manager"
    echo "  bookmark --listall     - Display all bookmarks with their full paths"
    echo "  bookmark --debug       - Open bookmarks file in text editor"
    echo "  bookmark --flush       - Clear all bookmarks permanently"
    echo "  bookmark --backup      - Create timestamped backup of bookmarks"
    echo "  bookmark --restore     - Restore bookmarks from backup file"
    echo "  bookmark --help        - Show help information"
    echo "  bookmark --version     - Show version information"
    echo "  goto                   - Navigate to a bookmarked directory (shell function)"
    echo ""
    echo "Cross-platform features:"
    echo "  • macOS: Opens directories in Finder"
    echo "  • Linux: Opens directories with xdg-open"
    echo "  • Windows: Opens directories in File Explorer"
    echo "  • --debug: Tries VS Code, Vim, Nano, or Cat in that order"
    echo ""
    echo "Bookmark file location: ~/.dir-bookmarks.txt"
    echo ""
    echo "For more information, visit:"
    echo "  https://github.com/hasinhayder/bookomark.py"
    echo ""
}

# Main installation function
main() {
    echo "Directory Bookmark Manager Setup v$VERSION"
    echo "========================================="
    echo "Author: Hasin Hayder"
    echo "Repository: https://github.com/hasinhayder/bookomark.py"
    echo ""
    
    # Validate prerequisites
    if ! validate_prerequisites; then
        exit 1
    fi
    
    # Detect shell configuration
    if ! detect_shell_config; then
        exit 1
    fi
    
    log_info "Detected shell: $(basename "$SHELL")"
    log_info "Shell config file: $SHELL_CONFIG"
    echo ""

    # Detect if the setup script is being sourced into the current shell
    # If it is, we can export BOOKMARK_SCRIPT_DIR and PATH into the
    # current session so the user can use commands immediately.
    local _setup_sourced=false
    if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
        _setup_sourced=true
    fi
    
    # Check for existing installation
    check_existing_installation
    
    # Confirm installation
    if is_interactive; then
        echo ""
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Setup cancelled."
            exit 0
        fi
    else
        log_info "Non-interactive mode: Proceeding with installation..."
    fi
    
    # Create backup
    backup_shell_config
    
    # Remove old config if updating
    if [[ "$INSTALL_TYPE" == "update" ]]; then
        remove_old_config
    fi
    
    # Add new configuration
    add_configuration

    # If setup was sourced, export into the current shell and source goto
    if [[ "$_setup_sourced" == "true" ]]; then
        export BOOKMARK_SCRIPT_DIR="$SCRIPT_DIR"
        export PATH="$BOOKMARK_SCRIPT_DIR:$PATH"
        # Source the goto file into current shell so function is immediately available
        if [[ -r "$BOOKMARK_SCRIPT_DIR/goto_function.sh" ]]; then
            # shellcheck disable=SC1090
            source "$BOOKMARK_SCRIPT_DIR/goto_function.sh"
        fi
        log_success "BOOKMARK_SCRIPT_DIR exported into current session."
    else
        # If not sourced, give the user a one-line command they can copy to enable immediately
        echo "To enable the bookmark commands in your current session without restarting, run:" >&2
        echo "  source \"$SHELL_CONFIG\"" >&2
        echo "Or run:" >&2
        echo "  export BOOKMARK_SCRIPT_DIR=\"$SCRIPT_DIR\" && export PATH=\"\$BOOKMARK_SCRIPT_DIR:\$PATH\" && source \"$SCRIPT_DIR/goto_function.sh\"" >&2
    fi
    
    # Test installation
    if ! test_installation; then
        log_error "Installation test failed. Please check the configuration."
        exit 1
    fi
    
    # Show completion info
    show_completion_info
}

# Handle script arguments
case "${1:-}" in
    "--help"|"-h")
        echo "Directory Bookmark Manager Setup v$VERSION"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --version, -v  Show version information"
        echo ""
        echo "This script will:"
        echo "  1. Check prerequisites (Python 3.6+, required files)"
        echo "  2. Detect your shell configuration file"
        echo "  3. Create a backup of your shell config"
        echo "  4. Add the bookmark manager configuration"
        echo "  5. Test the installation"
        echo ""
        exit 0
        ;;
    "--version"|"-v")
        echo "Directory Bookmark Manager Setup v$VERSION"
        exit 0
        ;;
    "")
        # Run main installation
        main
        ;;
    *)
        log_error "Unknown option: $1"
        echo "Use --help for usage information."
        exit 1
        ;;
esac
