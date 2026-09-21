vim.pack.add {
  'https://github.com/folke/which-key.nvim',
}

local wk = require 'which-key'

wk.setup {
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.o.timeoutlen
  delay = 0,
  preset = 'helix',

  -- Document existing key chains
  spec = {
    { '<leader>s', desc = 'Search' },
    { '<leader>t', group = 'Toggle' },
    { '<leader>h', group = 'Git Hunk', mode = { 'n', 'v' } },
    { '<leader>d', group = 'Debug' },
    { '<leader>g', group = 'Git' },
    { '<leader>u', group = 'UI' },
    { '<leader>n', group = 'Notifications' },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
    { '<leader>?', function() wk.show { global = false } end, desc = 'Buffer Local Keymaps' },
  },
}

-- vim: ts=2 sts=2 sw=2 et
