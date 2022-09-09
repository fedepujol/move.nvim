local utils = require('move.utils')

local M = {}

M.insideFold = false
M.foldLastLine = -1

---Moves up or down the current cursor-line, mantaining the cursor over the line.
---@param dir number Movement direction. One of -1, 1.
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
		local target = line
		local fold = utils.calc_fold(line, dir)

		if fold ~= -1 then
			target = fold
		end

		local amount = utils.calc_indent(target + dir, dir)
		utils.swap_line(line, target + dir)
		utils.indent(amount, target + dir)
	end
end

---Moves up or down a visual area mantaining the selection.
---@param dir number Movement direction. One of -1, 1.
---@param line1 number Initial line of the selected area.
---@param line2 number End line of the selected area.
M.moveBlock = function(dir, line1, line2)
	local vSRow = line1 or vim.fn.line('v')
	local vERow = line2 or vim.api.nvim_win_get_cursor(0)[1]
	local last_line = vim.fn.line('$')
	local fold_expr = vim.wo.foldexpr

	-- Zero-based and end exclusive
	vSRow = vSRow - 1

	if vSRow > vERow then
		local aux = vSRow
		vSRow = vERow
		vERow = aux
	end

	-- Edges
	if vSRow == 0 and dir < 0 then
		vim.api.nvim_exec(':normal! ' .. vSRow .. 'ggV' .. vERow .. 'gg', false)
		return
	end
	if vERow == last_line and dir > 0 then
		vim.api.nvim_exec(':normal! ' .. (vSRow + 1) .. 'ggV' .. (vERow + dir) .. 'gg', false)
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

	local amount = utils.calc_indent((dir > 0 and vERow or vSRow + 1) + dir, dir)
	utils.move_range(vBlock, (dir > 0 and vSRow or vSRow - 1), (dir > 0 and vERow + 1 or vERow))

	-- nvim_treesitter power folding is very experimental
	if fold_expr == 'nvim_treesitter#foldexpr()' then
		-- Update folds in case of abnormal functionality
		vim.cmd(':normal! zx')
	end

	utils.indent_block(amount, (dir > 0 and vSRow + 2 or vSRow), vERow + dir)
	utils.reselect_block(dir, vSRow, vERow)
end

return M
