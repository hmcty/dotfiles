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
      udev-reload = "sudo udevadm control --reload-rules && sudo udevadm trigger
      ss = "set file $(mktemp --suffix .jpg) && import $file && echo $file";
      notes = "nvim ~/notes/";
    };
    shellAbbrs = {
      g = "git";
      ga = "git add";
      gwt = "git worktree";
      v = "nvim";
      c = "clear";
      l = "ls";
      ll = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lh = "ls -lh";
      ".." = "cd ..";
      bqf = "bazel cquery --output=files";
      br = "bazel run";
      bb = "bazel build";
    };
  };
}
