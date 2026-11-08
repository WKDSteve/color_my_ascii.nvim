-- Live check: `:ColorMyAscii`, `toggle` (global) and `toggle buffer` switch the highlighting.
return {
  id = 'cma.toggle',
  title = ':ColorMyAscii toggle and toggle buffer',
  task = 'color_my_ascii.nvim/testblatt-bindings-checkliste',
  sizes = { { rows = 40, cols = 120 } },
  steps = {
    {
      lua = [[dofile(vim.fn.getcwd() .. '/TESTS/sheets/_helpers.lua'); _G.buf = _G.boot({ '```ascii', '+--+', '```' })]],
    },
    { keys = ':ColorMyAscii<CR>' },
    {
      expect = [[require('color_my_ascii').get_state().buffers[_G.buf] == true]],
      note = 'the bare verb manages the buffer',
    },
    { keys = ':ColorMyAscii toggle buffer<CR>' },
    {
      expect = [[require('color_my_ascii').get_state().buffers[_G.buf] == nil]],
      note = 'toggle buffer switches this buffer off',
    },
    {
      expect = [[require('color_my_ascii').get_state().enabled == true]],
      note = 'without touching the global switch',
    },
    { keys = ':ColorMyAscii toggle buffer<CR>' },
    { expect = [[require('color_my_ascii').get_state().buffers[_G.buf] == true]], note = 'and on again' },
    { keys = ':ColorMyAscii toggle<CR>' },
    { expect = [[require('color_my_ascii').get_state().enabled == false]], note = 'toggle switches everything off' },
    { keys = ':ColorMyAscii toggle<CR>' },
    { expect = [[require('color_my_ascii').get_state().enabled == true]], note = 'and back on' },
  },
  judge = { 'with the highlighting on, the box characters of the ascii fence are coloured; off, they are plain' },
}
