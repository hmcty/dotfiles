#!/usr/bin/env nix-shell
#!nix-shell -p stow
#!nix-shell -i bash

skip_switch=0

while [ $# -gt 0 ]; do
    case "$1" in
        --skip-switch)
            skip_switch=1
            ;;
        -h|--help)
            echo "Usage: ./reload.sh [--skip-switch]"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Usage: ./reload.sh [--skip-switch]" >&2
            exit 1
            ;;
    esac

    shift
done

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
check_and_stow "polybar" "$HOME/.config/polybar"
check_and_stow "i3" "$HOME/.config/i3"
check_and_stow "alacritty" "$HOME/.config/alacritty"
check_and_stow "fish-functions" "$HOME/.config/fish/functions"
check_and_stow "claude" "$HOME/.claude"
check_and_stow "codex" "$HOME/.codex"

if [ "$skip_switch" -eq 1 ]; then
    echo "Skipping home-manager switch..."
else
    home-manager switch
fi
