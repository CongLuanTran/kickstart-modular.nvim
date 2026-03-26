return {
  'chomosuke/typst-preview.nvim',
  ft = 'typst',
  version = '1.*',
  opts = {
    open_cmd = 'firefox %s -P typst-preview --class typst-preview',
  }, -- lazy.nvim will implicitly calls `setup {}`
}
