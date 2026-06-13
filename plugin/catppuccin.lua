vim.pack.add {
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
}

require('catppuccin').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  custom_highlights = function(colors)
    return {
      GitSignsStagedAdd = { fg = colors.teal },
      GitSignsStagedAddNr = { link = 'GitSignsStagedAdd', bold = true },
      GitSignsStagedChange = { fg = colors.peach },
      GitSignsStagedChangeNr = { link = 'GitSignsStagedChange', bold = true },
      GitSignsStagedDelete = { link = 'GitSignsDelete' },
    }
  end,
  intergrations = {
    snacks = {
      enabled = true,
    },
  },
}
