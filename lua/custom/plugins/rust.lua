return {
  {
    'mrcjkb/rustaceanvim',
    version = '^8', -- Recommended
    lazy = false, -- This plugin is already lazy
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set('n', 'gra', function() vim.cmd.RustLsp 'codeAction' end, { desc = '[G]oto Code [A]ction', buffer = bufnr, silent = true })
          vim.keymap.set('n', 'K', function() vim.cmd.RustLsp { 'hover', 'actions' } end, { silent = true, buffer = bufnr })
        end,
        default_settings = {
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
    config = function(_, opts) vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {}) end,
  },
  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
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
    },
  },
}
