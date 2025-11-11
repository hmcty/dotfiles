#!/usr/bin/env nix-shell
#!nix-shell -p stow
#!nix-shell -i bash

# Get the directory containing the script
script_dir=$(dirname "$(readlink -f "$0")")
cd $script_dir

check_and_stow() {
    local module="$1"
    local target_dir="$2"

    # If `.stowignore` exists, skip directory
    if [ -f "$module/.stowignore" ]; then
        echo "Skipping $module due to .stowignore"
        return
    fi
   
    # Check if stow would create new symlinks
    mkdir -p "$target_dir"
    local stow_output=$(stow --simulate --verbose -t "$target_dir" "$module" 2>&1)
    
    if echo "$stow_output" | grep -q "LINK"; then
        read -p "Would you like to create $module config symlinks? (Y/n) " answer

        case "${answer,,}" in
            y)
            mkdir -p "$target_dir"
            stow --target "$target_dir" "$module"

            if [ $? -eq 0 ]; then
                echo "Symlinks created for $module configuration."
            else
                echo "Failed to create symlinks for $module configuration."
                exit 1
            fi
            ;;
            *)
            echo "Skipping symlinks for $module configuration..."
            ;;
        esac
    else
        echo "Configuration for $module is already stowed, skipping..."
    fi
}

check_and_stow "home-manager" "$HOME/.config/home-manager"
check_and_stow "zed" "$HOME/.config/zed"
check_and_stow "windsurf" "$HOME/.config/Windsurf"
check_and_stow "polybar" "$HOME/.config/polybar"
check_and_stow "i3" "$HOME/.config/i3"
check_and_stow "alacritty" "$HOME/.config/alacritty"

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
