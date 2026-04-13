{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./configs/init.vim;

    plugins = with pkgs.vimPlugins; [
      vim-lastplace
      fzf-vim
      copilot-vim
      vim-fugitive
      csv-vim
      vim-rooter
      ts-comments-nvim
      grug-far-nvim
      gitsigns-nvim
      nvim-treesitter
      mini-icons
      neo-tree-nvim
      gitsigns-nvim
      undotree
    ];
  };
}
