-- Live check: `:Fence run` runs the block under the cursor with its interpreter into a scratch split, `:Fence format`
-- formats the block in place. Both start a real process: a child editor (`nvim --clean -l`), configured the way a user
-- configures an interpreter or a formatter (`fence_run.runners`, `fence_format.formatters`); it is on every machine
-- that runs the sheets, a Lua interpreter, stylua or prettier is not.
return {
  id = 'cma.fence-run',
  feature = 'cma.fence-run',
  title = ':Fence run shows the output of the block, :Fence format formats it in place',
  task = 'color_my_ascii.nvim/performance-pruefung-luecken-schliessen-katalog-feature-shee',
  minit = 'TESTS/sheets/minit.lua',
  sizes = { { rows = 40, cols = 120 } },
  steps = {
    {
      lua = [[dofile(vim.fn.getcwd() .. '/TESTS/sheets/_helpers.lua')
      local nvim = { vim.v.progpath, '--clean', '-l' }
      local formatter = vim.list_extend(vim.deepcopy(nvim), { vim.fn.getcwd() .. '/TESTS/sheets/fixtures/trim_formatter.lua' })
      _G.boot({ '# Run', '', '```lua', "io.write('hello from the fence')", '```', '', 'text' }, {
        fence_run = { runners = { lua = nvim } },
        fence_format = { formatters = { lua = formatter } },
      })]],
      note = 'a markdown buffer with a lua block; the interpreter and the formatter are a child editor',
    },
    { lua = [[vim.api.nvim_win_set_cursor(0, { 4, 0 })]] },
    { keys = ':Fence run<CR>' },
    { wait = [[_G.noted('running lua')]], note = 'it says what it runs' },
    {
      wait = [[vim.fn.winnr('$') == 2 and vim.bo.buftype == 'nofile']],
      timeout = 15000,
      note = 'the output opens in a scratch split below',
    },
    {
      expect = [[_G.buftext():find('hello from the fence', 1, true) ~= nil]],
      note = 'with what the block wrote to stdout',
    },
    { expect = [[_G.buftext():find('[lua · exit 0]', 1, true) ~= nil]], note = 'and the exit code' },
    { lua = [[vim.cmd('close')]] },
    {
      lua = [[vim.api.nvim_buf_set_lines(0, 3, 4, false, { 'local x = 1   ', '\treturn x  ' }); _G.forget()
      vim.api.nvim_win_set_cursor(0, { 4, 0 })]],
      note = 'the block now has trailing blanks and a tab',
    },
    { keys = ':Fence format<CR>' },
    { wait = [[_G.noted('formatted lua block')]], timeout = 15000, note = 'the formatter answered' },
    {
      expect = [[vim.deep_equal(vim.api.nvim_buf_get_lines(0, 2, 6, false), { '```lua', 'local x = 1', '  return x', '```' })]],
      note = 'the interior is replaced by its output, the fences stay',
    },
  },
}
