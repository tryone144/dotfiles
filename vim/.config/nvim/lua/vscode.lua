--
-- VIM / NEOVIM
-- Personal (neo)vim configuration
--   vscode specific configuration
--
-- file: ~/.config/nvim/lua/vscode.lua
-- v1.0 / 2023.11.15
--
-- (c) 2023 Bernd Busse
--

local vscode = require('vscode-neovim')

vim.g.mapleader = "<Space>"

-- shortcut of `,` to open the command line (easier on neo2)
vim.keymap.set({'n', 'v'}, ',', ':')

-- editor / file handling
local opts = { silent = true }
--vim.keymap.set('n', '<leader>bn', function() vscode.action('workbench.action.nextEditor') end, opts)
--vim.keymap.set('n', '<leader>bp', function() vscode.action('workbench.action.previousEditor') end, opts)
--vim.keymap.set('n', '<leader>bq', function() vscode.action('workbench.action.closeActiveEditor') end, opts)
