return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    lazy = false,
    dependencies = { { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = true } },
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    branch = "master",
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
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
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby', 'lua', 'yaml' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<cr>',
          node_incremental = '<cr>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['ak'] = { query = '@block.outer', desc = 'around block' },
            ['ik'] = { query = '@block.inner', desc = 'inside block' },
            ['ac'] = { query = '@class.outer', desc = 'around class' },
            ['ic'] = { query = '@class.inner', desc = 'inside class' },
            ['a?'] = { query = '@conditional.outer', desc = 'around conditional' },
            ['i?'] = { query = '@conditional.inner', desc = 'inside conditional' },
            ['af'] = { query = '@function.outer', desc = 'around function ' },
            ['if'] = { query = '@function.inner', desc = 'inside function ' },
            ['ao'] = { query = '@loop.outer', desc = 'around loop' },
            ['io'] = { query = '@loop.inner', desc = 'inside loop' },
            ['aa'] = { query = '@parameter.outer', desc = 'around argument' },
            ['ia'] = { query = '@parameter.inner', desc = 'inside argument' },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']k'] = { query = '@block.outer', desc = 'Next block start' },
            [']f'] = { query = '@function.outer', desc = 'Next function start' },
            [']a'] = { query = '@parameter.inner', desc = 'Next argument start' },
          },
          goto_next_end = {
            [']K'] = { query = '@block.outer', desc = 'Next block end' },
            [']F'] = { query = '@function.outer', desc = 'Next function end' },
            [']A'] = { query = '@parameter.inner', desc = 'Next argument end' },
          },
          goto_previous_start = {
            ['[k'] = { query = '@block.outer', desc = 'Previous block start' },
            ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
            ['[a'] = { query = '@parameter.inner', desc = 'Previous argument start' },
          },
          goto_previous_end = {
            ['[K'] = { query = '@block.outer', desc = 'Previous block end' },
            ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
            ['[A'] = { query = '@parameter.inner', desc = 'Previous argument end' },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['>K'] = { query = '@block.outer', desc = 'Swap next block' },
            ['>F'] = { query = '@function.outer', desc = 'Swap next function' },
            ['>A'] = { query = '@parameter.inner', desc = 'Swap next argument' },
          },
          swap_previous = {
            ['<K'] = { query = '@block.outer', desc = 'Swap previous block' },
            ['<F'] = { query = '@function.outer', desc = 'Swap previous function' },
            ['<A'] = { query = '@parameter.inner', desc = 'Swap previous argument' },
          },
        },
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
-- vim: ts=2 sts=2 sw=2 et
