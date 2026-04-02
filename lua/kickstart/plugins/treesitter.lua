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
}
return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    lazy = false,
    config = function()
      -- replicate `ensure_installed`, runs asynchronously, skips existing languages
      require('nvim-treesitter').install(ensure_installed)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter.setup', {}),
        callback = function(args)
          local buf = args.buf
          local filetype = args.match

          -- you need some mechanism to avoid running on buffers that do not
          -- correspond to a language (like oil.nvim buffers), this implementation
          -- checks if a parser exists for the current language
          local language = vim.treesitter.language.get_lang(filetype) or filetype
          if not vim.treesitter.language.add(language) then
            return
          end

          -- replicate `fold = { enable = true }`
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

          -- replicate `highlight = { enable = true }`
          vim.treesitter.start(buf, language)

          -- replicate `indent = { enable = true }`
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- `incremental_selection = { enable = true }` covered by 0.12.0
        end,
      })
    end,
    -- opts = {
    --   indent = { enable = true, disable = { 'ruby', 'lua', 'yaml' } },
    --   textobjects = {
    --     select = {
    --       enable = true,
    --       lookahead = true,
    --       keymaps = {
    --         ['ak'] = { query = '@block.outer', desc = 'around block' },
    --         ['ik'] = { query = '@block.inner', desc = 'inside block' },
    --         ['ac'] = { query = '@class.outer', desc = 'around class' },
    --         ['ic'] = { query = '@class.inner', desc = 'inside class' },
    --         ['a?'] = { query = '@conditional.outer', desc = 'around conditional' },
    --         ['i?'] = { query = '@conditional.inner', desc = 'inside conditional' },
    --         ['af'] = { query = '@function.outer', desc = 'around function ' },
    --         ['if'] = { query = '@function.inner', desc = 'inside function ' },
    --         ['ao'] = { query = '@loop.outer', desc = 'around loop' },
    --         ['io'] = { query = '@loop.inner', desc = 'inside loop' },
    --         ['aa'] = { query = '@parameter.outer', desc = 'around argument' },
    --         ['ia'] = { query = '@parameter.inner', desc = 'inside argument' },
    --       },
    --     },
    --     move = {
    --       enable = true,
    --       set_jumps = true,
    --       goto_next_start = {
    --         [']k'] = { query = '@block.outer', desc = 'Next block start' },
    --         [']f'] = { query = '@function.outer', desc = 'Next function start' },
    --         [']a'] = { query = '@parameter.inner', desc = 'Next argument start' },
    --       },
    --       goto_next_end = {
    --         [']K'] = { query = '@block.outer', desc = 'Next block end' },
    --         [']F'] = { query = '@function.outer', desc = 'Next function end' },
    --         [']A'] = { query = '@parameter.inner', desc = 'Next argument end' },
    --       },
    --       goto_previous_start = {
    --         ['[k'] = { query = '@block.outer', desc = 'Previous block start' },
    --         ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
    --         ['[a'] = { query = '@parameter.inner', desc = 'Previous argument start' },
    --       },
    --       goto_previous_end = {
    --         ['[K'] = { query = '@block.outer', desc = 'Previous block end' },
    --         ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
    --         ['[A'] = { query = '@parameter.inner', desc = 'Previous argument end' },
    --       },
    --     },
    --     swap = {
    --       enable = true,
    --       swap_next = {
    --         ['>K'] = { query = '@block.outer', desc = 'Swap next block' },
    --         ['>F'] = { query = '@function.outer', desc = 'Swap next function' },
    --         ['>A'] = { query = '@parameter.inner', desc = 'Swap next argument' },
    --       },
    --       swap_previous = {
    --         ['<K'] = { query = '@block.outer', desc = 'Swap previous block' },
    --         ['<F'] = { query = '@function.outer', desc = 'Swap previous function' },
    --         ['<A'] = { query = '@parameter.inner', desc = 'Swap previous argument' },
    --       },
    --     },
    --   },
    -- },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      -- configuration
      require('nvim-treesitter-textobjects').setup {
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      }

      -- Select keymaps
      vim.keymap.set({ 'x', 'o' }, 'af', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
      end, { desc = 'around function' })
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
      end, { desc = 'inside function' })
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
      end, { desc = 'around class' })
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
      end, { desc = 'inside class' })
      vim.keymap.set({ 'x', 'o' }, 'ak', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@block.outer', 'textobjects')
      end, { desc = 'around block' })
      vim.keymap.set({ 'x', 'o' }, 'ik', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@block.inner', 'textobjects')
      end, { desc = 'inside block' })
      vim.keymap.set({ 'x', 'o' }, 'ao', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@loop.outer', 'textobjects')
      end, { desc = 'around loop' })
      vim.keymap.set({ 'x', 'o' }, 'io', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@loop.inner', 'textobjects')
      end, { desc = 'inside loop' })
      vim.keymap.set({ 'x', 'o' }, 'aa', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects')
      end, { desc = 'around argument' })
      vim.keymap.set({ 'x', 'o' }, 'ia', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects')
      end, { desc = 'inside argument' })
      vim.keymap.set({ 'x', 'o' }, 'a?', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@conditional.outer', 'textobjects')
      end, { desc = 'around conditional' })
      vim.keymap.set({ 'x', 'o' }, 'i?', function()
        require('nvim-treesitter-textobjects.select').select_textobject('@conditional.inner', 'textobjects')
      end, { desc = 'inside conditional' })

      -- Move keymaps
      -- Next start
      vim.keymap.set({ 'n', 'x', 'o' }, ']k', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@block.outer', 'textobjects')
      end, { desc = 'Next block start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']a', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects')
      end, { desc = 'Next argument start' })
      -- Next end
      vim.keymap.set({ 'n', 'x', 'o' }, ']K', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@block.outer', 'textobjects')
      end, { desc = 'Next block start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end, { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']A', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects')
      end, { desc = 'Next argument start' })
      -- Previous start
      vim.keymap.set({ 'n', 'x', 'o' }, '[k', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@block.outer', 'textobjects')
      end, { desc = 'Next block start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end, { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[a', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects')
      end, { desc = 'Next argument start' })
      -- Next end
      vim.keymap.set({ 'n', 'x', 'o' }, '[K', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@block.outer', 'textobjects')
      end, { desc = 'Next block start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end, { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[A', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects')
      end, { desc = 'Next argument start' })

      -- Swap keymaps
      vim.keymap.set('n', '>K', function()
        require('nvim-treesitter-textobjects.swap').swap_next '@block.outer'
      end, { desc = 'Swap next block' })
      vim.keymap.set('n', '>F', function()
        require('nvim-treesitter-textobjects.swap').swap_next '@function.outer'
      end, { desc = 'Swap next function' })
      vim.keymap.set('n', '>A', function()
        require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
      end, { desc = 'Swap next argument' })
      vim.keymap.set('n', '<K', function()
        require('nvim-treesitter-textobjects.swap').swap_previous '@block.outer'
      end, { desc = 'Swap previous block' })
      vim.keymap.set('n', '<F', function()
        require('nvim-treesitter-textobjects.swap').swap_previous '@function.outer'
      end, { desc = 'Swap previous function' })
      vim.keymap.set('n', '<A', function()
        require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner'
      end, { desc = 'Swap previous argument' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
