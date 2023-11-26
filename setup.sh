#!/usr/bin/env bash

# Get the directory containing the script
script_dir=$(dirname "$(readlink -f "$0")")
cd $script_dir

if [ -d "/etc/nixos" ]; then
    echo "NixOS system detected, configuring for NixOS..."

    # Configure NixOS
    if [ -L "/etc/nixos/configuration.nix" ] && [ -e "/etc/nixos/configuration.nix" ]; then
        echo "Symlink already exists for NixOS configuration, skipping creation..."
    else
        read -p "Would you like to create a NixOS config symlink? (Y/n) " answer

        # Convert the answer to lowercase for case-insensitive comparison
        case "${answer,,}" in
            y)
            sudo ln -s configuration.nix /etc/nixos/configuration.nix

            if [ $? -eq 0 ]; then
                    echo "Symlink created for NixOS configuration."
            else
                echo "Failed to create symlink for NixOS configuration."
            exit 1
            fi
            ;;
            *)
            echo "Skipping symlink for NixOS configuration..."
            ;;
        esac
    fi

    # Update NixOS derivation
    read -p "Would you like to rebuild your system? (Y/n) " answer
    case "${answer,,}" in
    y)
        sudo nixos-rebuild switch
        ;;
    *)
        echo "Skipping NixOS rebuild..."
        ;;
    esac
else 
    echo "Non-NixOS system detected, configuring for home-manager..."

    # Configure home-manager
    if [ -L "$HOME/.config/nixpkgs/home.nix" ] && [ -e "$HOME/.config/nixpkgs/home.nix" ]; then
        echo "Symlink already exists for home-manager configuration, skipping creation..."
    else
        read -p "Would you like to create a home-manager config symlink? (Y/n) " answer

        # Convert the answer to lowercase for case-insensitive comparison
        case "${answer,,}" in
            y)
            mkdir -p $HOME/.config/
            stow --target $HOME/.config home-manager/

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
fi

