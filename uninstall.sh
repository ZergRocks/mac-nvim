#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

echo "======================================"
echo "  Mac Neovim Configuration Uninstaller"
echo "======================================"
echo ""

print_info "This will remove all mac-nvim symlinks and optionally restore backups"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Uninstall cancelled"
    exit 0
fi

# Remove symlinks
print_info "Removing symlinks..."

if [ -L "$HOME/mac-nvim" ]; then
    rm "$HOME/mac-nvim"
    print_status "Removed ~/mac-nvim symlink"
else
    print_info "~/mac-nvim symlink not found"
fi

if [ -L "$HOME/.config/nvim/init.lua" ]; then
    rm "$HOME/.config/nvim/init.lua"
    print_status "Removed ~/.config/nvim/init.lua symlink"
else
    print_info "~/.config/nvim/init.lua symlink not found"
fi

if [ -L "$HOME/.config/nvim/lua" ]; then
    rm "$HOME/.config/nvim/lua"
    print_status "Removed ~/.config/nvim/lua symlink"
else
    print_info "~/.config/nvim/lua symlink not found"
fi

if [ -L "$HOME/.zshrc" ]; then
    rm "$HOME/.zshrc"
    print_status "Removed ~/.zshrc symlink"
else
    print_info "~/.zshrc symlink not found"
fi

if [ -L "$HOME/.tmux.conf" ]; then
    rm "$HOME/.tmux.conf"
    print_status "Removed ~/.tmux.conf symlink"
else
    print_info "~/.tmux.conf symlink not found"
fi

# Check for backups
print_info "Checking for backup files..."
FOUND_BACKUPS=false

for backup in "$HOME"/*.backup "$HOME/.config/nvim"/*.backup; do
    if [ -e "$backup" ]; then
        FOUND_BACKUPS=true
        break
    fi
done

if [ "$FOUND_BACKUPS" = true ]; then
    print_warning "Found backup files. Would you like to restore them?"
    
    # Process home directory backups
    for backup in "$HOME"/*.backup; do
        if [ -e "$backup" ]; then
            original="${backup%.backup}"
            filename=$(basename "$original")
            echo ""
            print_info "Found backup: $filename.backup"
            read -p "Restore to $filename? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mv "$backup" "$original"
                print_status "Restored $filename"
            else
                print_info "Skipped $filename.backup"
            fi
        fi
    done
    
    # Process nvim config backups
    for backup in "$HOME/.config/nvim"/*.backup; do
        if [ -e "$backup" ]; then
            original="${backup%.backup}"
            filename=$(basename "$original")
            echo ""
            print_info "Found nvim backup: $filename.backup"
            read -p "Restore to ~/.config/nvim/$filename? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mv "$backup" "$original"
                print_status "Restored ~/.config/nvim/$filename"
            else
                print_info "Skipped $filename.backup"
            fi
        fi
    done
else
    print_info "No backup files found"
fi

# Optional: Remove the Development/mac-nvim-config directory
echo ""
if [ -d "$HOME/Development/mac-nvim-config" ]; then
    print_warning "Found installation directory: ~/Development/mac-nvim-config"
    read -p "Remove the installation directory? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$HOME/Development/mac-nvim-config"
        print_status "Removed ~/Development/mac-nvim-config"
    else
        print_info "Kept ~/Development/mac-nvim-config"
    fi
fi

echo ""
echo "======================================"
echo "        Uninstall Complete!           "
echo "======================================"
echo ""
print_info "Mac Neovim configuration has been uninstalled"
print_info "To reinstall, clone the repository to ~/Development/mac-nvim-config and run install.sh"