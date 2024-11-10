--
-- VIM / NEOVIM
-- Personal (neo)vim configuration
--   crates configuration
--
-- file: ~/.config/nvim/lua/crates.lua
-- v2.0 / 2023.11.15
--
-- (c) 2023 Bernd Busse
--

require('crates').setup {
  src = {
    coq = {
      enabled = true,
      name = "crates.nvim",
    },
  },
}
