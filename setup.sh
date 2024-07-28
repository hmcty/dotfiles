#!/usr/bin/env bash

# Get the directory containing the script
script_dir=$(dirname "$(readlink -f "$0")")
cd $script_dir

echo "Non-NixOS system detected, configuring for home-manager..."

# Configure home-manager
if [ -L "$HOME/.config/nixpkgs/home.nix" ] && [ -e "$HOME/.config/nixpkgs/home.nix" ]; then
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
