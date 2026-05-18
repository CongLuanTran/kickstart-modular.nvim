vim.pack.add {
  'https://github.com/zbirenbaum/copilot.lua',
  'https://github.com/copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
  'https://github.com/folke/snacks.nvim',
}

require('copilot').setup {
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = '<C-l>',
    },
  },
}

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuOpen',
  callback = function() vim.b.copilot_suggestion_hidden = true end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuClose',
  callback = function() vim.b.copilot_suggestion_hidden = false end,
})
