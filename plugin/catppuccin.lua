vim.pack.add {
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
}

require('catppuccin').setup {
  auto_integrations = true,
  term_colors = true,
  styles = {
    conditionals = {},
  },
}

vim.cmd.colorscheme 'catppuccin'
