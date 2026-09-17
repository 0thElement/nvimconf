# Vendored pi.nvim

Source: https://github.com/pablopunk/pi.nvim
Revision: `fab2a7932a5478e522d609a9fd39a7aac6c0440d`
Copied from the installed desktop plugin on 2026-09-17.
License: MIT; the original copyright and license are in `LICENSE` here.

Runtime code lives in `lua/pi/`; command registration lives in `plugin/`.
Neovim loads these directly from this configuration for both profiles.
There is no vim-plug dependency or automatic upstream update. Make future
changes to these local files; selectively port upstream fixes if desired.
The external `pi` CLI is still required.

Local changes:

- Use `stdpath('log')/pi-nvim.log` on all platforms.
- Create the log directory and report open/write/close failures.
- Capture assistant text in PiLog, preserving partial responses on failure or cancellation.
- Show completed responses through mini.notify (with vim.notify fallback).
- Reuse the RPC process between prompts; PiNew resets, PiCancel aborts a turn,
  and Neovim exit shuts down the process.
- Refresh changed, unmodified buffers after tool calls; preserve unsaved edits.

Upstream tests and development tooling were not copied. A local smoke check
is available in `tests/pi_smoke.lua` and does not call an AI provider.
