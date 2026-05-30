vim.pack.add {
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
}

-- replicate `ensure_installed`, runs asynchronously, skips existing languages
local ensure_installed = {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
  'javascript',
  'typescript',
  'rust',
}

local ts = require 'nvim-treesitter'

ts.install(ensure_installed)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- check if parser exists and load it
  if not vim.treesitter.language.add(language) then return end
  -- enables syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- replicate `fold = { enable = true }`
  vim.wo.foldmethod = 'expr'
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

  -- replicate `indent = { enable = true }`
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

local available_parsers = ts.get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf = args.buf
    local filetype = args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = ts.get_installed 'parsers'
    if vim.tbl_contains(installed_parsers, language) then
      -- enable the parser if it is installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
      ts.install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})

require('nvim-treesitter-textobjects').setup {
  move = {
    set_jumps = true,
  },
}

-- Move keymaps
-- Next start
vim.keymap.set(
  { 'n', 'x', 'o' },
  ']k',
  function() require('nvim-treesitter-textobjects.move').goto_next_start('@block.outer', 'textobjects') end,
  { desc = 'Next block start' }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  ']f',
  function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end,
  { desc = 'Next function start' }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  ']a',
  function() require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects') end,
  { desc = 'Next argument start' }
)
-- Next end
vim.keymap.set(
  { 'n', 'x', 'o' },
  ']K',
  function() require('nvim-treesitter-textobjects.move').goto_next_end('@block.outer', 'textobjects') end,
  { desc = 'Next block start' }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  ']F',
  function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects') end,
  { desc = 'Next function start' }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  ']A',
  function() require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects') end,
  { desc = 'Next argument start' }
)
-- Previous start
vim.keymap.set(
  { 'n', 'x', 'o' },
  '[k',
  function() require('nvim-treesitter-textobjects.move').goto_previous_start('@block.outer', 'textobjects') end,
  { desc = 'Next block start' }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  '[f',
  function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') end,
  { desc = 'Next function start' }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  '[a',
  function() require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects') end,
  { desc = 'Next argument start' }
)
-- Next end
vim.keymap.set(
  { 'n', 'x', 'o' },
  '[K',
  function() require('nvim-treesitter-textobjects.move').goto_previous_end('@block.outer', 'textobjects') end,
  { desc = 'Next block start' }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  '[F',
  function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects') end,
  { desc = 'Next function start' }
)
vim.keymap.set(
  { 'n', 'x', 'o' },
  '[A',
  function() require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects') end,
  { desc = 'Next argument start' }
)

-- Swap keymaps
vim.keymap.set('n', '>K', function() require('nvim-treesitter-textobjects.swap').swap_next '@block.outer' end, { desc = 'Swap next block' })
vim.keymap.set('n', '>F', function() require('nvim-treesitter-textobjects.swap').swap_next '@function.outer' end, { desc = 'Swap next function' })
vim.keymap.set('n', '>A', function() require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner' end, { desc = 'Swap next argument' })
vim.keymap.set('n', '<K', function() require('nvim-treesitter-textobjects.swap').swap_previous '@block.outer' end, { desc = 'Swap previous block' })
vim.keymap.set('n', '<F', function() require('nvim-treesitter-textobjects.swap').swap_previous '@function.outer' end, { desc = 'Swap previous function' })
vim.keymap.set('n', '<A', function() require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner' end, { desc = 'Swap previous argument' })

-- vim: ts=2 sts=2 sw=2 et
