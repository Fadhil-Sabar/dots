--- Persist last search query per picker source.
--- Saves/restores the `pattern` for each Snacks picker source
--- so reopening the same picker reuses your last search.
local M = {}

local data_file = vim.fn.stdpath("data") .. "/last_search.json"

---@type table<string, string>
M._data = {}

--- Snacks picker source aliases (same as snacks.picker.config.alias)
local aliases = {
  live_grep = "grep",
  find_files = "files",
  git_commits = "git_log",
  git_bcommits = "git_log_file",
  oldfiles = "recent",
}

--- Normalize a source name using the alias table.
---@param source string
---@return string
local function norm(source)
  return aliases[source] or source
end

--- Start every Neovim session with fresh picker filters.
function M.load()
  M._data = {}
  vim.fn.writefile({ vim.json.encode(M._data) }, data_file)
end

--- Save persisted data to disk
function M.save_data()
  local ok, dir = pcall(vim.fn.stdpath, "data")
  if not ok then
    return
  end
  vim.fn.mkdir(dir, "p")
  vim.fn.writefile({ vim.json.encode(M._data) }, data_file)
end

---@param source string e.g. "files", "grep", "buffers"
---@param pattern string the search text to save (empty string = don't save)
function M.save(source, pattern)
  if not source or type(source) ~= "string" or pattern == nil then
    return
  end
  pattern = vim.trim(pattern)
  if pattern ~= "" then
    source = norm(source)
    M._data[source] = pattern
    M.save_data()
  end
end

---@param source string
---@return string|nil
function M.restore(source)
  if not source or type(source) ~= "string" then
    return nil
  end
  source = norm(source)
  local saved = M._data[source]
  if saved and saved ~= "" then
    return saved
  end
  return nil
end

--- Hook: wrap Snacks.picker.pick to inject saved pattern and save on close.
--- Call once after Snacks is loaded.
function M.setup()
  local orig_pick = Snacks.picker.pick

  ---@diagnostic disable: duplicate-set-field
  function Snacks.picker.pick(source, opts)
    -- Normalize arguments (Snacks picker supports both call styles)
    if not opts and type(source) == "table" then
      opts, source = source, nil
    end
    opts = opts or {}

    local src = opts.source or source
    local src_norm = src and type(src) == "string" and norm(src) or nil

    -- Restore last search pattern for this source
    if src_norm then
      local saved = M.restore(src_norm)
      -- Only inject if there's a saved pattern and the caller didn't explicitly set one
      if saved and (opts.pattern == nil or opts.pattern == "") then
        opts = vim.deepcopy(opts)
        opts.pattern = saved
      end
    end

    -- Wrap on_close to persist the pattern
    -- Use src_norm (already alias-resolved) to ensure we save under the canonical name
    local orig_on_close = opts.on_close
    opts.on_close = function(picker)
      -- Use the resolved source from picker.opts (post-alias resolution by config)
      local psrc = (picker and picker.opts and picker.opts.source) or src_norm
      if psrc and picker and picker.input then
        M.save(psrc, picker.input.filter.pattern)
      end
      if orig_on_close then
        orig_on_close(picker)
      end
    end

    return orig_pick(source, opts)
  end
end

-- Load on module require
M.load()

-- Auto-save on Neovim exit (belt-and-suspenders with close-save)
vim.api.nvim_create_autocmd("ExitPre", {
  group = vim.api.nvim_create_augroup("last_search_persist", { clear = true }),
  callback = function()
    M.save_data()
  end,
})

return M
