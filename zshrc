export ZSH=$HOME/.oh-my-zsh
export UPDATE_ZSH_DAYS=13
export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"

ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
DISABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="false"
DISABLE_UNTRACKED_FILES_DIRTY="false"
ZSH_CUSTOM=$HOME/.nvim-lua/zsh
DEFAULT_USER=`whoami`

plugins=(
    git
    # dotenv
    # python
    tmux
    tmuxinator
    # virtualenv
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
[ -f "$HOME/.zshrc.local" ] && source ~/.zshrc.local

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
