vim.pack.add {
  'https://github.com/folke/snacks.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

if vim.g.have_nerd_font then
  vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons' }
  require('nvim-web-devicons').setup {}
end

Snacks.setup {
  -- UI stuffs
  dashboard = {
    sections = {
      { section = 'header' },
      {
        pane = 2,
        section = 'terminal',
        cmd = 'colorscript -e square',
        height = 5,
        padding = 1,
      },
      { section = 'keys', gap = 1, padding = 1 },
      { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
      { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
      {
        pane = 2,
        icon = ' ',
        title = 'Git Status',
        section = 'terminal',
        enabled = function() return Snacks.git.get_root() ~= nil end,
        cmd = 'git status --short --branch --renames',
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
    },
  },
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
}

Snacks.toggle.indent():map '<leader>u|'
Snacks.toggle.line_number():map '<leader>ul'
Snacks.toggle.diagnostics():map '<leader>ud'
Snacks.toggle.inlay_hints():map '<leader>uh'
Snacks.toggle.zen():map '<leader>uz'
Snacks.toggle.zoom():map '<leader>uZ'
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

local map = Snacks.keymap.set

-- Rename the variable under your cursor.
--  Most Language Servers support renaming across files, etc.
map('n', 'grn', vim.lsp.buf.rename, {
  lsp = { method = 'textDocument/rename' },
  desc = '[R]e[n]ame',
})

-- Execute a code action, usually your cursor needs to be on top of an error
-- or a suggestion from your LSP for this to activate.
map({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, {
  lsp = { method = 'textDocument/codeAction' },
  desc = '[G]oto Code [A]ction',
})

-- Use Codelens
map('n', 'grx', vim.lsp.codelens.run, {
  lsp = { method = 'textDocument/codeLens' },
  desc = '[G]o E[x]ecute CodeLens',
})

-- Find references for the word under your cursor.
map('n', 'grr', Snacks.picker.lsp_references, {
  lsp = { method = 'textDocument/references' },
  desc = '[G]oto [R]eferences',
})

-- Jump to the implementation of the word under your cursor.
--  Useful when your language has ways of declaring types without an actual implementation.
map('n', 'gri', Snacks.picker.lsp_implementations, {
  lsp = { method = 'textDocument/implementation' },
  desc = '[G]oto [I]mplementation',
})

-- Jump to the definition of the word under your cursor.
--  This is where a variable was first declared, or where a function is defined, etc.
--  To jump back, press <C-t>.
map('n', 'grd', Snacks.picker.lsp_definitions, {
  lsp = { method = 'textDocument/definition' },
  desc = '[G]oto [D]efinition',
})

-- WARN: This is not Goto Definition, this is Goto Declaration.
--  For example, in C this would take you to the header.
map('n', 'grD', Snacks.picker.lsp_declarations, {
  lsp = { method = 'textDocument/declaration' },
  desc = '[G]oto [D]eclaration',
})

-- Fuzzy find all the symbols in your current document.
--  Symbols are things like variables, functions, types, etc.
map('n', 'gO', Snacks.picker.lsp_symbols, {
  lsp = { method = 'textDocument/documentSymbol' },
  desc = 'Open Document Symbols',
})

-- Fuzzy find all the symbols in your current workspace.
--  Similar to document symbols, except searches over your entire project.
map('n', 'gW', Snacks.picker.lsp_workspace_symbols, {
  lsp = { method = 'workspace/symbol' },
  desc = 'Open Workspace Symbols',
})

-- Jump to the type of the word under your cursor.
--  Useful when you're not sure what type a variable is and you want to see
--  the definition of its *type*, not where it was *defined*.
map('n', 'grt', Snacks.picker.lsp_type_definitions, {
  lsp = { method = 'textDocument/typeDefinition' },
  desc = '[G]oto [T]ype Definition',
})

-- Search
map('n', '<leader>sh', function() Snacks.picker.help() end, {
  desc = '[S]earch [H]elp',
})
map('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sf', function() Snacks.picker.files() end, { desc = '[S]earch [F]iles' })
map({ 'n', 'x' }, '<leader>sw', function() Snacks.picker.grep_word() end, { desc = '[S]earch current [W]ord' })
map('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', function() Snacks.picker.recent() end, { desc = '[S]earch Recent Files ("." for repeat)' })
map('n', '<leader><leader>', function() Snacks.picker.buffers() end, { desc = '[ ] Find existing buffers' })
map('n', '<leader>/', function() Snacks.picker.lines() end, { desc = '[/] Fuzzily search in curent buffer' })
map('n', '<leader>s/', function() Snacks.picker.grep_buffers() end, { desc = '[S]earch [/] in Open Buffers' })
map('n', '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim Config' })
map('n', '<leader>sa', function() Snacks.picker.autocmds() end, { desc = '[S]earch [A]utocmds' })
map('n', 'fleader>sc', function() Snacks.picker.commands() end, { desc = '[S]earch [C]ommands' })
map('n', '<leader>sq', function() Snacks.picker.qflist() end, { desc = '[S]earch [Q]uickfix List' })
map('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = '[S]earch [M]arks' })
-- Terminal
map('n', '<C-t>', function() Snacks.terminal() end, { desc = 'Toggle Terminal' })
-- Git
map('n', '<leader>gl', function() Snacks.lazygit() end, { desc = 'Open [L]azy[G]it' })
map('n', '<leader>gi', function() Snacks.picker.gh_issue() end, { desc = 'Search [G]ithub [I]ssues' })
map('n', '<leader>gp', function() Snacks.picker.gh_pr() end, { desc = 'Search [G]ithub [P]R' })
-- Explorer
map('n', '<leader>E', function() Snacks.explorer { cwd = vim.fn.expand '%:p:h' } end, { desc = 'Toggle [E]xplorer at cwd' })
map('n', '<leader>e', function()
  local function find_root()
    local bufnr = vim.api.nvim_get_current_buf()

    local clients = vim.lsp.get_clients { bufnr = bufnr }

    for _, client in ipairs(clients) do
      if client.name ~= 'copilot' then
        local ws = client.workspace_folders

        if ws and #ws > 0 then
          local root = vim.uri_to_fname(ws[1].uri)
          if root and root ~= '' then return root end
        end

        if client.root_dir and client.root_dir ~= '' then return client.root_dir end
      end
    end

    local path = vim.api.nvim_buf_get_name(bufnr)

    if path ~= '' then
      path = vim.fn.fnamemodify(path, ':p:h')
      local git = vim.fs.find('.git', { path = path, upward = true })[1]

      return git and vim.fs.dirname(git) or path
    end

    return vim.uv.cwd()
  end

  Snacks.explorer { cwd = find_root() }
end, {
  desc = 'Toggle [E]xplorer at root',
})
