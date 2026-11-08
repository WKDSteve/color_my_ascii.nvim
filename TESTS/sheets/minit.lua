-- TESTS/sheets/minit.lua -- the init of the child editor of every test sheet. Like TESTS/minimal_init.lua, but the
-- plugin itself is a throwaway COPY of lua/ and plugin/ (no doc/): plugin/ regenerates helptags and would write
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
copy(root .. '/lua', tmp .. '/lua')
copy(root .. '/plugin', tmp .. '/plugin')
vim.opt.rtp:remove(root)
vim.opt.rtp:prepend(tmp)
