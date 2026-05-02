return {
  'catppuccin/nvim',
  name = 'catppuccin',
  opts = {
    auto_integrations = true,
    term_colors = true,
    styles = {
      conditionals = {},
    },
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
