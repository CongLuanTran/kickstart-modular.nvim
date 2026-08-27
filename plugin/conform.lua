vim.pack.add {
  'https://github.com/stevearc/conform.nvim',
}

local conform = require 'conform'

conform.setup {
  notify_on_error = false,
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    -- rust = { 'rustfmt' },
    python = {
      -- fix auto-fixable
      'ruff_fix',
      -- run formatter
      'ruff_format',
      -- organize imports
      'ruff_organize_imports',
    },
    -- Conform can also run multiple formatters sequentially
    -- python = { "isort", "black" },
    --
    javascript = { 'oxfmt' },
    javascriptreact = { 'oxfmt' },
    typescript = { 'oxfmt' },
    typescriptreact = { 'oxfmt' },
    json = { 'oxfmt' },
    vue = { 'oxfmt' },
    markdown = { 'prettierd', 'prettier', stop_after_first = true },
    terraform = { 'terraform_fmt' },
    dockerfile = { 'dockerfmt' },
  },
}

vim.keymap.set('n', '<leader>f', function()
  conform.format {
    async = true,
    lsp_format = 'fallback',
  }
end, { desc = '[F]ormat buffer' })

-- vim: ts=2 sts=2 sw=2 et
