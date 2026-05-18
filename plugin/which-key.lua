vim.pack.add {
  'https://github.com/folke/which-key.nvim',
}

require('which-key').setup {
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.o.timeoutlen
  delay = 0,

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
  },
}

-- vim: ts=2 sts=2 sw=2 et
