{ config, lib, pkgs, ... }:
with import <nixpkgs> {};

{
  nixpkgs.config.allowUnfree = true; 

  imports = [
    ./fish.nix
    ./nvim.nix
    ./tmux.nix
  ];

  home.username = "hmcty";
  home.homeDirectory = if pkgs.stdenv.isLinux
    then "/home/hmcty"   # Linux
    else "/Users/hmcty"; # macOS

  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    ripgrep
    fzf
    clang-tools 
  ];

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "fish";
  };

  programs.alacritty = {
    enable = if pkgs.stdenv.isLinux then true else false;
    package = pkgs.alacritty;
    settings = {
      font.size = 13;

      shell = {
        args = ["-l"];
        program = "${pkgs.fish}/bin/fish";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
