#!/usr/bin/env nix-shell
#!nix-shell -p stow
#!nix-shell -i bash

# Get the directory containing the script
script_dir=$(dirname "$(readlink -f "$0")")
cd $script_dir

# Configure home-manager
if [ -L "$HOME/.config/home-manager/home.nix" ] && [ -e "$HOME/.config/home-manager/home.nix" ]; then
    echo "Symlink already exists for home-manager configuration, skipping creation..."
else
    read -p "Would you like to create a home-manager config symlink? (Y/n) " answer

    # Convert the answer to lowercase for case-insensitive comparison
    case "${answer,,}" in
        y)
        mkdir -p $HOME/.config/home-manager
        stow --target $HOME/.config/home-manager home-manager/

        if [ $? -eq 0 ]; then
            echo "Symlink created for home-manager configuration."
        else
            echo "Failed to create symlink for home-manager configuration."
        exit 1
        fi
        ;;
        *)
        echo "Skipping symlink for home-manager configuration..."
        ;;
    esac
fi

# Configure zed
if [ -L "$HOME/.config/zed/settings.json" ] && [ -e "$HOME/.config/zed/settings.json" ]; then
    echo "Symlink already exists for zed configuration, skipping creation..."
else
    read -p "Would you like to create a zed config symlink? (Y/n) " answer

    # Convert the answer to lowercase for case-insensitive comparison
    case "${answer,,}" in
        y)
        mkdir -p $HOME/.config/zed
        stow --target $HOME/.config/zed zed

        if [ $? -eq 0 ]; then
            echo "Symlink created for zed configuration."
        else
            echo "Failed to create symlink for zed configuration."
        exit 1
        fi
        ;;
        *)
        echo "Skipping symlink for zed configuration..."
        ;;
    esac
fi

# Configure windsurf
if [ -L "$HOME/.config/Windsurf/User/settings.json" ] && [ -e "$HOME/.config/Windsurf/User/settings.json" ]; then
    echo "Symlink already exists for windsurf configuration, skipping creation..."
else
    read -p "Would you like to create a windsurf config symlink? (Y/n) " answer

    # Convert the answer to lowercase for case-insensitive comparison
    case "${answer,,}" in
        y)
        mkdir -p $HOME/.config/Windsurf
        stow --target $HOME/.config/Windsurf windsurf

        if [ $? -eq 0 ]; then
            echo "Symlink created for windsurf configuration."
        else
            echo "Failed to create symlink for windsurf configuration."
        exit 1
        fi
        ;;
        *)
        echo "Skipping symlink for windsurf configuration..."
        ;;
    esac
fi

# Update home-manager derivation
read -p "Would you like to rebuild your system? (Y/n) " answer
case "${answer,,}" in
y)
    home-manager switch
    ;;
*)
    echo "Skipping home-manager rebuild..."
    ;;
esac
