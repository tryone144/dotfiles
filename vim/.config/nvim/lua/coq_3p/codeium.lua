--
-- VIM / NEOVIM
-- Personal (neo)vim configuration
--   codeium autocomplete interface
--
-- file: ~/.config/nvim/lua/codeium.lua
-- v2.0 / 2023.05.24
--
-- (c) 2023 Bernd Busse
--

-- codeium source
return function(spec)

  return function(args, callback)
    callback { isIncomplete = false, items = {} }
  end

  --local log_debug = function(msg)
  --  print(vim.inspect(msg) .. "\n")
  --end

  --COQcodium = function()
  --  return vim.fn["codeium#Complete"]()
  --end

  --local parse_item = function()
  --end

  ----local suggestions = {}

  ----local pull = function()
  ----  local completions = vim.b._codeium_completions
  ----  if completions then
  ----    log_debug(completions.index)
  ----    return completions.items
  ----  end
  ----  return nil
  ----end
  ----local pull_info = nil
  ----pull_info = function()
  ----  log_debug("pull_info: " .. vim.inspect(suggestions))
  ----  vim.defer_fn(pull_info, 50)
  ----end
  ----pull_info()

  --return function(args, callback)
  --  if not vim.fn["codeium#Enabled"]() then
  --    callback { isIncomplete = false, items = {} }
  --    return
  --  end

  --  log_debug(args)

  --  local items = {}

  --  --local items = (function()
  --  --  COQcodium()
  --  --  while not vim.b._codeium_completions or not vim.b._codeium_completions.items do
  --  --  end

  --  --  local completions = vim.b._codeium_completions.items
  --  --  for completion in completions do
  --  --    log_debug("completion: " .. vim.inspect(completion))
  --  --  end
  --  --end)()

  --  log_debug("Suggestions: " .. vim.inspect(items))

  --  for key, val in pairs(vim.lsp.protocol.CompletionItemKind) do
  --    table.insert(items, {
  --      label = "label .. " .. key,
  --      insertText = key,
  --      kind = val,
  --      detail = tostring(math.random()),
  --    })
  --  end

  --  -- return the suggestions
  --  callback { isIncomplete = true, items = items }
  --end

end
