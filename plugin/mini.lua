vim.pack.add {
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
}

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
local ts = require('mini.ai').gen_spec.treesitter
require('mini.ai').setup {
  custom_textobjects = {
    F = ts { a = '@function.outer', i = '@function.inner' },
    k = ts { a = '@block.outer', i = '@block.inner' },
    d = ts { a = '@conditional.outer', i = '@conditional.inner' },
  },
  mappings = {
    around_next = '',
    inside_next = '',
    around_last = '',
    inside_last = '',
  },
  n_lines = 500,
}

require('mini.git').setup {}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

-- Align text
require('mini.align').setup()

-- Better comment
require('mini.comment').setup()

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require 'mini.statusline'
-- set use_icons to true if you have a Nerd Font
statusline.setup { use_icons = true }
vim.o.cmdheight = 0

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end

-- ... and there is more!
--  Check out: https://github.com/nvim-mini/mini.nvim

-- vim: ts=2 sts=2 sw=2 et
