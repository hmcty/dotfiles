# dotfiles

Install nix and home-manager, then run:

```sh
nix-shell -p stow
./setup.sh
```

## Using System OpenGL Drivers

https://github.com/nix-community/nixGL

```sh
nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update
nix-env -iA nixgl.auto.nixGLDefault   # or replace `nixGLDefault` with your desired wrapper
```

## Ignoring Certain Configs

For a given machine, you can avoid stowing config files:
```sh
touch windsurf/.stowignore
```

