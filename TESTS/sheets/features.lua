-- TESTS/sheets/features.lua -- the functionalities of color_my_ascii.nvim as its user meets them; `testing sheets
-- report` says which ones have a feature sheet (`feature = "<id>"`) and in which state, and K16 warns about a sheet
-- that names an id not listed here. Data: read with an empty environment like a sheet (testing.nvim docs/SHEETS.md).
-- The list follows docs/FEATURES/ (README.md and its pages) and ALL/manual-test-checklists/color_my_ascii.md; the
-- APIs for plugin authors are not on it.
return {
  {
    id = 'cma.highlighting',
    title = 'ASCII blocks in Markdown are found and highlighted by character groups, keywords, functions and brackets',
    docs = 'docs/FEATURES/HIGHLIGHTING.md',
    perf = 'skip:no process: extmarks computed in the editor (measured by the specs, not by perf)',
  },
  {
    id = 'cma.languages',
    title = 'The language of a block comes from its fence tag or is detected from its words; 31 languages built in',
    docs = 'docs/FEATURES/LANGUAGES.md',
    perf = 'skip:no process: tag lookup and word scoring in the editor',
  },
  {
    id = 'cma.toggle',
    title = ':ColorMyAscii re-highlights the buffer; toggle switches the highlighting globally or for one buffer',
    surface = { 'command:ColorMyAscii', 'command:ColorMyAscii toggle' },
    docs = 'docs/FEATURES/TOOLS.md',
  },
  {
    id = 'cma.reports',
    title = ':ColorMyAscii show-config and debug print the resolved configuration and the debug report',
    surface = { 'command:ColorMyAscii show-config', 'command:ColorMyAscii debug' },
    docs = 'docs/FEATURES/TOOLS.md',
  },
  {
    id = 'cma.hover',
    title = ':ColorMyAscii hover explains the highlight of the character under the cursor',
    surface = { 'command:ColorMyAscii hover' },
    docs = 'docs/FEATURES/TOOLS.md',
  },
  {
    id = 'cma.schemes',
    title = ':ColorMyAscii schemes lists and switches the built-in color schemes',
    surface = { 'command:ColorMyAscii schemes' },
    docs = 'docs/FEATURES/COLORSCHEMES.md',
  },
  {
    id = 'cma.fence-tools',
    title = 'fence-jump moves between delimiters, check-fences reports broken fences, ensure-blank-lines spaces them',
    surface = {
      'command:ColorMyAscii fence-jump',
      'command:ColorMyAscii check-fences',
      'command:ColorMyAscii ensure-blank-lines',
    },
    docs = 'docs/FEATURES/FENCES.md',
  },
  {
    id = 'cma.fence-highlight',
    title = 'The fence lines and the interior of a fenced block get their own background, matched to the theme',
    docs = 'docs/FEATURES/FENCES.md',
    perf = 'skip:no process: line highlights in the editor',
  },
  {
    id = 'cma.fence-export',
    title = ':Fence export and yank extract the block under the cursor, also as HTML or ANSI',
    docs = 'docs/FEATURES/FENCES.md',
    perf = "skip:no process of its own: writes a file or a register; the + register's clipboard provider is Neovim's",
  },
  {
    id = 'cma.fence-open',
    title = ':Fence open edits the block in a split of its language (LSP attaches); :w writes it back into the fence',
    docs = 'docs/FEATURES/FENCES.md',
    perf = "skip:no process of its own: a split with the block's filetype; a language server that attaches is the user's LSP setup",
  },
  {
    id = 'cma.fence-run',
    title = ':Fence run runs the block with its interpreter into a scratch split; :Fence format formats it in place',
    surface = { 'command:Fence run', 'command:Fence format' },
    docs = 'docs/FEATURES/FENCES.md',
  },
  {
    id = 'cma.fence-edit',
    title = ':Fence import, lang, select and wrap change the block or the fence in place',
    docs = 'docs/FEATURES/FENCES.md',
    perf = 'skip:no process: buffer edits in the editor',
  },
  {
    id = 'cma.box-align',
    title = ':Fence align straightens the right edge of a box-drawing box',
    docs = 'docs/FEATURES/FENCES.md',
    perf = 'skip:no process: buffer edits in the editor',
  },
  {
    id = 'cma.comment-ascii',
    title = 'Opt-in: ASCII blocks marked in code comments are highlighted too',
    docs = 'docs/FEATURES/HIGHLIGHTING.md',
    perf = 'skip:no process: extmarks in the editor',
  },
  {
    id = 'cma.context-menu',
    title = 'The right-click menu offers toggle, scheme switch, highlight info and the :Fence toolkit',
    docs = 'docs/FEATURES/FENCES.md',
    perf = 'skip:no process: menu entries that call the commands measured by their own sheets',
  },
  {
    id = 'cma.health',
    title = ':checkhealth color_my_ascii verifies dependencies and setup',
    docs = 'docs/FEATURES/TOOLS.md',
    perf = 'skip:no process: :checkhealth only loads modules and reads the configuration',
  },
}
