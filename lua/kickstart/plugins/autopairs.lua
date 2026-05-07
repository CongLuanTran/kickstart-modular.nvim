-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      fast_wrap = {},
    },
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    opts = {},
  },
}
