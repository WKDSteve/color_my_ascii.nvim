-- Live check: `:ColorMyAscii show-config` and `:ColorMyAscii debug` print their reports.
return {
  id = 'cma.info',
  title = ':ColorMyAscii show-config and debug report',
  task = 'color_my_ascii.nvim/testblatt-bindings-checkliste',
  sizes = { { rows = 40, cols = 120 } },
  steps = {
    { lua = [[dofile(vim.fn.getcwd() .. '/TESTS/sheets/_helpers.lua'); _G.boot({ '```ascii', '+--+', '```' })]] },
    { keys = ':ColorMyAscii show-config<CR>' },
    {
      expect = [[_G.noted('## Features') and _G.noted('## Languages') and _G.noted('## Highlights')]],
      note = 'show-config prints features, languages and highlights',
    },
    { lua = [[_G.forget()]] },
    { keys = ':ColorMyAscii debug<CR>' },
    {
      expect = [[_G.noted('Languages loaded:') and _G.noted('Features:')]],
      note = 'debug prints the loaded languages and the feature status',
    },
  },
}
