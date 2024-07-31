{ config, lib, pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./nvim.nix
    ./tmux.nix
  ];
  nixpkgs = {
    config.allowUnfree = true;
  };

  home.username = "hmcty";
  home.homeDirectory = "/home/hmcty";

  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    git
    silver-searcher
    ripgrep
    ranger
    fzf
  ];

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "fish";
  };

  programs.git = {
    enable = true;
    userName = "Harry McCarty";
    userEmail = "hmccarty@pm.me";
  };

  programs.alacritty = {
    enable = true;
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
