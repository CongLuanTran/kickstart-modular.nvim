vim.pack.add {
  'https://github.com/3rd/image.nvim',
  'https://github.com/folke/snacks.nvim',
}

local image = require 'image'

---@diagnostic disable: missing-fields
image.setup {
  processor = 'magick_cli',
}

image.disable()

Snacks.toggle
  .new({
    id = 'image toggle',
    name = 'Image',
    get = image.is_enabled,
    set = function(state)
      if state then
        image.enable()
      else
        image.disable()
      end
    end,
  })
  :map '<leader>tI'
