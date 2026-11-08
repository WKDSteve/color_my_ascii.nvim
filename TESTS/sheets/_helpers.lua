-- TESTS/sheets/_helpers.lua -- what every color_my_ascii test sheet needs in its child editor. Not a sheet
-- (`testing.sheet` only reads *.sheet.lua); a sheet's first step runs it with `dofile`, the child's cwd is
-- the project root. The directory is in the spec's @cache-inputs, so a change here re-runs the sheets.
--
-- Every notification is collected (the commands answer through `vim.notify`), nothing else is stubbed.

vim.o.swapfile = false
vim.opt.shortmess:append('I')

_G.notes = {}
vim.notify = function(msg)
  _G.notes[#_G.notes + 1] = tostring(msg)
end

---Whether a notification so far holds `text` (plain).
---@param text string
---@return boolean
function _G.noted(text)
  for _, n in ipairs(_G.notes) do
    if n:find(text, 1, true) then
      return true
    end
  end
  return false
end

---Forget the notifications so far.
function _G.forget()
  _G.notes = {}
end

---Open a markdown buffer with `lines` in the current window, the plugin set up for it.
---@param lines string[]
---@param opts? table  setup() options
---@return integer buf
function _G.boot(lines, opts)
  require('color_my_ascii').setup(opts or {})
  vim.cmd('enew')
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].filetype = 'markdown'
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  require('color_my_ascii').setup_buffer(buf)
  return buf
end

---All lines of the current buffer joined.
---@return string
function _G.buftext()
  return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
end
