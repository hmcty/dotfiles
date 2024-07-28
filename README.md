# dotfiles

Install nix and home-manager.

```
nix-shell -p stow
./setup.sh
```

## Using System OpenGL Drivers

https://github.com/nix-community/nixGL

```
nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update
nix-env -iA nixgl.auto.nixGLDefault   # or replace `nixGLDefault` with your desired wrapper
```

