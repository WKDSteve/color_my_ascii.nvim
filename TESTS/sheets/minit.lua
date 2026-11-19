-- TESTS/sheets/minit.lua -- the init of the child editor of every test sheet. Like TESTS/minimal_init.lua, but the
-- checkout itself is not on the runtimepath: plugin/ regenerates helptags and would write doc/tags into the checkout
-- (changing an input of every other spec while the run goes on). Its runtime directories (plugin/, ...; no doc/, no
-- lua/) are a throwaway COPY on the runtimepath instead, and the Lua modules are loaded from the checkout through
-- package.path: their frames then lie in the checkout's lua/, where `testing perf` finds the spawn sites it reached.

local uv = vim.uv or vim.loop
local init = dofile(vim.fn.getcwd() .. '/TESTS/minimal_init.lua')
local root = init.root

---@param from string
---@param to string
local function copy(from, to)
  vim.fn.mkdir(to, 'p')
  for name, kind in vim.fs.dir(from) do
    if kind == 'directory' then
      copy(from .. '/' .. name, to .. '/' .. name)
    else
      assert(uv.fs_copyfile(from .. '/' .. name, to .. '/' .. name))
    end
  end
end

local tmp = vim.fn.tempname()
-- Every runtime directory the checkout has but doc/ (the one a copy must not carry along) and lua/ (read in place).
for _, dir in ipairs({
  'plugin',
  'after',
  'autoload',
  'ftplugin',
  'ftdetect',
  'indent',
  'syntax',
  'queries',
  'colors',
}) do
  if vim.fn.isdirectory(root .. '/' .. dir) == 1 then
    copy(root .. '/' .. dir, tmp .. '/' .. dir)
  end
end
vim.opt.rtp:remove(root)
vim.opt.rtp:prepend(tmp)
-- Nothing on the runtimepath has lua/color_my_ascii, so Neovim's runtimepath loader passes and the path loader finds it.
package.path = ('%s/lua/?.lua;%s/lua/?/init.lua;'):format(root, root) .. package.path
