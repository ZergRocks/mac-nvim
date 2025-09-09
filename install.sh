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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to backup existing file/directory
backup_if_exists() {
    if [ -e "$1" ] || [ -L "$1" ]; then
        print_warning "Backing up existing $1 to $1.backup"
        mv "$1" "$1.backup"
    fi
}

echo "======================================"
echo "  Mac Neovim Development Environment  "
echo "         Installation Script          "
echo "======================================"
echo ""

# 1. Check and install Homebrew
print_info "Checking Homebrew installation..."
if ! command_exists brew; then
    print_warning "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_status "Homebrew is already installed"
fi

# 2. Install required packages
print_info "Installing required packages..."

# Regular brew packages
BREW_PACKAGES=(
    "git"
    "the_silver_searcher"
    "tmux"
    "zsh"
    "fzf"
    "universal-ctags"
    "wget"
    "httpie"
    "lsd"
    "neovim"
    "bat"
    "stylua"
    "shfmt"
    "node"
)

# Cask packages
CASK_PACKAGES=(
    "miniconda"
)

for package in "${BREW_PACKAGES[@]}"; do
    if brew list "$package" &>/dev/null; then
        print_status "$package is already installed"
    else
        print_info "Installing $package..."
        if brew install "$package"; then
            print_status "$package installed successfully"
        else
            print_error "Failed to install $package"
        fi
    fi
done

for package in "${CASK_PACKAGES[@]}"; do
    if brew list --cask "$package" &>/dev/null; then
        print_status "$package is already installed"
    else
        print_info "Installing $package..."
        if brew install --cask "$package"; then
            print_status "$package installed successfully"
        else
            print_error "Failed to install $package"
        fi
    fi
done

# 3. Setup Python environment with miniconda
print_info "Setting up Python environment..."
if command -v conda &>/dev/null; then
    print_status "Conda is already installed"
    # Install essential Python packages for development
    print_info "Installing Python development packages..."
    conda install -y -c conda-forge python numpy pandas jupyter ipython 2>/dev/null || true
    pip install --upgrade pip neovim pynvim sqlfmt ruff 2>/dev/null || true
    print_status "Python packages configured"
else
    print_warning "Conda not found. Install miniconda first for Python development"
fi

# Install Node.js formatters
print_info "Installing Node.js formatters..."
if command_exists npm; then
    print_info "Installing prettier..."
    if npm install -g prettier; then
        print_status "Prettier installed globally"
    else
        print_error "Failed to install prettier"
    fi
else
    print_warning "npm not available. Install Node.js first for prettier support"
fi

# 4. Install Oh My Zsh
print_info "Checking Oh My Zsh installation..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_warning "Oh My Zsh not found. Installing..."
    sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
    print_status "Oh My Zsh installed"
else
    print_status "Oh My Zsh is already installed"
fi

# 5. Install Zsh plugins
print_info "Installing Zsh plugins..."

# Zsh syntax highlighting
if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting"
    print_status "zsh-syntax-highlighting installed"
else
    print_status "zsh-syntax-highlighting already exists"
fi

# Zsh autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
    print_status "zsh-autosuggestions installed"
else
    print_status "zsh-autosuggestions already exists"
fi

# 6. Create necessary directories
print_info "Creating necessary directories..."

# Vim temp directories
mkdir -p "$HOME/.tmp/vim/backup"
mkdir -p "$HOME/.tmp/vim/swap"
mkdir -p "$HOME/.tmp/vim/undo"
print_status "Vim temp directories created"

# Neovim config directory
mkdir -p "$HOME/.config/nvim"
print_status "Neovim config directory created"

# 7. Setup symlinks
print_info "Setting up configuration symlinks..."

# 반드시 특정 경로에서만 실행되도록 강제
REQUIRED_DIR="$HOME/Development/mac-nvim-config"
CURRENT_DIR=$(pwd)

# 경로 검증
if [ "$CURRENT_DIR" != "$REQUIRED_DIR" ]; then
    print_error "ERROR: This script MUST be run from $REQUIRED_DIR"
    print_info "Current location: $CURRENT_DIR"
    
    # 자동으로 올바른 위치로 이동 제안
    if [ ! -d "$HOME/Development" ]; then
        print_info "Creating ~/Development directory..."
        mkdir -p "$HOME/Development"
    fi
    
    if [ ! -d "$REQUIRED_DIR" ]; then
        print_info "To fix this, run:"
        echo "    mv '$CURRENT_DIR' '$REQUIRED_DIR'"
        echo "    cd '$REQUIRED_DIR'"
        echo "    ./install.sh"
    else
        print_error "$REQUIRED_DIR already exists!"
        print_info "Please resolve the conflict manually"
    fi
    exit 1
fi

# 이제 안전하게 ~/mac-nvim 심볼릭 링크 생성
backup_if_exists "$HOME/mac-nvim"
ln -sf "$REQUIRED_DIR" "$HOME/mac-nvim"
print_status "Project linked as: $HOME/mac-nvim → $REQUIRED_DIR"

# Neovim configuration
backup_if_exists "$HOME/.config/nvim/init.lua"
ln -sf "$CURRENT_DIR/init.lua" "$HOME/.config/nvim/init.lua"
print_status "Neovim init.lua linked"

backup_if_exists "$HOME/.config/nvim/lua"
ln -sf "$CURRENT_DIR/lua" "$HOME/.config/nvim/lua"
print_status "Neovim lua directory linked"

# Zsh configuration
backup_if_exists "$HOME/.zshrc"
ln -sf "$CURRENT_DIR/zshrc" "$HOME/.zshrc"
print_status "Zsh configuration linked"

# Tmux configuration
backup_if_exists "$HOME/.tmux.conf"
ln -sf "$CURRENT_DIR/tmux.conf" "$HOME/.tmux.conf"
print_status "Tmux configuration linked"

# Setup .zshrc.local for sensitive data
print_info "Setting up .zshrc.local for sensitive configuration..."
if [ ! -f "$HOME/.zshrc.local" ]; then
    if [ -f "$CURRENT_DIR/.zshrc.local.example" ]; then
        cp "$CURRENT_DIR/.zshrc.local.example" "$HOME/.zshrc.local"
        print_status ".zshrc.local created from template"
        print_warning "Please edit ~/.zshrc.local and add your API keys and tokens"
    else
        touch "$HOME/.zshrc.local"
        print_status "Empty .zshrc.local created"
        print_info "Add your sensitive environment variables to ~/.zshrc.local"
    fi
else
    print_status ".zshrc.local already exists"
fi

# 7. Install TPM (Tmux Plugin Manager)
print_info "Installing Tmux Plugin Manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    print_status "TPM installed"
else
    print_status "TPM already installed"
fi

# 8. Final instructions
echo ""
echo "======================================"
echo "        Installation Complete!        "
echo "======================================"
echo ""
print_info "Next steps:"
echo "  1. Open a new terminal or run: source ~/.zshrc"
echo "  2. Start Neovim: nvim"
echo "  3. Wait for plugins to install automatically"
echo "  4. In Tmux, press prefix + I to install plugins"
echo ""
print_warning "Backup files (if any) saved with .backup extension"
print_info "To restore backups, rename them removing .backup"
echo ""
print_status "Happy coding! 🚀"