return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    lazy = false,
    config = function()
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
      require('nvim-treesitter').install(ensure_installed)

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

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf = args.buf
          local filetype = args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    init = function() vim.g.no_plugin_maps = true end,
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
      vim.keymap.set(
        { 'x', 'o' },
        'af',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end,
        { desc = 'around function' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'if',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end,
        { desc = 'inside function' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'ac',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,
        { desc = 'around class' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'ic',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,
        { desc = 'inside class' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'ak',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@block.outer', 'textobjects') end,
        { desc = 'around block' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'ik',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@block.inner', 'textobjects') end,
        { desc = 'inside block' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'ao',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@loop.outer', 'textobjects') end,
        { desc = 'around loop' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'io',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@loop.inner', 'textobjects') end,
        { desc = 'inside loop' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'aa',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects') end,
        { desc = 'around argument' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'ia',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects') end,
        { desc = 'inside argument' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'a?',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@conditional.outer', 'textobjects') end,
        { desc = 'around conditional' }
      )
      vim.keymap.set(
        { 'x', 'o' },
        'i?',
        function() require('nvim-treesitter-textobjects.select').select_textobject('@conditional.inner', 'textobjects') end,
        { desc = 'inside conditional' }
      )

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
      vim.keymap.set(
        'n',
        '<A',
        function() require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner' end,
        { desc = 'Swap previous argument' }
      )
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
