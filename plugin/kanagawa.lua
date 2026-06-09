vim.pack.add {
  'https://github.com/rebelot/kanagawa.nvim',
}

require('kanagawa').setup {
  background = {
    dark = 'dragon',
    light = 'lotus',
  },
}
