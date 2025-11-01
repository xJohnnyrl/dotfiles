#!/usr/bin/env bash

# Update script for dotfiles - restows all dotfiles without prompts
# Use this after making changes to your dotfiles

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

# Function to restow a directory
restow_dir() {
    local dir=$1
    if [ -d "$dir" ]; then
        info "Restowing $dir..."
        if output=$(stow -t "$HOME" "$dir" 2>&1); then
            echo "$output" | grep -v "BUG in find_stowed_path" || true
            info "Successfully restowed $dir"
        else
            # If there's a conflict, try to unstow first, then restow
            if echo "$output" | grep -q "would cause conflicts"; then
                info "Conflicts detected, unstowing first..."
                stow -t "$HOME" -D "$dir" 2>&1 | grep -v "BUG in find_stowed_path" || true
                info "Now restowing $dir..."
                if stow -t "$HOME" "$dir" 2>&1 | grep -v "BUG in find_stowed_path"; then
                    info "Successfully restowed $dir"
                else
                    error "Failed to restow $dir after unstowing"
                    return 1
                fi
            else
                echo "$output" | grep -v "BUG in find_stowed_path" || true
                error "Failed to restow $dir"
                return 1
            fi
        fi
    else
        warn "Directory $dir does not exist, skipping..."
    fi
}

# Main restow process
info "Updating dotfiles..."

# Always restow shared files
info "Updating shared dotfiles..."
restow_dir "shared"

# Restow OS-specific files
info "Updating $OS-specific dotfiles..."
restow_dir "$OS"

info "Done! Your dotfiles are now up to date."

