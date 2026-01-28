# buffer-marks.nvim

A very simple buffer pinning system inspired by the inbuilt Global Marks, but
instead of always retuning you to the location in the buffer where you placed
your mark, it will return you to your last cursor position. By default, it uses
your `<leader>` key, so local and global mark behavior is left in place.

## Behavior

Overall, the behavior is very similar to Harpoon or other similar plugins,
however instead of having to predefine keys that can be assigned to your
buffer, you can use any lower or upper case letter character `[a-zA-Z]`. So how
you choose to arrange your marks is up to you on the fly, whether it's
pneumonic, in order on your home-row, etc.

## Installation

### With [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'cat-phish/buffer-marks.nvim',
  event = 'VeryLazy',
  opts = {
    -- your configuration here (optional)
  },
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
