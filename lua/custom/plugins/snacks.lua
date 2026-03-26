return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = {
    'MunifTanjim/nui.nvim',

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- UI stuffs
    dashboard = { example = 'advanced' },
    indent = {
      chunk = { enabled = true },
    },
    notifier = {},
    statuscolumn = {},

    -- Picker and explorer
    explorer = {},
    picker = {
      sources = {
        explorer = {},
        gh_issue = {},
        gh_pr = {},
      },
    },

    -- Utilities
    scope = {},
    bigfile = {},
    input = {},
    quickfile = {},
    scroll = {},
    words = {},

    -- Git and Github
    gh = {},
    -- git = {},
    lazygit = {},

    -- Terminal
    terminal = {},
  },
  keys = {
    -- Search
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
      mode = { 'n', 'x' },
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch Recent Files ("." for repeat)',
    },
    {
      '<leader><leader>',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[ ] Find existing buffers',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.lines()
      end,
      desc = '[/] Fuzzily search in curent buffer',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = '[S]earch [/] in Open Buffers',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim Config',
    },
    {
      '<leader>sa',
      function()
        Snacks.picker.autocmds()
      end,
      desc = '[S]earch [A]utocmds',
    },
    {
      '<leader>sc',
      function()
        Snacks.picker.commands()
      end,
      desc = '[S]earch [C]ommands',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = '[S]earch [Q]uickfix List',
    },
    {
      '<C-t>',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit()
      end,
      desc = 'Open [L]azy[G]it',
    },
    {
      '<leader>gi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'Search [G]ithub [I]ssues',
    },
    {
      '<leader>gp',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'Search [G]ithub [P]R',
    },
    {
      '<leader>e',
      function()
        Snacks.explorer()
      end,
      desc = 'Toggle [E]xplorer',
    },
  },
}
