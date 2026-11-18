---@module 'color_my_ascii.autodoc'
--- Generates helptags for color_my_ascii.nvim if missing or stale.
--- This file is loaded exactly once at startup by Neovim.

-- Resolve plugin root directory from this file location
local source = debug.getinfo(1, 'S').source
if type(source) ~= 'string' then
  return
end

local file = source:sub(2)
local plugin_root = vim.fn.fnamemodify(file, ':h:h')
local doc_dir = plugin_root .. '/doc'
local tags_file = doc_dir .. '/tags'

--- Missing, or older than a help file: an edited doc/ in a local checkout (lazy.nvim
--- regenerates tags only for plugins it installs or updates itself).
---@return boolean
local function tags_stale()
  local tags = vim.uv.fs_stat(tags_file)
  if not tags then
    return true
  end
  for _, txt in ipairs(vim.fn.glob(doc_dir .. '/*.txt', false, true)) do
    local st = vim.uv.fs_stat(txt)
    if
      st and (st.mtime.sec > tags.mtime.sec or (st.mtime.sec == tags.mtime.sec and st.mtime.nsec > tags.mtime.nsec))
    then
      return true
    end
  end
  return false
end

-- Generate helptags only if necessary
if vim.fn.isdirectory(doc_dir) == 1 and tags_stale() then
  vim.schedule(function()
    pcall(function()
      vim.cmd('silent helptags ' .. vim.fn.fnameescape(doc_dir))
    end)
  end)
end
