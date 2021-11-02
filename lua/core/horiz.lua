local M = {}

M.horzChar = function(dir)
	-- sRow and col: current cursor position
	local sRow, col = unpack(vim.api.nvim_win_get_cursor(0))

	local line = vim.api.nvim_get_current_line()

	local target = ''
	local prefix = ''
	local suffix = ''
	local result = {}

	if dir < 0 and col < 1 then
		return
	end

	local selected = string.sub(line, col + 1, col + 1)

	if col == line:len() - 1 and dir > 0 then
		target = ' '
	else
		target = string.sub(line, col + 1 + dir, col + 1 + dir)
	end

	prefix = string.sub(line, 1, col + (dir > 0 and 0 or -1))
	suffix = string.sub(line, col + (dir > 0 and 3 or 2))

	table.insert(result, prefix..(dir > 0 and target..selected or selected..target)..suffix)

	vim.api.nvim_buf_set_lines(0, sRow - 1, sRow, true, result)
	vim.api.nvim_win_set_cursor(0, { sRow, col + dir })
end


M.horzBlock = function(dir)
	local sCol = vim.fn.col("'<")
	local eCol = vim.fn.col("'>")

	local sRow, col = unpack(vim.api.nvim_win_get_cursor(0))
	local eRow = vim.fn.line("'>")

	local lines = vim.api.nvim_buf_get_lines(0, sRow - 1, eRow, true)
	local results = {}

	for _, v in ipairs(lines) do
		local target = ''

		if dir > 0 then
			if eCol == v:len() then
				target = ' '
			else
				target = string.sub(v, eCol + 1 , eCol + 1)
			end

			local selected = string.sub(v, sCol, eCol)
			local prefix = string.sub(v, 1, sCol - 1)
			local suffix = string.sub(v, eCol + 2)

			table.insert(results, prefix..(dir > 0 and target..selected or selected..target)..suffix)
		else
			if col == 0 then
				return
			end

			target = string.sub(v, sCol - 1, sCol - 1)
			local selected = string.sub(v, sCol, eCol)
			local prefix = string.sub(v, 1, sCol - 2)
			local suffix = string.sub(v, eCol + 1)

			table.insert(results, prefix..(dir > 0 and target..selected or selected..target)..suffix)
		end
	end

	vim.api.nvim_buf_set_lines(0, sRow - 1, eRow, true, results)
	vim.api.nvim_win_set_cursor(0, { sRow, (sCol - 1) + dir })

	vim.cmd('execute "normal! \\e\\e"')
	local suffix = (eCol - sCol > 0 and (eCol - sCol)..'l' or '')
	suffix = suffix..(eRow - sRow > 0 and (eRow - sRow)..'j' or '')
	vim.cmd('execute "normal! \\<C-V>'..suffix..'"')
end

return M
