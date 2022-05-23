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

M.calc_eolOffset = function(char)
	local eolOffset = 1

	if M.isUnicode(char) then
		eolOffset = 3
	elseif M.isTilde(char) then
		eolOffset = 2
	end

	return eolOffset
end

M.cursor_offset = function(tChar, sChar, dir)
	local offset = 0

	if M.isUnicode(tChar) then
		offset = 3 + (M.isUnicode(sChar) and dir < 0 and -2 or 0)
	elseif M.isTilde(tChar) then
		offset = 2 + (M.isTilde(sChar) and dir < 0 and -1 or 0)
	else
		offset = 1
	end

	return offset * dir
end

M.isTilde = function(char)
	return char:len() > 2
end

M.isUnicode = function(char)
 	return char:len() > 5
end

M.isCharComposite = function()
	local char = vim.api.nvim_exec(':normal! g8', true)
	char = string.gsub(char, '%s+$', '')
	return char:len() > 2
end

M.getChar = function()
	vim.cmd(':normal! x')
	return vim.fn.getreg('"0')
end

M.getCharNew = function()
	local char = vim.api.nvim_exec(':normal! g8', true)
	char = string.gsub(char, '%s+$', '')
	return char
end

M.getVisualChar = function(sCol, eCol)
	vim.cmd(':normal! v'..(eCol - sCol)..'l')
	vim.cmd(':normal! x')
	return vim.fn.getreg('"0')
end

M.curUnicodeOrTilde = function()
	local uni = ''

	uni = vim.api.nvim_exec(':normal! g8', true)
	uni = string.gsub(uni, '%s+$', '')

	return uni
end

M.suffixUnicode = function(tChar, sChar, line, col, dir)
	local suffix = ''
	local offset = 0

	if dir > 0 then
		if M.isUnicode(tChar) then
			if M.isUnicode(sChar) then
				offset = 7
			else
				offset = 5
			end
		elseif M.isTilde(tChar) then
			if M.isUnicode(sChar) then
				offset = 6
			end
		else
			offset = 5
		end
	else
		if M.isUnicode(tChar) then
			if M.isUnicode(sChar) then
				offset = 4
			else
				offset = 2
			end
		else
			offset = 4
		end
	end

	suffix = string.sub(line, col + offset)

	return suffix
end

M.suffixTilde = function(tChar, sChar, line, col, dir)
	local suffix = ''
	local offset = 0

	if dir > 0 then
		if M.isTilde(sChar) then
			if M.isUnicode(tChar) then
				offset = 6
			elseif M.isTilde(tChar) then
				offset = 5
			else
				offset = 4
			end
		else
			if M.isTilde(tChar) then
				offset = 4
			end
		end
	else
		if M.isTilde(sChar) then
			offset = 3
		elseif M.isTilde(tChar) then
			offset = 2
		end
	end

	suffix = string.sub(line, col + offset)

	return suffix
end

M.getSize = function(char)
	local t = {}

	for w in string.gmatch(char, "%w+") do
		table.insert(t, w)
	end
	return #t
end

return M
