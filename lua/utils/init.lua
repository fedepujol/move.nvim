local M = {}
-- Desc:
-- 		Gets the lines between a range
-- Paramters:
-- 		sRow -> Start row (Zero-indexed)
-- 		eRow -> End row (end-exclusive)
M.get_target = function(sRow, eRow)
	return vim.api.nvim_buf_get_lines(0, sRow, eRow, true)
end

-- Desc:
-- 		Move the block of code selected
-- Parameters:
-- 		block -> Table with the lines selected and
-- 			the tageted line to change
-- 		sRow -> Start row (Zero-indexed)
-- 		eRow -> End row (end-exclusive)
M.move_range = function(block, sRow, eRow)
	vim.api.nvim_buf_set_lines(0, sRow, eRow, true, block)
end

-- Desc:
-- 		Escapes visual-line mode and re-selects
-- 		the block according to the new position
-- Parameters:
-- 		dir -> movement direction (-1, +1)
-- 		vSRow -> start row of visual area
-- 		vERow -> end row of visual area
M.reselect_block = function(dir, vSRow, vERow)
	vim.api.nvim_exec(':normal! \\e\\e', false)
	vim.api.nvim_exec(':normal! '..(dir > 0 and vSRow + 2 or vSRow)..'ggV'..(vERow + dir)..'gg', false)
end

-- Desc:
-- 		Set the lines for a given range (start_pos - end_pos)
-- 		for a direction (-1, +1)
-- Parmaters:
-- 		source -> position to get the lines.
-- 		target -> position to end the line.
M.swap_line = function(source, target)
	local current_line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local lSource = ''
	local lTarget = ''

	if source == nil and target == nil then
		error('Invalid lines')
	elseif source == nil and target ~= nil then
		source = current_line
	elseif source ~= nil and target == nil then
		error('Invalid target line')
	end

	lSource = vim.api.nvim_buf_get_lines(0, source - 1, source, true)
	lTarget = vim.api.nvim_buf_get_lines(0, target - 1, target, true)

	vim.api.nvim_buf_set_lines(0, source - 1, source, true, lTarget)
	vim.api.nvim_buf_set_lines(0, target - 1, target, true, lSource)

	-- Set cursor position
	vim.api.nvim_win_set_cursor(0, { target, col })
end

local function countIndent(line)
	return vim.fn.indent(line) / vim.fn.shiftwidth()
end

M.calc_indent = function(target, dir)
	local tCount = countIndent(target)
	local nCount = countIndent(target + dir)

	if tCount < nCount then
		return tCount
	else
		return nCount
	end

end

M.indent = function(amount)
	local cRow = vim.api.nvim_win_get_cursor(0)[1]

	local cIndent = countIndent(cRow)
	local diff = amount - cIndent

	print('diff '..diff, 'amount '..amount, 'cIndent '..cIndent)

	cIndent = countIndent(cRow)
	vim.cmd('silent! normal! ==')
	local newInd = countIndent(cRow)

	vim.cmd('silent! '..cRow..''..string.rep('<', newInd))
	vim.cmd('silent! '..cRow..''..string.rep('>', cIndent))

	print('cIndent '..cIndent, 'newIndent '..newInd)

	-- local oldShi = vim.fn.shiftwidth()
	-- vim.o.shiftwidth = 1

	if cIndent ~= newInd and cIndent < newInd then
		print('hola')
		vim.cmd('silent! '..cRow..','..cRow..string.rep('>', newInd - cIndent))
	else
		vim.cmd('silent! '..cRow..','..cRow..string.rep('<', cIndent - newInd))
	end
	-- vim.o.shiftwidth = oldShi

	if diff == 0 and cIndent == 0 and newInd == 1 then
		vim.cmd(':'..cRow..''..string.rep('<', newInd))
	end

	if diff == 0 and cIndent == 1 and newInd == 1 then
		vim.cmd(':'..cRow..''..string.rep('>', newInd))
	end

end

return M
