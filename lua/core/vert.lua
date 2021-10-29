local utils = require('utils')

local M = {}

-- Desc:
-- 		Moves up or down the current cursor line
-- 		mantaining the cursor over the line
-- Parameter:
-- 		dir -> Movement direction (-1, +1)
M.moveLine = function(dir)
	-- Get the last line of current buffer
	local last_line = vim.fn.line('$')

	-- Get current cursor position
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local line = cursor_position[1]

	if dir == nil then
		error('Missing offset', 3)
	end

	-- Edges
	if line == 1 and dir < 0 then
		return
	end
	if line == last_line and dir > 0 then
		return
	end

	-- General Case
	if line >= 1 and line <= last_line then
		utils.swap_line(line, line + dir)
	end
end

-- Desc:
-- 		Moves up or down a visual area
-- 		mantaining the selection
-- Parameter:
-- 		dir -> Movement direction (-1, +1)
-- 		line1 -> Initial line of the seleted area
-- 		line2 -> End line of the selected area
M.moveBlock = function(dir, line1, line2)
	local vSRow = line1 or vim.fn.line('v')
	local vERow = line2 or vim.api.nvim_win_get_cursor(0)[1]
	local last_line = vim.fn.line('$')

	-- Zero-based and end exclusive
	vSRow = vSRow - 1

	if vSRow > vERow then
		local aux = vSRow
		vSRow = vERow
		vERow = aux
	end

	-- Edges
	if vSRow == 0 and dir < 0 then
		vim.api.nvim_exec(':normal! '..vSRow..'ggV'..(vERow)..'gg', false)
		return
	end
	if vERow == last_line and dir > 0 then
		vim.api.nvim_exec(':normal! '..(vSRow + 1)..'ggV'..(vERow + dir)..'gg', false)
		return
	end

	local vBlock = vim.api.nvim_buf_get_lines(0, vSRow, vERow, true)

	if dir < 0 then
		local vTarget = utils.get_target(vSRow - 1, vSRow)
		table.insert(vBlock, vTarget[1])
	elseif dir > 0 then
		local vTarget = utils.get_target(vERow, vERow + 1)
		table.insert(vBlock, 1, vTarget[1])
	end

	utils.move_range(vBlock, (dir > 0 and vSRow or vSRow - 1), (dir > 0 and vERow + 1 or vERow))
	utils.reselect_block(dir, vSRow, vERow)
end

return M
