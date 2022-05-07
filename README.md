# dotfiles

Dependencies:

- stow
- xorg
- picom
- hsetroot
- i3gaps
- polybar
- tbsm
- tulizu
- pulseaudio
- alacritty

## Usage

The directories are configured to simply stow the desired dotfiles:

```
stow i3 -t $HOME
stow alacritty -t $HOME
stow theme -t $HOME
stow conky -t $HOME
stow vim -t $HOME
```

Arch issue can be configured:

```
tulizu m /usr/share/tulizu/tizu/arch-big-logo.tizu
tulizu i
```
