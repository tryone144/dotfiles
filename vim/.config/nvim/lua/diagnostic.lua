--
-- VIM / NEOVIM
-- Personal (neo)vim configuration
--   diagnostics display settings
--
-- file: ~/.config/nvim/lua/diagnostic.lua
-- v2.0 / 2023.05.24
--
-- (c) 2023 Bernd Busse
--

-- General appearance
vim.diagnostic.config {
  virtual_text = { prefix = '◉' },
  signs = true,
  severity_sort = true,
}

-- Custom gutter icons
local signs = {
  Error = '✘',
  Warn = '‼',
  Hint = '',
  Info = '',
}
for type, icon in pairs(signs) do
  local sign = "DiagnosticSign" .. type
  local hl = "Diagnostic" .. type
  vim.fn.sign_define(sign, { text = icon, texthl = hl, numhl = hl })
end

-- Show current diagnostics in hover window
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local line_diagnostics = vim.diagnostic.get(0, { lnum = lnum })
    if #line_diagnostics > 1 then
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end
  end
})
