export EDITOR='nvim'
export TERM='screen-256color'
# Compilation flags
export ARCHFLAGS="-arch arm64"
# let asdf choose our versions
. /usr/local/opt/asdf/libexec/asdf.sh
# Opt arrow keys should move words
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
if [ ! -d "$HOME/zsh-syntax-highlighting" ]; then
        brew install zsh-syntax-highlighting
fi
source /Users/evanrichards/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Theme work
# if directory .dracula does not exist, create it
if [ ! -d "$HOME/.dracula" ]; then
        mkdir "$HOME/.dracula"
fi
if [ ! -d "$HOME/.dracula/theme" ]; then
    git clone https://github.com/dracula/zsh.git ~/.dracula/theme
fi
source "$HOME/.dracula/theme/dracula.zsh-theme"
if [ ! -d "$HOME/.dracula/zsh-syntax-highlighting" ]; then
    git clone https://github.com/dracula/zsh-syntax-highlighting.git ~/.dracula/zsh-syntax-highlighting
fi
source "$HOME/.dracula/zsh-syntax-highlighting/zsh-syntax-highlighting.sh"
ZSH_HIGHLIGHT_STYLES[cursor]='bold'

# node stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# my aliases
alias vim="nvim"
alias tree="exa --tree"
alias ls="exa"
alias ll="exa -alh"
alias cat="bat"
alias dotfiles="cd $HOME/code/dotfiles"
source "$HOME/code/dotfiles/gitrc.sh"
