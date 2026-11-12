-- Live check: `:ColorMyAscii hover` shows the highlight info of the character under the cursor.
return {
  id = 'cma.hover',
  feature = 'cma.hover',
  title = ':ColorMyAscii hover',
  task = 'color_my_ascii.nvim/testblatt-bindings-checkliste',
  minit = 'TESTS/sheets/minit.lua',
  sizes = { { rows = 40, cols = 120 } },
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. '/TESTS/sheets/_helpers.lua'); _G.boot({ '```ascii', '+--+', '```' })]] },
    { lua = [[vim.fn.setreg('"', ''); vim.api.nvim_win_set_cursor(0, { 2, 0 })]] },
    { keys = ':ColorMyAscii hover<CR>' },
    {
      expect = [[vim.fn.getreg('"'):find('Character: "+"', 1, true) ~= nil]],
      note = 'the info about the + under the cursor is copied to the register',
    },
    {
      expect = [[(function() for _, w in ipairs(vim.api.nvim_list_wins()) do if vim.api.nvim_win_get_config(w).relative ~= '' then return true end end return false end)()]],
      note = 'and a float shows it',
    },
  },
  judge = { 'the float names the character, its highlight group and keyword info and reads well' },
}
