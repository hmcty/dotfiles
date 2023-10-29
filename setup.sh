#!/usr/bin/env bash

# Get the directory containing the script
script_dir=$(dirname "$(readlink -f "$0")")
cd $script_dir

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

# Configure nvim
echo "Stowing nvim dotfiles in $HOME..."
stow nvim --target $HOME

