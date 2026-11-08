-- TESTS/sheets/minit.lua -- the init of the child editor of every test sheet. Like TESTS/minimal_init.lua, but the
-- plugin itself is a throwaway COPY of its runtime directories (lua/, plugin/, ...; no doc/): plugin/ regenerates helptags and would write
-- doc/tags into the checkout (changing an input of every other spec while the run goes on).

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
-- Every runtime directory the checkout has (not doc/: that is the one a copy must not carry along).
for _, dir in ipairs({
  'lua',
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
