{ config, lib, pkgs, ... }:
{
  imports = [
    ./nvim.nix
    ./tmux.nix
  ];

  home.username = "hmcty";
  home.homeDirectory = "/home/hmcty";

  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    git
    silver-searcher
    ripgrep
    ranger
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

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
        fish_add_path -p ~/bin /usr/local/bin
    '';

    plugins = [
      {
        name = "nix-env.fish";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }
    ];
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
