{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
        fish_add_path -p ~/bin /usr/local/bin

        # Set the default editor to neovim
        set -U EDITOR nvim
        set -U VISUAL nvim

        # Alias for vim
        alias vim="nvim"
    '';

    functions = {
      fvf = "set fname (fzf); and vim $fname";
    };
  };
}
