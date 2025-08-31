#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install other packages
brew install --force git the_silver_searcher tmux zsh fzf universal-ctags wget httpie \
    lsd neovim bat miniconda

# zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
rm -rf $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
rm -rf $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/plugins/zsh-autosuggestions


# nvim related
rm -rf $HOME/.tmp
mkdir -p $HOME/.tmp
mkdir -p $HOME/.tmp/vim
mkdir -p $HOME/.tmp/vim/backup
mkdir -p $HOME/.tmp/vim/swap
mkdir -p $HOME/.tmp/vim/undo

rm -rf $HOME/.config.nvim
mkdir -p $HOME/.config
mkdir -p $HOME/.config/nvim

# Remove old nvim-lua directory with proper permissions handling
if [ -d "$HOME/nvim-lua" ]; then
    # Check if we can remove it normally
    if ! rm -rf $HOME/nvim-lua 2>/dev/null; then
        echo "Removing old nvim-lua directory with elevated permissions..."
        sudo rm -rf $HOME/nvim-lua
    fi
fi

# Use current directory name instead of hardcoded nvim-lua
CURRENT_DIR=$(pwd)
PROJECT_NAME=$(basename "$CURRENT_DIR")

# Create symlink with current project directory
ln -sf "$CURRENT_DIR" "$HOME/$PROJECT_NAME"

# Update config symlinks to use actual project name
ln -sf "$HOME/$PROJECT_NAME/init.lua" $HOME/.config/nvim/init.lua
ln -sf "$HOME/$PROJECT_NAME/lua" $HOME/.config/nvim/
ln -sf "$HOME/$PROJECT_NAME/zshrc" $HOME/.zshrc
ln -sf "$HOME/$PROJECT_NAME/tmux.conf" $HOME/.tmux.conf

# Install tpm
rm -rf $HOME/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

echo "Installation completed successfully!"
echo "Project linked as: $HOME/$PROJECT_NAME"
echo "Config files linked to: $HOME/.config/nvim/"