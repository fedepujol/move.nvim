if vim.g.move_nvim_loaded then
	return
end

local cpo = vim.opt.cpoptions
vim.cmd('set cpo&vim')

vim.api.nvim_create_user_command("MoveLine",
	function(args)
		local dir = tonumber(args.args:gsub("[()]", ""), 10)
		require('move').MoveLine(dir)
	end, { desc = "Move cursor line", force = true, nargs = 1 }
)

vim.api.nvim_create_user_command("MoveBlock",
	function(args)
		local dir = tonumber(args.args:gsub("[()]", ""), 10)
		require('move').MoveBlock(dir, args.line1, args.line2)
	end, { desc = "Move visual block", force = true, nargs = 1, range = "%" }
)

vim.api.nvim_create_user_command('MoveHChar',
	function(args)
		local dir = tonumber(args.args:gsub("[()]", ""), 10)
		require('move').MoveHChar(dir)
	end, { desc = "Move the character under the cursor horizontally", force = true, nargs = 1 }
)

vim.api.nvim_create_user_command('MoveHBlock',
	function(args)
		local dir = tonumber(args.args:gsub("[()]", ""), 10)
		require('move').MoveHBlock(dir)
	end, { desc = "Move visual block horizontally", force = true, nargs = 1, range = "%" }
)

vim.api.nvim_create_user_command('MoveWord',
	function(args)
		local dir = tonumber(args.args:gsub("[()]", ""), 10)
		require('move').MoveWord(dir)
	end, { desc = "Move word forwards or backwards", force = true, nargs = 1 }
)

vim.opt.cpoptions = cpo

vim.g.move_nvim_loaded = true
