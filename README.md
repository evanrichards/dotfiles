Setup should be easy:
``````
$ brew install chezmoi
$ chezmoi init https://github.com/evanrichards/dotfiles.git
``````

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


