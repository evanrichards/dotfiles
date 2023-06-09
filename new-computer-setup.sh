# this should trigger command line tools to be installed
git

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install chezmoi
touch ~/.secrets_rc
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply evanrichards
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install latest vim
brew install nvim exa bat rg asdf fzf tmux gpg zsh-syntax-highlighting

# my kitty config expects a running tmux session
tmux

# if on mac 
brew install kitty
# switch to kitty from here

# install tmux plugins: prefix + I

# If on mac
brew tap homebrew/cask-fonts
brew tap huytd/cask-fonts
brew install --cask font-fira-code

# if on linux
sudo apt-get install zsh
asdf plugin-add nodejs yarn
asdf install nodejs latest
asdf install yarn latest
asdf global yarn latest
asdf global nodejs latest
