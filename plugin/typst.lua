vim.pack.add {
  'https://github.com/chomosuke/typst-preview.nvim',
}

require('typst-preview').setup {
  open_cmd = 'firefox %s -P typst-preview',
}
