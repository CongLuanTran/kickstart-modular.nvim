return {
  'catppuccin/nvim',
  name = 'catppuccin',
  config = function()
    require('catppuccin').setup {
      auto_integrations = true,
    }

    vim.cmd.colorscheme 'catppuccin'
  end,
}
