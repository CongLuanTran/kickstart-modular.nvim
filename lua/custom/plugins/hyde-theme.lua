return {
  { 'catppuccin/nvim',             name = 'catppuccin' },
  { 'rose-pine/neovim',            name = 'rose-pine' },
  { 'folke/tokyonight.nvim',       opts = {} },
  { 'EdenEast/nightfox.nvim' },
  { 'ellisonleao/gruvbox.nvim',    opts = {} },
  { 'miikanissi/modus-themes.nvim' },
  --- More colorscheme if you wish
  {
    'CongLuanTran/hyde-theme.nvim',
    opts = {
      -- It is possible to set your own default theme.
      -- For example, "astrotheme" if your use AstroNvim
      -- default = "astrotheme"
      -- Optionally override theme mapping or add new mapping here
      -- ["Tokyo-Night"] = "tokyonight-moon"
      -- ["Your-GTK-Theme"] = "your-colorscheme"
    },
    config = function(_, opts)
      local hyde = require 'hyde_theme'
      hyde.setup(opts)
      local theme = hyde.detect_theme()
      vim.cmd.colorscheme(theme)
    end,
  },
}
