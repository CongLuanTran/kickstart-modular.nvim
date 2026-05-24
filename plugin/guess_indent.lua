vim.pack.add {
  'https://github.com/NMAC427/guess-indent.nvim',
}

require('guess-indent').setup {}

vim.keymap.set('n', '<leader>gi', function() require('guess-indent').set_indent() end, { desc = 'Guess indent' })
