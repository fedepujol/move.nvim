# move.nvim

Gain the power to move lines and blocks!

## Vertical Movement

![vert_line](https://user-images.githubusercontent.com/26419570/214643592-9c7ae7bf-c26f-4698-986b-883c2b7a1206.gif)

![vert_block](https://user-images.githubusercontent.com/26419570/214643489-07ed1aa3-354c-457c-81c2-466bf84b2332.gif)

## Horizontal Movement

![hor_char](https://user-images.githubusercontent.com/26419570/214643419-461da2ce-bd98-4946-99a3-b063300d438c.gif)

![hor_block](https://user-images.githubusercontent.com/26419570/214643129-e013b118-e438-4dee-a82c-a98a1a4aadfa.gif)

## Word Movement

![word](https://user-images.githubusercontent.com/26419570/227013070-6c5e041c-c500-4944-8c83-79d5d54f6394.gif)

## :zap: Requirements

This plugin works with Neovim v0.5 or later.

## :package: Installation

- [lazy](https://github.com/folke/lazy.nvim)

```lua
{ 
    'fedepujol/move.nvim',
    opts = {
        --- Config
    }
}
```

- [paq](https://github.com/savq/paq-nvim)

```lua
'fedepujol/move.nvim';
```

## :gear: Configuration
You can use the default's (leaving the setup function empty)
```lua
require('move').setup({})

```

or customizing it
```lua
require('move').setup({
	line = {
		enable = true, -- Enables line movement
		indent = true  -- Toggles indentation
	},
	block = {
		enable = true, -- Enables block movement
		indent = true  -- Toggles indentation
	},
	word = {
		enable = true, -- Enables word movement
	},
	char = {
		enable = false -- Enables char movement
	}
})

```
:information_source: By default, every option is enabled except char movement.
:warning: Disabling line/block/word/char movements, will not generate the commands.

## :rocket: Usage

The plugin provides the following commands:

| Command    | Description                                               | Mode   |
| ---------- | --------------------------------------------------------- | ------ |
| MoveLine   | Moves a line up or down                                   | Normal |
| MoveHChar  | Moves the character under the cursor, left or right       | Normal |
| MoveWord   | Transpose the word under the cursor forwards or backwards | Normal |
| MoveBlock  | Moves a selected block of text, up or down                | Visual |
| MoveHBlock | Moves a visual area, left or right                        | Visual |

## :keyboard: Mappings

### VimScript

```vim-script
" Normal-mode commands
nnoremap <silent> <A-j> :MoveLine(1)<CR>
nnoremap <silent> <A-k> :MoveLine(-1)<CR>
nnoremap <silent> <A-l> :MoveHChar(1)<CR>
nnoremap <silent> <A-h> :MoveHChar(-1)<CR>
nnoremap <silent> <leader>wf :MoveWord(1)<CR>
nnoremap <silent> <leader>wb :MoveWord(-1)<CR>

" Visual-mode commands
vnoremap <silent> <A-j> :MoveBlock(1)<CR>
vnoremap <silent> <A-k> :MoveBlock(-1)<CR>
vnoremap <silent> <A-l> :MoveHBlock(1)<CR>
vnoremap <silent> <A-h> :MoveHBlock(-1)<CR>
```

### Lua

```lua
local opts = { noremap = true, silent = true }
-- Normal-mode commands
vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', opts)
vim.keymap.set('n', '<leader>wf', ':MoveWord(1)<CR>', opts)
vim.keymap.set('n', '<leader>wb', ':MoveWord(-1)<CR>', opts)

-- Visual-mode commands
vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
vim.keymap.set('v', '<A-h>', ':MoveHBlock(-1)<CR>', opts)
vim.keymap.set('v', '<A-l>', ':MoveHBlock(1)<CR>', opts)
```

or merge with lazy config (thanks to [ReKylee](https://github.com/ReKylee))

```lua
return {
    "fedepujol/move.nvim",
    keys = {
      -- Normal Mode
      { "<A-j>", ":MoveLine(1)<CR>", desc = "Move Line Up" },
      { "<A-k>", ":MoveLine(-1)<CR>", desc = "Move Line Down" },
      { "<A-h>", ":MoveHChar(-1)<CR>", desc = "Move Character Left" },
      { "<A-l>", ":MoveHChar(1)<CR>", desc = "Move Character Right" },
      { "<leader>wf", ":MoveWord(-1)<CR>", mode = { "n" }, desc = "Move Word Left" },
      { "<leader>wb", ":MoveWord(1)<CR>", mode = { "n" }, desc = "Move Word Right" },
      -- Visual Mode
      { "<A-j>", ":MoveBlock(1)<CR>", mode = { "v" }, desc = "Move Block Up" },
      { "<A-k>", ":MoveBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Down" },
      { "<A-h>", ":MoveHBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Left" },
      { "<A-l>", ":MoveHBlock(1)<CR>", mode = { "v" }, desc = "Move Block Right" },
    },
    opts = {
      -- Config here
    }
}
```

## :electric_plug: Integration

### [Legendary.nvim](https://github.com/mrjones2014/legendary.nvim)

Thanks to [hinell](https://github.com/hinell) to point this out:

> **Note**: Don't set up the keys like above if you're using legendary

```lua
local opts = { noremap = true }
require('legendary').setup({
    keymaps = {
        { "<A-k>", ":MoveLine -1", description = "Line: move up", opts },
        { "<A-j>", ":MoveLine 1", description = "Line: move down", opts },
        ...
    }
})
```

## Mention

There is an original and more feature rich plugin (written in VimScript):

[vim-move](https://github.com/matze/vim-move).
