#!/usr/bin/env bash

# Bootstrap script for setting up dotfiles using stow
# Detects the OS and sets up the appropriate dotfiles

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
info() {
    echo -e "${GREEN}ℹ${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    error "stow is not installed. Please install it first."
    echo "  On macOS: brew install stow"
    echo "  On Linux: sudo apt install stow (Debian/Ubuntu)"
    echo "            sudo pacman -S stow (Arch)"
    exit 1
fi

info "stow is installed ✓"

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Determine OS
OS=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    error "Unsupported OS: $OSTYPE"
    exit 1
fi

info "Detected OS: $OS"

# Change to the dotfiles directory
cd "$SCRIPT_DIR"

# Function to stow a directory
stow_dir() {
    local dir=$1
    if [ -d "$dir" ]; then
        info "Stowing $dir..."
        # Run stow and filter out the known BUG warning
        if output=$(stow -t "$HOME" "$dir" 2>&1); then
            # Only show output if there's something meaningful (not just the BUG warning)
            echo "$output" | grep -v "BUG in find_stowed_path" || true
            info "Successfully stowed $dir"
        else
            # Check if it's a conflict warning
            if echo "$output" | grep -q "would cause conflicts"; then
                echo
                warn "Stowing $dir would cause conflicts with existing files."
                echo
                echo "Options:"
                echo "  1) Backup existing files and adopt dotfiles (recommended)"
                echo "  2) Skip stowing $dir"
                echo "  3) Overwrite local files with dotfiles"
                echo "  4) Manually resolve conflicts later"
                echo
                read -p "Choose option [1-4] (default: 1): " -n 1 choice
                echo
                
                case ${choice:-1} in
                    1)
                        info "Backing up existing files and adopting dotfiles..."
                        stow -t "$HOME" --adopt "$dir" 2>&1 | grep -v "BUG in find_stowed_path" || true
                        info "Successfully stowed $dir (check git status in dotfiles repo)"
                        ;;
                    2)
                        warn "Skipping $dir"
                        ;;
                    3)
                        info "Overwriting local files with dotfiles..."
                        # Remove conflicting files and then stow
                        cd "$dir"
                        find . -type f | while read -r file; do
                            # Remove leading ./
                            target_file="${file#./}"
                            full_target="$HOME/$target_file"
                            if [ -f "$full_target" ] && [ ! -L "$full_target" ]; then
                                warn "Removing $full_target to overwrite with dotfiles version"
                                rm "$full_target"
                            fi
                        done
                        cd "$SCRIPT_DIR"
                        stow -t "$HOME" "$dir" 2>&1 | grep -v "BUG in find_stowed_path" || true
                        info "Successfully stowed $dir (local files were overwritten)"
                        ;;
                    4)
                        warn "Please manually resolve conflicts and run stow again"
                        return 1
                        ;;
                    *)
                        error "Invalid choice"
                        return 1
                        ;;
                esac
            else
                echo "$output" | grep -v "BUG in find_stowed_path" || true
                error "Failed to stow $dir"
                return 1
            fi
        fi
    else
        warn "Directory $dir does not exist, skipping..."
    fi
}

# Main stow process
info "Starting dotfiles setup..."

# Always stow shared files
info "Setting up shared dotfiles..."
stow_dir "shared"

# Stow OS-specific files
info "Setting up $OS-specific dotfiles..."
stow_dir "$OS"

info "Done! Your dotfiles are now set up."
info "You may need to restart your terminal or run 'source ~/.bashrc' (Linux)"

