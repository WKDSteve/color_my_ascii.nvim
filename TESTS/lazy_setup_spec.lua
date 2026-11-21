-- TESTS/lazy_setup_spec.lua — the plugin/ bootstrap no longer calls setup():
-- the 31 languages/*.lua are loaded by the first setup() (the user's, or the
-- default one ensure_setup() runs when a buffer is attached), never twice.

return function(H)
  local eq, ok = H.eq, H.ok

  local function unload()
    for name in pairs(package.loaded) do
      if name == 'color_my_ascii' or name:find('^color_my_ascii%.') then
        package.loaded[name] = nil
      end
    end
  end
  local function languages_loaded()
    for name in pairs(package.loaded) do
      if name:find('^color_my_ascii%.languages%.') then
        return true
      end
    end
    return false
  end

  unload()
  vim.g.loaded_color_my_ascii = nil
  local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
  vim.cmd('source ' .. vim.fn.fnameescape(root .. '/plugin/color_my_ascii.lua'))

  ok(not languages_loaded(), 'sourcing plugin/ loads no language table')
  ok(not require('color_my_ascii.config').is_ready(), 'and does not build the config store')
  ok(vim.fn.exists(':ColorMyAscii') == 2, 'the command exists')
  eq(#vim.api.nvim_get_autocmds({ group = 'ColorMyAscii', event = 'FileType' }) >= 1, true, 'the markdown FileType autocmd exists')

  -- peek() answers from DEFAULTS without building the store
  eq(require('color_my_ascii.config').peek().debug_enabled, false, 'peek() reads the defaults')
  ok(not languages_loaded(), 'peek() loads no language table')

  -- Opening markdown runs the default setup once
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '```ascii', '+--+', '|ok|', '+--+', '```' })
  vim.bo[buf].filetype = 'markdown'
  ok(languages_loaded(), 'the first markdown buffer loads the languages')
  local gen = require('color_my_ascii.config').generation()
  eq(gen, 1, 'through exactly one setup()')

  -- An explicit setup afterwards is the second one, and ensure_setup() stays out
  local cma = require('color_my_ascii')
  cma.ensure_setup()
  eq(require('color_my_ascii.config').generation(), 1, 'ensure_setup() does not repeat a done setup')

  -- A user setup before any buffer: ensure_setup() must not add a default one
  unload()
  vim.g.loaded_color_my_ascii = nil
  vim.cmd('source ' .. vim.fn.fnameescape(root .. '/plugin/color_my_ascii.lua'))
  require('color_my_ascii').setup({ language_detection_threshold = 4 })
  local buf2 = vim.api.nvim_create_buf(true, false)
  vim.bo[buf2].filetype = 'markdown'
  eq(require('color_my_ascii.config').generation(), 1, 'a user setup() is the only one')
  eq(require('color_my_ascii.config').get().language_detection_threshold, 4, 'and its options stay')

  pcall(vim.api.nvim_buf_delete, buf, { force = true })
  pcall(vim.api.nvim_buf_delete, buf2, { force = true })
end
