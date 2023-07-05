local Config = require('move.config')
local move_vert = require('move.core.vert')
local move_hor = require('move.core.horiz')

local M = {}

M.setup = function(config)
	Config.apply(config)

	if Config.default_config.line.enable then
		vim.api.nvim_create_user_command("MoveLine",
			function(args)
				local dir = tonumber(args.args:gsub("[()]", ""), 10)
				move_vert.moveLine(dir)
			end, { desc = "Move cursor line", force = true, nargs = 1 }
		)
	end

	if Config.default_config.block.enable then
		vim.api.nvim_create_user_command("MoveBlock",
			function(args)
				local dir = tonumber(args.args:gsub("[()]", ""), 10)
				move_vert.moveBlock(dir, args.line1, args.line2)
			end, { desc = "Move visual block", force = true, nargs = 1, range = "%" }
		)
	end
	if Config.default_config.word.enable then
		vim.api.nvim_create_user_command('MoveWord',
			function(args)
				local dir = tonumber(args.args:gsub("[()]", ""), 10)
				move_hor.horzWord(dir)
			end, { desc = "Move word forwards or backwards", force = true, nargs = 1 }
		)
	end
	if Config.default_config.char.enable then
		vim.api.nvim_create_user_command('MoveHChar',
			function(args)
				local dir = tonumber(args.args:gsub("[()]", ""), 10)
				move_hor.horzChar(dir)
			end, { desc = "Move the character under the cursor horizontally", force = true, nargs = 1 }
		)

		vim.api.nvim_create_user_command('MoveHBlock',
			function(args)
				local dir = tonumber(args.args:gsub("[()]", ""), 10)
				move_hor.horzBlock(dir)
			end, { desc = "Move visual block horizontally", force = true, nargs = 1, range = "%" }
		)
	end
end

return M
