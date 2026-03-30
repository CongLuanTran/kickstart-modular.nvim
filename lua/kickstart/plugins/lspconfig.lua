-- LSP Plugins

return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'snacks' } },
      },
    },
  },
  { 'b0o/schemastore.nvim' },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          Snacks.keymap.set('n', 'grn', vim.lsp.buf.rename, {
            lsp = { method = 'textDocument/rename' },
            desc = '[R]e[n]ame',
          })

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          Snacks.keymap.set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, {
            lsp = { method = 'textDocument/codeAction' },
            desc = '[G]oto Code [A]ction',
          })

          -- Find references for the word under your cursor.
          Snacks.keymap.set('n', 'grr', Snacks.picker.lsp_references, {
            lsp = { method = 'textDocument/references' },
            desc = '[G]oto [R]eferences',
          })

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          Snacks.keymap.set('n', 'gri', Snacks.picker.lsp_implementations, {
            lsp = { method = 'textDocument/implementation' },
            desc = '[G]oto [I]mplementation',
          })

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          Snacks.keymap.set('n', 'grd', Snacks.picker.lsp_definitions, {
            lsp = { method = 'textDocument/definition' },
            desc = '[G]oto [D]efinition',
          })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          Snacks.keymap.set('n', 'grD', Snacks.picker.lsp_declarations, {
            lsp = { method = 'textDocument/declaration' },
            desc = '[G]oto [D]eclaration',
          })

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          Snacks.keymap.set('n', 'gO', Snacks.picker.lsp_symbols, {
            lsp = { method = 'textDocument/documentSymbol' },
            desc = 'Open Document Symbols',
          })

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          Snacks.keymap.set('n', 'gW', Snacks.picker.lsp_workspace_symbols, {
            lsp = { method = 'workspace/symbol' },
            desc = 'Open Workspace Symbols',
          })

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          Snacks.keymap.set('n', 'grt', Snacks.picker.lsp_type_definitions, {
            lsp = { method = 'textDocument/typeDefinition' },
            desc = '[G]oto [T]ype Definition',
          })

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
              buffer = event.buf,
              desc = 'Highlight references under the cursor',
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'InsertEnter', 'BufLeave' }, {
              buffer = event.buf,
              desc = 'Clear highlight references',
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- Disable hover capacity from Rust
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end,
        desc = 'LSP: Disable hover capability from Ruff',
      })

      local servers = {
        lua_ls = {},
        bashls = {
          filetypes = { 'bash', 'sh', 'zsh' },
        },
        vtsls = {},
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true,
              analysis = {
                typeCheckingMode = 'basic',
              },
            },
          },
        },
        bacon_ls = {},
        ruff = {},
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        html = {},
        cssls = {},
        vimls = {},
        marksman = {},
        tombi = {},
        yamlls = {},
        jdtls = {},
        emmet_language_server = {},
        tailwindcss = {},
        harper_ls = {
          settings = {
            ['harper-ls'] = {
              dialect = 'British',
            },
          },
        },
        tinymist = {
          settings = {
            formatterMode = 'typstyle',
            formatterProseWrap = true,
            formatterPrintWidth = 80,
          },
        },
        denols = {},
        oxlint = {},
        oxfmt = {},
      }

      -- Config and enable server configs
      for name, cfg in pairs(servers) do
        if cfg then
          vim.lsp.config(name, cfg)
        end
        vim.lsp.enable(name)
      end

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = true },
        underline = true,
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = true,
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
