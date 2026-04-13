{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = builtins.readFile ./configs/init.lua;

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
