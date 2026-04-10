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
    toggle = {},
    win = {},
    layout = {},
    zen = {},

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
  config = function(_, opts)
    Snacks.setup(opts)
    Snacks.toggle.indent():map '<leader>u|'
    Snacks.toggle.line_number():map '<leader>ul'
    Snacks.toggle.diagnostics():map '<leader>ud'
    Snacks.toggle.inlay_hints():map '<leader>uh'
    Snacks.toggle.zen():map '<leader>uz'
    Snacks.toggle.zoom():map '<leader>uZ'

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
  end,

  keys = {
    -- Search
    { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[S]earch [K]eymaps' },
    { '<leader>sf', function() Snacks.picker.files() end, desc = '[S]earch [F]iles' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = '[S]earch current [W]ord', mode = { 'n', 'x' } },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = '[S]earch by [G]rep' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
    { '<leader>s.', function() Snacks.picker.recent() end, desc = '[S]earch Recent Files ("." for repeat)' },
    { '<leader><leader>', function() Snacks.picker.buffers() end, desc = '[ ] Find existing buffers' },
    { '<leader>/', function() Snacks.picker.lines() end, desc = '[/] Fuzzily search in curent buffer' },
    { '<leader>s/', function() Snacks.picker.grep_buffers() end, desc = '[S]earch [/] in Open Buffers' },
    { '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = '[S]earch [N]eovim Config' },
    { '<leader>sa', function() Snacks.picker.autocmds() end, desc = '[S]earch [A]utocmds' },
    { '<leader>sc', function() Snacks.picker.commands() end, desc = '[S]earch [C]ommands' },
    { '<leader>sq', function() Snacks.picker.qflist() end, desc = '[S]earch [Q]uickfix List' },
    { '<C-t>', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
    { '<leader>gl', function() Snacks.lazygit() end, desc = 'Open [L]azy[G]it' },
    { '<leader>gi', function() Snacks.picker.gh_issue() end, desc = 'Search [G]ithub [I]ssues' },
    { '<leader>gp', function() Snacks.picker.gh_pr() end, desc = 'Search [G]ithub [P]R' },
    { '<leader>e', function() Snacks.explorer() end, desc = 'Toggle [E]xplorer' },
  },
}
