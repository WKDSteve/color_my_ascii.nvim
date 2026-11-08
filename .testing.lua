-- .testing.lua -- configuration of testing.nvim for this project.
-- Written by `testing migrate`; edit freely (it is never overwritten). Every key is optional; the
-- keys are documented in testing.nvim's docs/CONFIG.md. Loading this file executes it (same trust
-- as running the specs).
return {
  -- Lua module root of the project.
  plugin = 'color_my_ascii',
  -- How the spec files are run: "auto" = sniffed per file, "h" = on the project's own TESTS/harness.lua,
  -- "script" = a self-running script in its own process.
  dialect = 'auto',
  -- Dependencies (directory names) put on the runtimepath: $<NAME>_DIR, .deps/<name>, ../<name>,
  -- stdpath('data')/lazy/<name>.
  deps = { 'lib.nvim', 'testing.nvim' },
  -- "none" = all specs in one nvim, "file" = one nvim per spec file
  -- (nothing leaks from one file into the next).
  isolated = 'file',
  -- Guards (docs/GUARDS.md): every spec file runs in its own child editor, so the global state that
  -- setup() leaves (autocmd groups, :ColorMyAscii, highlight groups) cannot leak into the next file.
  guards = {
    fs = 'error',
    state = 'error',
    scheduled_error = 'error',
    prompt = 'error',
    deprecation = 'error',
    process_net = 'error',
  },
  -- sheets_spec.lua runs every test sheet in a child editor of its own (`nvim`); the child works on a copy of the
  -- plugin (TESTS/sheets/minit.lua), so nothing is written into the checkout.
  guard_allow = { spawn = { 'nvim' } },
  timeouts = { case_ms = 30000, file_ms = 300000 },
  -- gated: a failed conformance check makes `scripts/test.sh conformance` exit 1 (docs/CONFORMANCE.md of testing.nvim)
  conformance = { gate = true },
}
