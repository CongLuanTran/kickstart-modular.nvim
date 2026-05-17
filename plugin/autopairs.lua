vim.pack.add {
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/windwp/nvim-ts-autotag',
}
require('nvim-autopairs').setup {
  fast_warp = {},
}
require('nvim-ts-autotag').setup()

-- vim: ts=2 sts=2 sw=2 et
