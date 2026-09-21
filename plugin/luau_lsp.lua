vim.pack.add {
  'https://github.com/lopi-py/luau-lsp.nvim',
}

require('luau-lsp').setup {
  platform = {
    type = 'standard',
  },
  sourcemap = {
    enable = false,
  },
  types = {
    definition_files = {
      noctalia = 'noctalia.d.luau',
    },
  },
}
