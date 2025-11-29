{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
        fish_add_path -p ~/.local/bin ~/.nix-profile/bin /usr/local/bin /nix/var/nix/profiles/default/bin/

        # Set the default editor to neovim
        set -U EDITOR nvim
        set -U VISUAL nvim

        # Alias for vim
        alias vim="nvim"

        # Load pyenv automatically
        pyenv init - fish | source
        fish_add_path $PYENV_ROOT/shims $PYENV_ROOT/bin
    '';

    functions = {
      fvf = "set fname (fzf); and vim $fname";
      daily = "nvim ~/notes/daily/$(date +'%Y-%m-%d').md";
      todo = "nvim ~/notes/todo.md";
      ctags = "${pkgs.ctags}/bin/ctags $argv";
      udev-reload = "sudo udevadm control --reload-rules && sudo udevadm trigger";
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
