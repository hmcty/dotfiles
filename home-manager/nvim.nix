{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
	extraConfig = ''
    colorscheme habamax

	  set nocompatible            " disable compatibility to old-time vi
	  set showmatch               " show matching 
	  set ignorecase              " case insensitive 
	  set hlsearch                " highlight search 
	  set incsearch               " incremental search
	  set tabstop=2               " number of columns occupied by a tab 
	  set softtabstop=2           " see multiple spaces as tabstops
	  set expandtab               " converts tabs to white space
	  set shiftwidth=2            " width for autoindents
	  set autoindent              " indent a new line the same amount
	  set number                  " add line numbers
	  set wildmode=longest,list   " get bash-like tab completions
	  set cc=80                   " set an 80 column border
	  filetype plugin indent on   "allow auto-indenting depending on file type
	  syntax on                   " syntax highlighting
	  filetype plugin on
	  set cursorline              " highlight current cursorline
	  set ttyfast                 " Speed up scrolling in Vim
	  set clipboard=unnamed       " Always copy to clipboard
    set termguicolors           " Enable true colors
    let g:netrw_keepdir=0       " Fix for copying files in netrw on OSX

    " Keybindings
    map <C-p> :GFiles<CR>
    map <C-f> :Rg<CR>
    map <C-k> :py3f ~/.config/home-manager/clang-format.py<CR>
    imap <C-k> :py3f ~/.config/home-manager/clang-format.py<CR>

    " Rooter plugin
    let g:rooter_patterns = ['.git', 'WORKSPACE']

    '';

    plugins = with pkgs.vimPlugins; [
      vim-lastplace
      fzf-vim
      copilot-vim
      vim-fugitive
      csv-vim
      vim-rooter
    ];
  };
}
