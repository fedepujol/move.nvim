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

## Requirements

This plugin works with NeoVim v0.5 or later.

## Installation

-   [packer.nvim](https://github.com/wbthomason/packer.nvim)

``` lua
use 'fedepujol/move.nvim'
```

-   [vim-plug](https://github.com/junegunn/vim-plug)

``` vim
Plug 'fedepujol/move.nvim'
```

-   [paq](https://github.com/savq/paq-nvim)

``` lua
'fedepujol/move.nvim';
```

## Usage

The plugin provides the following commands:

| Command   | Description | Mode |
|-----------|-------------|------|
| MoveLine  | Moves a line up or down | Normal |
| MoveBlock | Moves a selected block of text, up or down | Visual |
| MoveHChar | Moves the character under the cursor, left or right | Normal |
| MoveHBlock | Moves a visual area, left or right | Visual |
| MoveWord | Moves the word under the cursor forwards or backwards |

## Mappings

#### VimScript

``` vim-script
" Normal-mode commands
nnoremap <silent> <A-j> :MoveLine(1)<CR>
nnoremap <silent> <A-k> :MoveLine(-1)<CR>
nnoremap <silent> <A-l> :MoveHChar(1)<CR>
nnoremap <silent> <A-h> :MoveHChar(-1)<CR>

" Visual-mode commands
vnoremap <silent> <A-j> :MoveBlock(1)<CR>
vnoremap <silent> <A-k> :MoveBlock(-1)<CR>
vnoremap <silent> <A-l> :MoveHBlock(1)<CR>
vnoremap <silent> <A-h> :MoveHBlock(-1)<CR>
```

#### Lua

``` lua
local opts = { noremap = true, silent = true }
-- Normal-mode commands
vim.keymap.set('n', '<A-j>', ':MoveLine(1)<CR>', opts)
vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<CR>', opts)
vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<CR>', opts)
vim.keymap.set('n', '<A-l>', ':MoveHChar(1)<CR>', opts)

-- Visual-mode commands
vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
vim.keymap.set('v', '<A-h>', ':MoveHBlock(-1)<CR>', opts)
vim.keymap.set('v', '<A-l>', ':MoveHBlock(1)<CR>', opts)
```


## Integration

### [Legendary.nvim](https://github.com/mrjones2014/legendary.nvim)
Thanks to [hinell](https://github.com/hinell) to point this out:

> **Note**: Don't setup the keys like above if you're using legendary
```lua
require('legendary').setup({
    keymaps = {
        { "<A-k>", ":MoveLine -1", description = "Line: move up (move.nvim)", opts = { noremap = true }},
        { "<A-j>", ":MoveLine 1", description = "Line: move down (move.nvim)", opts = { noremap = true }},
        ...
    }
})
```


## Mention

There is an original and more feature rich plugin (written in VimScript):

[vim-move](https://github.com/matze/vim-move).
