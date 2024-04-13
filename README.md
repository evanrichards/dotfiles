Setup should be easy:

Make the secret file

```sh
$ touch ~/.secrets_rc
```

This should trigger command line tools to be installed

```sh
$ git
```

Install Homebrew if on MacOS

```sh
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
$ echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
$ eval "$(/opt/homebrew/bin/brew shellenv)"
```

Install chezmoi

```sh
$ brew install chezmoi
$ chezmoi init --apply evanrichards
```

#QMK setup

## Install QMK

[Official Docs](https://docs.qmk.fm/#/newbs_getting_started)

```sh
brew install qmk/qmk/qmk
# I needed to install the following manually for some reason
# above @8 it complains
brew tap osx-cross/avr
brew install avr-gcc@8
qmk setup evanrichards/qmk_firmware
```
