---@module 'color_my_ascii'
--- Plugin initialization file for color_my_ascii.nvim
--- This file is automatically loaded by Neovim when the plugin is installed.
--- It sets up the necessary autocommands and commands for the plugin.

-- Prevent double-loading
if vim.g.loaded_color_my_ascii then
  return
end
vim.g.loaded_color_my_ascii = 1

-- No help registration here. This file is only sourced because the plugin
-- root is on the runtimepath already, so its doc/ is too; and
-- plugin/color_my_ascii_autodoc.lua generates doc/tags when they are
-- missing. A `:helptags` on every load cost ~5 ms per session and rewrote
-- doc/tags each time.

-- Initialize plugin with default config
-- This must happen before any buffer setup
require('color_my_ascii').setup()

-- Register all user commands
require('color_my_ascii.bindings.usrcmds').enable()

-- Register static (startup-time) autocommands
require('color_my_ascii.bindings.autocmds').enable()
