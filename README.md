# move.nvim

Gain the power to move lines and blocks!

## Vertical Movement

![it-moves](media/move_01.gif)

## Horizontal Movement

![hor-char](media/hor_character.gif)

![hor-block](media/hor_block.gif)

## Requirements

This plugin works with NeoVim v0.5 or later.

## Installation

-   [packer.nvim](https://github.com/wbthoason/packer.nvim)

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

## Mappings

#### VimScript

``` vim-script
nnoremap <silent> <A-j> <cmd>lua require('move').MoveLine(1)<CR>
nnoremap <silent> <A-k> <cmd>lua require('move').MoveLine(-1)<CR>
vnoremap <silent> <A-j> <cmd>lua require('move').MoveBlock(1)<CR>
vnoremap <silent> <A-k> <cmd>lua require('move').MoveBlock(-1)<CR>
nnoremap <silent> <A-l> <cmd>lua require('move').MoveHChar(1)<CR>
nnoremap <silent> <A-h> <cmd>lua require('move').MoveHChar(-1)<CR>
vnoremap <silent> <A-l> <cmd>lua require('move').MoveHBlock(1)<CR>
vnoremap <silent> <A-h> <cmd>lua require('move').MoveHBlock(-1)<CR>

" Or use the command
nnoremap <silent> <A-j> :MoveLine(1)<CR>
nnoremap <silent> <A-k> :MoveLine(-1)<CR>
vnoremap <silent> <A-j> :MoveBlock(1)<CR>
vnoremap <silent> <A-k> :MoveBlock(-1)<CR>
nnoremap <silent> <A-l> :MoveHChar(1)<CR>
nnoremap <silent> <A-h> :MoveHChar(-1)<CR>
vnoremap <silent> <A-l> :MoveHBlock(1)<CR>
vnoremap <silent> <A-h> :MoveHBlock(-1)<CR>
```

#### Lua

``` lua
vim.api.nvim_set_keymap('n', '<A-j>', "<Cmd>lua require('move').MoveLine(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', "<Cmd>lua require('move').MoveLine(-1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-j>', "<Cmd>lua require('move').MoveBlock(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-k>', "<Cmd>lua require('move').MoveBlock(-1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-l>', "<Cmd>lua require('move').MoveHChar(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-h>', "<Cmd>lua require('move').MoveHChar(-1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-l>', "<Cmd>lua require('move').MoveHBlock(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-h>', "<Cmd>lua require('move').MoveHBlock(-1)<CR>", { noremap = true, silent = true })

-- Or use the command
vim.api.nvim_set_keymap('n', '<A-j>', ":MoveLine(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', ":MoveLine(-1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-j>', ":MoveBlock(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-k>', ":MoveBlock(-1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-l>', ":MoveHChar(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-h>', ":MoveHChar(-1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-l>', ":MoveHBlock(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-h>', ":MoveHBlock(-1)<CR>", { noremap = true, silent = true })
```

## Mention

There is an original and more feature rich plugin (written in VimScript):

[vim-move](https://github.com/matze/vim-move).
