-- Live check: `:ColorMyAscii schemes list|switch` (task color_my_ascii.nvim/testblatt-bindings-checkliste; the
-- :ColorMyAscii section of BINDINGS-RUNTIME-CHECKLIST.md). `schemes pick` needs telescope and stays by hand.
return {
  id = 'cma.schemes',
  title = ':ColorMyAscii schemes list and switch',
  task = 'color_my_ascii.nvim/testblatt-bindings-checkliste',
  minit = 'TESTS/sheets/minit.lua',
  sizes = { { rows = 40, cols = 120 } },
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. '/TESTS/sheets/_helpers.lua'); _G.boot({ '```ascii', '+--+', '```' })]] },
    { keys = ':ColorMyAscii schemes list<CR>' },
    { expect = [[_G.noted('Usage: :ColorMyAscii schemes switch <name>')]], note = 'the list ends with its usage' },
    { expect = [[_G.noted('• nord')]], note = 'and names the scheme nord' },
    { lua = [[_G.forget()]] },
    { keys = ':ColorMyAscii schemes switch nord<CR>' },
    { expect = [[_G.noted('Switched to scheme: nord')]], note = 'switching says which scheme is on' },
    { lua = [[_G.forget()]] },
    { keys = ':silent! ColorMyAscii schemes switch nosuchscheme<CR>', ignore_errmsg = true },
    {
      expect = [[_G.noted('Unknown scheme: nosuchscheme') and _G.noted('Available:')]],
      note = 'an unknown name is refused and the choices are named',
    },
  },
  manual = {
    ':ColorMyAscii schemes pick opens the Telescope picker and applying an entry recolours the buffer (needs telescope.nvim)',
  },
}
