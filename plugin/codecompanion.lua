vim.pack.add {
  'https://www.github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  {
    src = 'https://www.github.com/olimorris/codecompanion.nvim',
    version = vim.version.range '^19.0.0',
  },
}

require('codecompanion').setup {
  interactions = {
    cli = {
      agent = 'copilot',
      agents = {
        copilot = {
          cmd = 'copilot',
          args = {},
          description = 'Copilot CLI',
          provider = 'terminal',
        },
      },
    },
  },
}
