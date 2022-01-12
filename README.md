# dotfiles
Mostly used from [i3wm-nord](https://github.com/sarveshspatil111/i3wm-nord), with a few personal tweaks.

Dependencies:
- i3gaps and i3status
- alacritty
- picom
- Nitrogen

## Usage
The directories are configured to simply stow the desired dotfiles:

```
stow i3 -t $HOME
stow i3status -t $HOME
stow alacritty -t $HOME
stow icons -t $HOME
stow themes -t $HOME
stow fonts -t $HOME
```
