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
	local selected = ''

	local sUnicode = ''
	local tUnicode = ''

	-- Checks line limits with the direction
	if dir < 0 and col < 1 then
		return
	end

	-- Default
	prefix = string.sub(line, 1, col + (dir > 0 and 0 or dir))

 	-- Unicode or tilde character
	sUnicode = vim.api.nvim_exec(':normal! g8', true)
	sUnicode = string.gsub(sUnicode, '%s+$', '')

	if isTilde(sUnicode) then
		selected = getUnicodeOrTilde()
	else
		selected = string.sub(line, col + 1, col + 1)
	end

	-- Check if target is unicode or tilde
	if isTilde(sUnicode) and dir < 0 then
		vim.api.nvim_win_set_cursor(0, { sRow, col + dir })
	end
	tUnicode = vim.api.nvim_exec(':normal! g8', true)
	tUnicode = string.gsub(tUnicode, '%s+$', '')

	-- Put a space if the character reaches the end of the line
	-- Default
	if col == line:len() - 1 and dir > 0 then
		target = ' '
	else
		suffix = string.sub(line, col + (dir > 0 and 3 or 2))
	end

	if isUnicode(sUnicode) then
		suffix = suffixUnicode(tUnicode, line, col, dir)
	end

	if isTilde(sUnicode) then
		suffix = suffixTilde(tUnicode, line, col, dir)
	end

	if not isTilde(tUnicode) then
		-- Default
		target = string.sub(line, col + dir + 1, col + dir + 1)

		if isUnicode(sUnicode) then
			target = string.sub(line, col + dir + 1 + (dir > 0 and 2 or 0), col + dir + 1 + (dir > 0 and 2 or 0))
		elseif isTilde(sUnicode) then
			target = string.sub(line, col + dir + 1 + (dir > 0 and 1 or 0), col + dir + 1 + (dir > 0 and 1 or 0))
		end
	else
		target = getUnicodeOrTilde()
		prefix = string.sub(line, 1, col)
	end

	-- Return cursor position to original
	vim.api.nvim_win_set_cursor(0, { sRow, col })

	print('target: '..target, 'prefix: '..prefix, 'suffix: '..suffix)

	-- Remove trailing spaces before putting into the table
	line_res = prefix..(dir > 0 and target..selected or selected..target)..suffix
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
				target = string.sub(v, eCol + 1 , eCol + 1)
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
		line = prefix..(dir > 0 and target..selected or selected..target)..suffix
		line = line:gsub('%s+$', '')

		table.insert(results, line)
	end

	vim.api.nvim_buf_set_lines(0, sRow - 1, eRow, true, results)
	vim.api.nvim_win_set_cursor(0, { sRow, (sCol - 1) + dir })

	-- Update the visual area with the new position of the characters
	vim.cmd('execute "normal! \\e\\e"')
	local cmd_suffix = (eCol - sCol > 0 and (eCol - sCol)..'l' or '')
	cmd_suffix = cmd_suffix..(eRow - sRow > 0 and (eRow - sRow)..'j' or '')
	vim.cmd('execute "normal! \\<C-V>'..cmd_suffix..'"')
end

return M
