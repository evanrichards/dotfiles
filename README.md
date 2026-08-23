# Dotfiles

The terminal configuration is shared by macOS and Linux/WSL through
[chezmoi](https://www.chezmoi.io/). Platform-specific behavior uses
chezmoi's built-in `.chezmoi.os` template value. Native Windows also gets an
AutoHotkey setup that makes its keyboard behave like macOS.

## Install

Install chezmoi, then initialize and apply this repository:

```sh
chezmoi init --apply https://github.com/evanrichards/dotfiles.git
```

Preview future changes before applying them:

```sh
chezmoi diff
chezmoi apply --dry-run --verbose
```

## Platform layout

- `dot_zshrc.tmpl` is shared, with small macOS and Linux branches.
- `Brewfile.tmpl` shares CLI packages while keeping taps and casks macOS-only.
- `dot_profile.tmpl` removes stale Homebrew paths and is installed only on Linux.
- `.chezmoiignore` keeps Kitty and the macOS Brew bundle lock off Linux/WSL.
- Windows installs AutoHotkey v2, swaps Caps Lock and Left Control, provides
  macOS-style Alt shortcuts and Emacs editing keys, and starts the mapping at
  sign-in.
- Neovim, tmux, Vim, the prompt, aliases, and tool versions remain shared.

When adding platform-specific settings, prefer a small template branch:

```text
{{ if eq .chezmoi.os "darwin" }}
# macOS only
{{ else if eq .chezmoi.os "linux" }}
# Linux/WSL only
{{ end }}
```
