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
		return nCount
	else
		return tCount
	end

end

M.indent_block = function(amount, sLine, eLine)
	local cRow = sLine or vim.api.nvim_win_get_cursor(0)[1]
	local eRow = eLine or cRow

	local cIndent = countIndent(cRow)
	local diff = amount - cIndent

	if diff < 0 then
		vim.cmd('silent! '..cRow..','..eRow..string.rep('<', math.abs(diff)))
	elseif diff > 0 then
		vim.cmd('silent! '..cRow..','..eRow..string.rep('>', diff))
	end
end

M.indent = function(amount, sLine, eLine)
	local cRow = sLine or vim.api.nvim_win_get_cursor(0)[1]
	local eRow = eLine or cRow

	local cIndent = countIndent(cRow)
	local diff = amount - cIndent

	vim.cmd('silent! normal! ==')
	local newInd = countIndent(cRow)

	vim.cmd('silent! '..cRow..','..eRow..string.rep('<', newInd))
	vim.cmd('silent! '..cRow..','..eRow..string.rep('>', cIndent))

	if cIndent ~= newInd and diff ~= 0 then
		if cIndent < newInd then
			vim.cmd('silent! '..cRow..','..eRow..string.rep('>', newInd - cIndent))
		else
			vim.cmd('silent! '..cRow..','..eRow..string.rep('<', cIndent - newInd))
		end
	elseif diff > 0 then
		vim.cmd('silent! '..cRow..','..eRow..string.rep('>', diff))
	end

end

return M
