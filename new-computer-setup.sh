# this should trigger command line tools to be installed
git

# install brew if on mac
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install chezmoi
touch ~/.secrets_rc
chezmoi init --apply evanrichards

