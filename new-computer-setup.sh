# this should trigger command line tools to be installed
git

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
tmux
# install latest vim
brew install nvim exa bat rg

# if on mac 
brew install kitty

# Some font stuff that is needed for alacrity configs
brew tap homebrew/cask-fonts
brew tap huytd/cask-fonts
brew install --cask font-fira-code

# if on linux
sudo apt-get install zsh

# set tmux to be 1-based windows
brew install tmux
touch .tmux.conf


# nvm install
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

brew install zsh-syntax-highlighting

#dracula colors for alacritty, tmux, vim, zsh-syntax-highlighting https://draculatheme.com
alias vim="nvim"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
