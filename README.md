# buffer-marks.nvim

A very simple buffer pinning system inspired by the inbuilt Global Marks, but
instead of always retuning you to the location in the buffer where you placed
your mark, it will return you to your last cursor position. By default, it uses
your `<leader>` key, so local and global mark behavior is left in place.

## Behavior

Overall, the behavior is very similar to Harpoon or other similar plugins,
however instead of having to predefine keys that can be assigned to your
buffer, you can use any lower or upper case letter character, or numerical
character `[a-zA-Z0-9]`. So how you choose to arrange your marks is up to you
on the fly, whether it's pneumonic, in order on your home-row, etc. If you
assign and already assigned buffer to a new key, the old assignment will be
deleted.

Finding buffer-marks should work naturally with your picker of choice as long
as it uses the default `vim.ui.select` function (Snacks, Telescope, Mini-Pick).
Same goes for notifications, the default `vim.notify` is used.

## Installation

### With [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
-- Minimal setup with defaults
{
  'cat-phish/buffer-marks.nvim',
  event = 'VeryLazy',
  opts = {},  -- Calls setup() with default config
}

-- Custom config
{
  'cat-phish/buffer-marks.nvim',
  event = 'VeryLazy',
  opts = {
    notify = false,
    keymaps = {
      mark = 'mm',
    },
  },
}

-- Or manually call setup
{
  'cat-phish/buffer-marks.nvim',
  event = 'VeryLazy',
  config = function()
    require('buffer-marks').setup({
      notify = false,
    })
  end,
}
```

### With [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'cat-phish/buffer-marks.nvim',
  config = function()
    require('buffer-marks').setup()
  end
}
```

## Configuration

### Full Config with All Opts

```lua
require('buffer-marks').setup({
  -- Notifications
  notify = true,  -- Show notifications
  notify_on_mark = true,  -- Notify when marking a buffer
  notify_on_jump = true,  -- Notify when jumping to a mark

  -- Keymaps (set to false to disable default keymaps)
  keymaps = {
    mark = "<leader>m",
    jump = "<leader>'",
    list = "<leader>fm",
    clear = "<leader>mc",
  },
})
```
