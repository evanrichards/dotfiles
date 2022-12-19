# this should trigger command line tools to be installed
git

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
tmux
# install latest vim
brew install nvim exa bat rg kitty
# vim plug: https://github.com/junegunn/vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p .vim/colors
cd .vim/colors
curl https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim > solarized.vim

# get .vimrc
touch .vimrc

# Some font stuff that is needed for alacrity configs
brew tap homebrew/cask-fonts
brew tap huytd/cask-fonts
brew install --cask font-iosevka
brew install --cask font-haskplex-nerd
brew install --cask font-fira-code

# Setup alacrity configs
touch .alacritty.yml

# install ohmyzsh
# plugins and stuff: https://ohmyz.sh/#install
# Setup zsh configs (ohmyzshtoo)
vim .zshrc

# set tmux to be 1-based windows

brew install tmux
touch .tmux.conf


# nvm install
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh
| bash

brew install zsh-syntax-highlighting

#dracula colors for alacritty, tmux, vim, zsh-syntax-highlighting https://draculatheme.com
alias vim="nvim"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh