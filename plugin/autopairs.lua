vim.pack.add {
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/windwp/nvim-ts-autotag',
}
require('nvim-autopairs').setup {
  fast_warp = {},
}
require('nvim-ts-autotag').setup()
