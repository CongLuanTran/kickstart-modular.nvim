vim.pack.add {
  {
    src = 'https://github.com/mrcjkb/rustaceanvim',
    -- To avoid being surprised by breaking changes,
    -- I recommend you set a version range
    version = vim.version.range '^9',
  },
  'https://github.com/Saecki/crates.nvim',
}

vim.g.rustaceanvim = {
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set('n', 'gra', function() vim.cmd.RustLsp 'codeAction' end, { desc = '[G]oto Code [A]ction', buffer = bufnr, silent = true })
      vim.keymap.set('n', 'K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, { silent = true, buffer = bufnr })
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = { enable = true },
        },
        checkOnSave = false,
        diagnostics = { enable = false },
        procMacro = { enable = true },
        files = {
          exclude = {
            '.direnv',
            '.git',
            '.jj',
            '.github',
            '.gitlab',
            'bin',
            'node_modules',
            'target',
            'venv',
            '.venv',
          },
          watcher = 'client',
        },
      },
    },
  },
}

local crates_loaded = false
vim.api.nvim_create_autocmd('BufRead', {
  pattern = 'Cargo.toml',
  callback = function()
    if crates_loaded then return end
    crates_loaded = true
    require('crates').setup {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    }
  end,
})
