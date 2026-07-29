vim.pack.add {
  'https://github.com/OXY2DEV/markview.nvim',
}

local spec = require 'markview.spec'
table.insert(spec.config.preview.filetypes, 'codecompanion')
