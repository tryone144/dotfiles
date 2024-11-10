--
-- VIM / NEOVIM
-- Personal (neo)vim configuration
--   tree-sitter configuration
--
-- file: ~/.config/nvim/lua/treesitter.lua
-- v2.0 / 2023.05.24
--
-- (c) 2023 Bernd Busse
--

-- enable treesitter highlighting
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    disable = { "rust" }
  },
}

-- add mdx support with markdown parser
vim.treesitter.language.register('mdx', 'typescript')
