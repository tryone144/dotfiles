--
-- VIM / NEOVIM
-- Personal (neo)vim configuration
--   language client configuration
--
-- file: ~/.config/nvim/lua/lsp.lua
-- v2.0 / 2023.05.24
--
-- (c) 2023 Bernd Busse
--

-- Setup autocomplete
vim.g.coq_settings = {
  auto_start = 'shut-up',
  keymap = {
    recommended = false,
    manual_complete = '',
    manual_complete_insertion_only = true,
  },
  clients = {
    tmux = { enabled = false },
    third_party = { enabled = true },
  },
  completion = {
    always = true,
    replace_prefix_threshold = 3,
    replace_prefix_threshold = 2,
  },
  display = {
    ghost_text = {
      enabled = true,
      highlight_group = 'Comment',
    },
    preview = {
      positions = {
        east = 1,
        north = 2,
        west = 3,
        south = 4,
      },
    },
  }
}

-- nicer UI
vim.ui.input = function(opts, on_confirm)
  require('floating-input').input(opts, on_confirm, { boarder = "rounded" })
end

local coq = require('coq')

-- Extra completion sources
require('coq_3p') {
  { src = "codeium", short_name = "CO" },
}

-- Setup language servers
vim.lsp.config("ccls", coq.lsp_ensure_capabilities({
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  init_options = {
    cache = { directory = "/tmp/ccls-cache" },
  }
}))
vim.lsp.enable("ccls")

--lspconfig.denols.setup(coq.lsp_ensure_capabilities({}))
vim.lsp.config("ts_ls", coq.lsp_ensure_capabilities({}))
vim.lsp.config("biome", coq.lsp_ensure_capabilities({}))
vim.g.markdown_fenced_languages = {
  "ts=typescript"
}
vim.lsp.enable("ts_ls")
vim.lsp.enable("biome")

vim.lsp.config("pylsp", coq.lsp_ensure_capabilities({
  settings = {
    pylsp = {
      configurationSources = { "flake8" },
      plugins = {
        autopep8 = { enabled = false },
        flake8 = { enabled = true },
        jedi_completion = { enabled = true },
        jedi_definition = { enabled = true },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true },
        mccabe = { enabled = false },
        pycodestyle = { enabled = false },
        pydocstyle = { enabled = false },
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        rope_autoimport = { enabled = false },
        rope_completion = { enabled = false },
        yapf = { enabled = true },
      }
    }
  }
}))

vim.lsp.config("rust_analyzer", coq.lsp_ensure_capabilities({
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        allTargets = false,
      },
      completion = {
        autoimport = { enable = true },
        autoself = { enable = true },
        postfix = { enable = false },
      },
      diagnostics = { enable = true },
      hover = {
        actions = { enable = true },
      },
      lens = { enable = true },
      rustfmt = { overrideCommand = { "rustup", "run", "nightly", "rustfmt", "--", "--emit=stdout" } },
    }
  }
}))
vim.lsp.enable("rust_analyzer")

vim.lsp.config("wgsl_analyzer", coq.lsp_ensure_capabilities({
  command = "wgsl_analyzer",
  filetypes = { "wgsl" },
}))

-- vim:sw=2
