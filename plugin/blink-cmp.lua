vim.pack.add {
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://git.barrettruth.com/barrettruth/blink-cmp-ghostty.git',
  'https://github.com/disrupted/blink-cmp-conventional-commits',
  'https://github.com/archie-judd/blink-cmp-words',
  'https://github.com/folke/lazydev.nvim',
}
local cmp = require 'blink.cmp'
--- @diagnostic disable: undefined-field
cmp.build():wait(60000)
cmp.setup {
  keymap = {
    -- 'default' (recommended) for mappings similar to built-in completions
    --   <c-y> to accept ([y]es) the completion.
    --    This will auto-import if your LSP supports it.
    --    This will expand snippets if the LSP sent a snippet.
    -- 'super-tab' for tab to accept
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- For an understanding of why the 'default' preset is recommended,
    -- you will need to read `:help ins-completion`
    --
    -- No, but seriously. Please read `:help ins-completion`, it is really good!
    --
    -- All presets have the following mappings:
    -- <tab>/<s-tab>: move to right/left of your snippet expansion
    -- <c-space>: Open menu or open docs if already open
    -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
    -- <c-e>: Hide menu
    -- <c-k>: Toggle signature help
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    preset = 'enter',
    ['<C-Space>'] = false,
    ['<C-k>'] = false,
    ["<C-'>"] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-s>'] = { 'show_signature', 'hide_signature' },

    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },

  completion = {
    -- By default, you may press `<c-space>` to show the documentation.
    -- Optionally, set `auto_show = true` to show the documentation after a delay.
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },

  sources = {
    default = { 'lsp', 'snippets', 'path' },
    per_filetype = {
      lua = { inherit_defaults = true, 'lazydev' },
      ghostty = { 'ghostty' },
      gitcommit = { 'conventional_commits' },
      -- text = { 'dictionary' },
      -- markdown = { 'thesaurus' },
    },
    providers = {
      lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
      ghostty = { name = 'Ghostty', module = 'blink-cmp-ghostty' },
      conventional_commits = {
        name = 'Conventional Commits',
        module = 'blink-cmp-conventional-commits',
        opts = {},
      },
      -- Use the thesaurus source
      thesaurus = {
        name = 'blink-cmp-words',
        module = 'blink-cmp-words.thesaurus',
        -- All available options
        opts = {
          -- A score offset applied to returned items.
          -- By default the highest score is 0 (item 1 has a score of -1, item 2 of -2 etc..).
          score_offset = 0,

          -- Default pointers define the lexical relations listed under each definition,
          -- see Pointer Symbols below.
          -- Default is as below ("antonyms", "similar to" and "also see").
          definition_pointers = { '!', '&', '^' },

          -- The pointers that are considered similar words when using the thesaurus,
          -- see Pointer Symbols below.
          -- Default is as below ("similar to", "also see" }
          similarity_pointers = { '&', '^' },

          -- The depth of similar words to recurse when collecting synonyms. 1 is similar words,
          -- 2 is similar words of similar words, etc. Increasing this may slow results.
          similarity_depth = 2,
        },
      },

      -- Use the dictionary source
      dictionary = {
        name = 'blink-cmp-words',
        module = 'blink-cmp-words.dictionary',
        -- All available options
        opts = {
          -- The number of characters required to trigger completion.
          -- Set this higher if completion is slow, 3 is default.
          dictionary_search_threshold = 3,

          -- See above
          score_offset = 0,

          -- See above
          definition_pointers = { '!', '&', '^' },
        },
      },
    },
  },

  -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
  -- which automatically downloads a prebuilt binary when enabled.
  --
  -- By default, we use the Lua implementation instead, but you may enable
  -- the rust implementation via `'prefer_rust_with_warning'`
  --
  -- See :h blink-cmp-config-fuzzy for more information
  fuzzy = { implementation = 'prefer_rust_with_warning' },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}

-- vim: ts=2 sts=2 sw=2 et
