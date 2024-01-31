local move_vert = require('move.core.vert')
local move_hor = require('move.core.horiz')

local M = {}

---Creates User defined commands
---@param cfg MoveConfig
M.create_user_commands = function(cfg)
	-- Line Command
	if cfg.line.enable then
		vim.api.nvim_create_user_command("MoveLine",
			function(args)
				local dir = tonumber(args.args:gsub("[()]", ""), 10)
				move_vert.moveLine(dir, cfg.line.indent)
			end, { desc = "Move cursor line", force = true, nargs = 1 }
		)
	end

	-- Block Command
	if cfg.block.enable then
		vim.api.nvim_create_user_command("MoveBlock",
			function(args)
				local dir = tonumber(args.args:gsub("[()]", ""), 10)
				move_vert.moveBlock(dir, args.line1, args.line2, cfg.block.indent)
			end, { desc = "Move visual block", force = true, nargs = 1, range = "%" }
		)
	end

	-- Word Command
	if cfg.word.enable then
		vim.api.nvim_create_user_command('MoveWord',
			function(args)
				local dir = tonumber(args.args:gsub("[()]", ""), 10)
				move_hor.horzWord(dir)
			end, { desc = "Move word forwards or backwards", force = true, nargs = 1 }
		)
	end

	-- Character Commands
	if cfg.char.enable then
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
