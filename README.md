# dotfiles

On Debian or Ubuntu, install external dependencies first:

```sh
./bootstrap.sh
```

Then stow configs and switch Home Manager:

```sh
./reload.sh
```

To only stow configs without running `home-manager switch`:

```sh
./reload.sh --skip-switch
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
touch i3/.stowignore
```
