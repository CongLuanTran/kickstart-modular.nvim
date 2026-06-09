vim.pack.add {
  'https://github.com/folke/ts-comments.nvim',
}

---@diagnostic disable: missing-fields
require('ts-comments').setup {}
