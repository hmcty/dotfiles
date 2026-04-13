vim.cmd('colorscheme habamax')

vim.opt.compatible = false
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.wildmode = 'longest,list'
vim.opt.colorcolumn = '80'
vim.opt.cursorline = true
vim.opt.ttyfast = true
vim.opt.clipboard:append('unnamedplus')
vim.opt.termguicolors = true

vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')
vim.cmd('filetype plugin on')

vim.g.netrw_keepdir = 0

-- Keybindings
vim.keymap.set('', '<C-p>', ':GFiles<CR>', { silent = true })
vim.keymap.set('', '<C-f>', ':Rg<CR>', { silent = true })
vim.keymap.set('', '<C-k>', ':py3f ~/.config/home-manager/clang-format.py<CR>', { silent = true })
vim.keymap.set('i', '<C-k>', '<Esc>:py3f ~/.config/home-manager/clang-format.py<CR>a', { silent = true })

vim.keymap.set('v', '<leader>y', '"+y', { silent = true })
vim.keymap.set('n', '<leader>Y', '"+yg_', { silent = true })
vim.keymap.set('n', '<leader>y', '"+y', { silent = true })
vim.keymap.set('n', '<leader>yy', '"+yy', { silent = true })

vim.keymap.set('n', '<leader>p', '"+p', { silent = true })
vim.keymap.set('n', '<leader>P', '"+P', { silent = true })
vim.keymap.set('v', '<leader>p', '"+p', { silent = true })
vim.keymap.set('v', '<leader>P', '"+P', { silent = true })

vim.g.rooter_patterns = {'.git', 'WORKSPACE'}
vim.g.copilot_filetypes = {
  tidal = false,
}

require('mini.icons').setup({})
require('gitsigns').setup({})

local local_config = vim.fn.expand('~/.config/nvim/local.lua')
if vim.fn.filereadable(local_config) == 1 then
  dofile(local_config)
end
