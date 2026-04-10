return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>g', group = '[G]it' },
        { '<leader>u', group = '[U]I' },
        { '<leader>n', group = '[N]oice' },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
