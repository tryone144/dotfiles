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

vim.o.winborder = "rounded"

-- General appearance, custom gutter icons
vim.diagnostic.config {
  virtual_text = { prefix = '◉' },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '‼',
      [vim.diagnostic.severity.HINT] = '',
      [vim.diagnostic.severity.INFO] = '',
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
    },
  },
  severity_sort = true,
  float = {
    focusable = false,
    close_events = { "BufLeave", "InsertEnter", "CursorMoved" },
    border = "rounded",
    source = "always",
    prefix = ' ',
    scope = "cursor",
  },
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
  end
})

-- Show current diagnostics in hover window
--vim.api.nvim_create_autocmd("CursorHold", {
--  buffer = bufnr,
--  callback = function()
--    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
--    local line_diagnostics = vim.diagnostic.get(0, { lnum = lnum })
--    --if #line_diagnostics > 1 then
--      local opts = {
--        focusable = false,
--        close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
--        border = 'rounded',
--        source = 'always',
--        prefix = ' ',
--        scope = 'cursor',
--      }
--      vim.diagnostic.open_float(nil, opts)
--    --end
--  end
--})

local function close_floating()
  local inactive_floating_wins = vim.fn.filter(vim.api.nvim_list_wins(), function(k, v)
    local file_type = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(v), "filetype")

    return vim.api.nvim_win_get_config(v).relative ~= ""
      and v ~= vim.api.nvim_get_current_win()
  end)
  for _, w in ipairs(inactive_floating_wins) do
    pcall(vim.api.nvim_win_close, w, false)
  end
end
vim.keymap.set("n", "<Esc>", close_floating)
