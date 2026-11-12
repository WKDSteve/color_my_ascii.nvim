-- Live check: `:ColorMyAscii fence-jump`, `check-fences` and `ensure-blank-lines` on a real buffer.
return {
  id = 'cma.fences',
  feature = 'cma.fence-tools',
  title = ':ColorMyAscii fence-jump, check-fences and ensure-blank-lines',
  task = 'color_my_ascii.nvim/testblatt-bindings-checkliste',
  minit = 'TESTS/sheets/minit.lua',
  sizes = { { rows = 40, cols = 120 } },
  steps = {
    {
      lua = [[dofile(vim.fn.getcwd() .. '/TESTS/sheets/_helpers.lua')
      _G.boot({ '# T', '', '```ascii', '+--+', '```', '', 'text' })]],
    },
    { lua = [[vim.api.nvim_win_set_cursor(0, { 3, 0 })]] },
    { keys = ':ColorMyAscii fence-jump<CR>' },
    { expect = [[vim.api.nvim_win_get_cursor(0)[1] == 5]], note = 'from the opening fence to the closing one' },
    { keys = ':ColorMyAscii fence-jump<CR>' },
    { expect = [[vim.api.nvim_win_get_cursor(0)[1] == 3]], note = 'and back' },
    { lua = [[_G.forget()]] },
    { keys = ':ColorMyAscii check-fences<CR>' },
    { expect = [[_G.noted('No unmatched fenced code blocks found')]], note = 'balanced fences are reported clean' },
    { lua = [[vim.api.nvim_buf_set_lines(0, 0, -1, false, { '```ascii', '+--+' }); _G.forget()]] },
    { keys = ':ColorMyAscii check-fences<CR>' },
    { expect = [[_G.noted('Unmatched fenced code blocks detected')]], note = 'an unclosed fence is reported' },
    {
      lua = [[vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'before', '```ascii', 'x', '```', 'after' }); _G.forget()]],
    },
    { keys = ':ColorMyAscii ensure-blank-lines<CR>' },
    {
      expect = [[vim.api.nvim_buf_get_lines(0, 0, -1, false)[2] == '' and vim.api.nvim_buf_get_lines(0, 0, -1, false)[6] == '']],
      note = 'a blank line before the opening fence and after the closing one',
    },
    { expect = [[_G.noted('Added 2 blank line')]], note = 'and it says how many' },
  },
}
