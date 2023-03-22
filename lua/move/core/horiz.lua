local utils = require('move.utils')

local M = {}

-- Moves the character under the cursor to the left or right
-- Updates the cursor position.
M.horzChar = function(dir)
	-- sRow and col: current cursor position
	local sRow, col = unpack(vim.api.nvim_win_get_cursor(0))

	local line = vim.api.nvim_get_current_line()

	local target = ''
	local prefix = ''
	local suffix = ''
	local result = {}
	local line_res = ''

	-- Checks line limits with the direction
	if dir < 0 and col < 1 then
		return
	end

	local selected = string.sub(line, col + 1, col + 1)

	-- Put a space if the character reaches the end of the line
	if col == line:len() - 1 and dir > 0 then
		target = ' '
	else
		target = string.sub(line, col + 1 + dir, col + 1 + dir)
	end

	prefix = string.sub(line, 1, col + (dir > 0 and 0 or -1))
	suffix = string.sub(line, col + (dir > 0 and 3 or 2))

	-- Remove trailing spaces before putting into the table
	line_res = prefix .. (dir > 0 and target .. selected or selected .. target) .. suffix
	line_res = line_res:gsub('%s+$', '')

	table.insert(result, line_res)

	-- Update the line with the new one and update cursor position
	vim.api.nvim_buf_set_lines(0, sRow - 1, sRow, true, result)
	vim.api.nvim_win_set_cursor(0, { sRow, col + dir })
end

-- Moves the visual area left or right
-- and keeps it selected
M.horzBlock = function(dir)
	-- Get the boundries (cols) of the visual area
	local sCol = vim.fn.col("'<")
	local eCol = vim.fn.col("'>")

	-- The current line of the cursor will be the last line
	-- of the visual area and eRow will be the first line
	local sRow, col = unpack(vim.api.nvim_win_get_cursor(0))
	local eRow = vim.fn.line("'>")

	local lines = vim.api.nvim_buf_get_lines(0, sRow - 1, eRow, true)
	local line = ''
	local selected = ''
	local prefix = ''
	local suffix = ''
	local results = {}

	-- Iterates over the lines of the visual area
	for _, v in ipairs(lines) do
		local target = ''

		if dir > 0 then
			if eCol == v:len() then
				target = ' '
			else
				target = string.sub(v, eCol + 1, eCol + 1)
			end

			selected = string.sub(v, sCol, eCol)
			prefix = string.sub(v, 1, sCol - 1)
			suffix = string.sub(v, eCol + 2)
		else
			if col == 0 then
				return
			end

			target = string.sub(v, sCol - 1, sCol - 1)
			selected = string.sub(v, sCol, eCol)
			prefix = string.sub(v, 1, sCol - 2)
			suffix = string.sub(v, eCol + 1)
		end
		-- Remove trailing spaces from the lines before
		-- inserting them into the results table
		line = prefix .. (dir > 0 and target .. selected or selected .. target) .. suffix
		line = line:gsub('%s+$', '')

		table.insert(results, line)
	end

	vim.api.nvim_buf_set_lines(0, sRow - 1, eRow, true, results)
	vim.api.nvim_win_set_cursor(0, { sRow, (sCol - 1) + dir })

	-- Update the visual area with the new position of the characters
	vim.cmd('execute "normal! \\e\\e"')
	local cmd_suffix = (eCol - sCol > 0 and (eCol - sCol) .. 'l' or '')
	cmd_suffix = cmd_suffix .. (eRow - sRow > 0 and (eRow - sRow) .. 'j' or '')
	vim.cmd('execute "normal! \\<C-V>' .. cmd_suffix .. '"')
end

--- Moves a word to the given direction
---@param dir number
M.horzWord = function(dir)
	local fBorder = false
	local words = { cursor = {}, other = {} }

	-- Line
	local line = vim.api.nvim_get_current_line()

	-- Original cursor position
	local oCursor = vim.api.nvim_win_get_cursor(0)

	if oCursor[2] == 0 and dir < 0 then
		fBorder = true
		return
	end

	utils.calc_cols(words.cursor)

	if oCursor[2] ~= 0 then
		-- If the cursor word is the whole line or
		-- don't do anything
		if words.cursor.sCol == 1 and words.cursor.eCol == #line then
			fBorder = true
			return
		end

		if words.cursor.eCol == #line and dir > 0 then
			fBorder = true
			return
		end

		if words.cursor.sCol == 1 and dir < 0 then
			fBorder = true
			return
		end

		utils.calc_word_cols(words.other, dir)
	else
		if words.cursor.eCol ~= #line then
			vim.cmd([[:normal! W]])
			utils.calc_cols(words.other)
		else
			fBorder = true
		end
	end

	-- Re-position cursor
	vim.api.nvim_win_set_cursor(0, oCursor)

	if not fBorder then
		words.cursor.value = line:sub(words.cursor.sCol, words.cursor.eCol)
		words.other.value = line:sub(words.other.sCol, words.other.eCol)

		utils.swap_words(words, line, dir)

		if dir > 0 then
			vim.cmd([[:normal! W]])
		else
			vim.cmd([[:normal! B]])
			if words.cursor.value:len() < words.other.value:len() then
				vim.cmd([[:normal! B]])
			end
		end
	end
end

return M
