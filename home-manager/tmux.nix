{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "fish";
  };
}
