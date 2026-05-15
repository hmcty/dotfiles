{
  config,
  lib,
  pkgs,
  ...
}:

let
  requireEnv =
    name:
    let
      value = builtins.getEnv name;
    in
    if value == "" then throw "Environment variable ${name} must be set." else value;
in

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./fish.nix
    ./nvim.nix
    ./tmux.nix
  ];

  home.username = requireEnv "USER";
  home.homeDirectory = requireEnv "HOME";

  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    ripgrep
    ast-grep
    fzf
    clang-tools
    universal-ctags
    bat
    perl
    any-nix-shell
    devenv
    pyenv
    direnv
    maim
    nixfmt-tree
  ];

  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "fish";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
