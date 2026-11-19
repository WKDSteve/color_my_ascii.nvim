-- TESTS/sheets/fixtures/trim_formatter.lua -- a stand-in formatter for the cma.fence-run sheet, run as
-- `nvim --clean -l <this file>`: reads the block on stdin, strips trailing blanks and turns tabs into two
-- spaces, writes the result to stdout (the contract of `config.fence_format.formatters`). A child editor
-- is on every machine that runs the sheets, a real formatter (stylua, prettier) is not.
local text = io.stdin:read('*a')
text = text:gsub('\r\n', '\n'):gsub('[ \t]+\n', '\n'):gsub('[ \t]+$', ''):gsub('\t', '  ')
io.stdout:write(text, '\n')
