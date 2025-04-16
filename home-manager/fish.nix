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

        # Always use fish for `nix-shell`
        any-nix-shell fish --info-right | source
    '';

    functions = {
      fvf = "set fname (fzf); and vim $fname";
      daily = "nvim ~/notes/daily/$(date +'%Y-%m-%d').md";
      todo = "nvim ~/notes/todo.md";
      ctags = "${pkgs.ctags}/bin/ctags $argv";
      udev-reload = "sudo udevadm control --reload-rules && sudo udevadm trigger";
    };
  };
}
