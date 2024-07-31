{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
        fish_add_path -p ~/bin /usr/local/bin
    '';

    functions = {
      fvf = "set fname (fzf); and vim $fname";
    };
  };
}
