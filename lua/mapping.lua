vim.api.nvim_set_keymap('n', '<C-A-j>', "<Cmd>lua require('lua.move').MoveLine(1)<CR>", { noremap = true, silent = true, nowait = true })
vim.api.nvim_set_keymap('n', '<C-A-k>', "<Cmd>lua require('lua.move').MoveLine(-1)<CR>", { noremap = true, silent = true, nowait = true })
vim.api.nvim_set_keymap('v', '<C-A-k>', "<Cmd>lua require('lua.move').MoveBlock(-1)<CR>", { noremap = true, silent = true, nowait = true })
vim.api.nvim_set_keymap('v', '<C-A-j>', "<Cmd>lua require('lua.move').MoveBlock(1)<CR>", { noremap = true, silent = true, nowait = true })
