vim.pack.add {
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
}

require('catppuccin').setup {
  term_colors = true,
  styles = {
    conditionals = {},
  },
}
