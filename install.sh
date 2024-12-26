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

# Link files
rm -rf $HOME/nvim-lua
ln -sf $(pwd) $HOME/nvim-lua
ln -sf $HOME/nvim-lua/init.lua $HOME/.config/nvim/init.lua
ln -sf $HOME/nvim-lua/lua $HOME/.config/nvim/
ln -sf $HOME/nvim-lua/zshrc $HOME/.zshrc
ln -sf $HOME/nvim-lua/tmux.conf $HOME/.tmux.conf

# Install tpm
rm -rf $HOME/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
