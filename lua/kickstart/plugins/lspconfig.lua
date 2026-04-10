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
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
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
          local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          if client:supports_method('textDocument/documentHighlight', event.buf) then
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

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      -- Disable hover capacity from Rust
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then return end
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
        tinymist = {
          settings = {
            formatterMode = 'typstyle',
            formatterProseWrap = true,
            formatterPrintWidth = 80,
          },
        },
        denols = {},
        oxlint = {},
      }

      -- I have a feeling that this will be buggy
      -- But let's see how it goes
      vim.lsp.config('harper_ls', {
        settings = {
          ['harper-ls'] = {
            dialect = 'British',
          },
        },
      })

      Snacks.toggle
        .new({
          id = 'harper_global',
          name = 'Global Harper',
          get = function() return vim.lsp.is_enabled 'harper_ls' end,
          set = function(state)
            -- global autoattach switch
            vim.lsp.enable('harper_ls', state)

            -- if turning OFF, also remove all existing local/manual attachments
            if not state then
              for _, client in ipairs(vim.lsp.get_clients { name = 'harper_ls' }) do
                for bufnr in pairs(client.attached_buffers or {}) do
                  vim.lsp.buf_detach_client(bufnr, client.id)
                end
                client:stop()
              end
            end
          end,
        })
        :map '<leader>tH'

      Snacks.toggle
        .new({
          id = 'harper_local',
          name = 'Local Harper',
          get = function()
            if not vim.lsp.is_enabled 'harper_ls' then return false end

            return #vim.lsp.get_clients {
              bufnr = 0,
              name = 'harper_ls',
            } > 0
          end,
          set = function(state)
            local bufnr = vim.api.nvim_get_current_buf()

            local clients = vim.lsp.get_clients {
              bufnr = bufnr,
              name = 'harper_ls',
            }

            if state then
              if #clients == 0 then vim.lsp.start(vim.tbl_extend('force', vim.lsp.config.harper_ls, { bufnr = bufnr })) end
            else
              for _, client in ipairs(clients) do
                vim.lsp.buf_detach_client(bufnr, client.id)
              end
            end
          end,
        })
        :map '<leader>th'

      -- Config and enable server configs
      for name, cfg in pairs(servers) do
        if cfg then vim.lsp.config(name, cfg) end
        vim.lsp.enable(name)
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
