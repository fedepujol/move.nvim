# move.nvim

Gain the power to move lines and blocks!

## Vertical Movement

![it-moves](media/move_01.gif)

## Horizontal Movement

![hor-char](media/hor_character.gif)

![hor-block](media/hor_block.gif)

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

### MoveLine

Move the cursor line up or down

#### VimScript

``` vim-script
nnoremap <silent> <A-j> lua require('move').MoveLine(1)<CR>
nnoremap <silent> <A-k> lua require('move').MoveLine(-1)<CR>

" Or use the command
nnoremap <silent> <A-j> :MoveLine(1)<CR>
nnoremap <silent> <A-k> :MoveLine(-1)<CR>
```

#### Lua

``` lua
vim.api.nvim_set_keymap('n', '<A-j>', "<Cmd>lua require('move').MoveLine(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', "<Cmd>lua require('move').MoveLine(-1)<CR>", { noremap = true, silent = true })

-- Or use the command
vim.api.nvim_set_keymap('n', '<A-j>', ":MoveLine(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', ":MoveLine(-1)<CR>", { noremap = true, silent = true })
```

### MoveBlock

Select a block of code/text and move it up or down (retains the
selection)

#### VimScript

``` vim-script
vnoremap <silent> <A-j> lua require('move').MoveBlock(1)<CR>
vnoremap <silent> <A-k> lua require('move').MoveBlock(-1)<CR>

" Or use the command
vnoremap <silent> <A-j> :MoveBlock(1)<CR>
vnoremap <silent> <A-k> :MoveBlock(-1)<CR>
```

#### Lua

``` lua
vim.api.nvim_set_keymap('v', '<A-j>', "<Cmd>lua require('move').MoveBlock(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-k>', "<Cmd>lua require('move').MoveBlock(-1)<CR>", { noremap = true, silent = true })

-- Or use the command
vim.api.nvim_set_keymap('v', '<A-j>', ":MoveBlock(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-k>', ":MoveBlock(-1)<CR>", { noremap = true, silent = true })
```

### MoveHChar

Moves the character below the cursor in `normal mode`

#### VimScript

``` vim-script
nnoremap <silent> <A-l> lua require('move').MoveHChar(1)<CR>
nnoremap <silent> <A-h> lua require('move').MoveHChar(-1)<CR>

" Or use the command
nnoremap <silent> <A-l> :MoveHChar(1)<CR>
nnoremap <silent> <A-h> :MoveHChar(-1)<CR>
```

#### Lua

``` lua
vim.api.nvim_set_keymap('n', '<A-l>', "<Cmd>lua require('move').MoveHChar(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-h>', "<Cmd>lua require('move').MoveHChar(-1)<CR>", { noremap = true, silent = true })

-- Or use the command
vim.api.nvim_set_keymap('n', '<A-l>', ":MoveHChar(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-h>', ":MoveHChar(-1)<CR>", { noremap = true, silent = true })
```

### MoveHBlock

Moves the selection (visual-area). It creates whitespace when surpassing
EOL.

#### VimScript

``` vim-script
nnoremap <silent> <A-l> lua require('move').MoveHBlock(1)<CR>
nnoremap <silent> <A-h> lua require('move').MoveHBlock(-1)<CR>

" Or use the command
nnoremap <silent> <A-l> :MoveHBlock(1)<CR>
nnoremap <silent> <A-h> :MoveHBlock(-1)<CR>
```

#### Lua

``` lua
vim.api.nvim_set_keymap('n', '<A-l>', "<Cmd>lua require('move').MoveHBlock(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-h>', "<Cmd>lua require('move').MoveHBlock(-1)<CR>", { noremap = true, silent = true })

-- Or use the command
vim.api.nvim_set_keymap('n', '<A-l>', ":MoveHBlock(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-h>', ":MoveHBlock(-1)<CR>", { noremap = true, silent = true })
```

## Mention

There is an original and more feature rich plugin (written in vimL):

[vim-move](https://github.com/matze/vim-move).
