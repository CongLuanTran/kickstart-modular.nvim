-- Emacs emulator in Insert mode
local function map(key, action, desc)
  vim.keymap.set('i', key, action, {
    noremap = true,
    silent = true,
    desc = desc,
  })
end

---- Movement
-- Characters
map('<C-f>', '<Right>', 'Move forward one character')
map('<C-b>', '<Left>', 'Move backward one character')
map('<C-d>', '<C-o>dl', 'Delete forward one character')
-- Words
map('<M-f>', '<C-Right>', 'Move forward one word')
map('<M-b>', '<C-Left>', 'Move backward one word')
map('<M-d>', '<C-o>de', 'Delete forward one word')
map('<M-BS>', '<C-o>db', 'Delete backward one word')
-- Lines
map('<C-n>', '<Down>', 'Move forward one line')
map('<C-p>', '<Up>', 'Move backward one line')
map('<C-e>', '<End>', 'Move to end of line')
map('<C-a>', '<Home>', 'Move to start of line')
-- Sentence
map('<M-e>', '<C-o>)', 'Move forward one sentence')
map('<M-a>', '<C-o>(', 'Move backward one sentence')
-- Paragraphs
map('<M-}>', '<C-o>}', 'Move forward one paragraphs')
map('<M-{>', '<C-o>{', 'Move backward one paragraphs')
-- Buffer
map('<M->>', '<C-o>gg', 'Move to end of buffer')
map('<M-<>', '<C-o>G', 'Move to start of buffer')
-- vim: ts=2 sts=2 sw=2 et
