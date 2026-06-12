vim.pack.add {
  {
    src = 'https://github.com/rose-pine/neovim',
    name = 'rose-pine',
  },
}
require('rose-pine').setup {
  highlight_groups = {
    GitSignsStagedAdd = { fg = 'iris' },
    GitSignsStagedChange = { link = 'GitSignsStagedAdd' },
    GitSignsStagedDelete = { link = 'GitSignsStagedAdd' },
    SnacksPickerGitStatusModified = { fg = 'rose' },
    SnacksPickerGitStatusAdd = { fg = 'pine' },
    SnacksPickerGitStatusDelete = { fg = 'love' },
  },
}
