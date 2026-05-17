vim.pack.add {
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-neotest/neotest-python',
  'https://github.com/nvim-neotest/neotest-plenary',
  'https://github.com/nvim-neotest/neotest-vim-test',
  {
    src = 'https://github.com/mrcjkb/rustaceanvim',
    -- To avoid being surprised by breaking changes,
    -- I recommend you set a version range
    version = vim.version.range '^9',
  },
}

---@diagnostic disable: missing-fields
require('neotest').setup {
  adapters = {
    require 'neotest-python' {
      dap = { justMyCode = false },
      pytest_discover_instances = true,
    },
    require 'neotest-plenary',
    require 'neotest-vim-test' {
      ignore_file_types = { 'python', 'vim', 'lua' },
    },
    require 'rustaceanvim.neotest',
  },
}
