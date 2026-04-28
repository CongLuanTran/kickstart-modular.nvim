return {
  'neovim/nvim-lspconfig',
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp_attach_markdown_oxide', { clear = true }),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client == nil then return end
        if client.name == 'markdown_oxide' then
          vim.api.nvim_create_user_command('Daily', function(args)
            local input = args.args
            client:exec_cmd { title = 'Daily note', command = 'jump', arguments = { input } }
          end, { desc = 'Open daily note', nargs = '*' })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    vim.lsp.config('markdown_oxide', {
      capabilities = vim.tbl_deep_extend('force', capabilities, {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      }),
    })

    vim.lsp.enable 'markdown_oxide'
  end,
}
