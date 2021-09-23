-- Move
-- cursor: position of cursor in the form of {line, col}
-- start_pos: position to get the lines. Cero indexed
-- end_pos: position to end the line. Cero indexed
-- dir: direction of the movement
function Move(cursor, start_pos, end_pos, dir)
	local cursor_line = cursor[1]
	local current_line = nil
	local target_line = nil

	current_line = vim.api.nvim_get_current_line()
	target_line = vim.api.nvim_buf_get_lines(0, start_pos, end_pos, true)

	-- Swap current with target
	if dir < 0 then
		vim.api.nvim_buf_set_lines(0, start_pos, end_pos, true, { current_line })
		vim.api.nvim_buf_set_lines(0, end_pos, cursor_line, true, target_line)
	else if dir > 0 then
			vim.api.nvim_buf_set_lines(0, start_pos - 1, end_pos - 1, true, target_line)
			vim.api.nvim_buf_set_lines(0, start_pos, end_pos, true, { current_line })
		end
	end

	-- Set cursor position
	vim.api.nvim_win_set_cursor(0, { end_pos, cursor[2] })
end

function MoveLine(dir)
	-- Get the last line of current buffer
	local last_line = vim.fn.line('$')

	-- Get current cursor position
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local line = cursor_position[1]

	if dir == nil then
		vim.api.nvim_notify('Missing offset', 4, {})
		return
	end

	-- Edge Case
	if line == 1 and dir > 0 then
		Move(cursor_position, line, line + 1, dir)
		return
	end
	if line == last_line and dir < 0 then
		Move(cursor_position, line - 2, line -1, dir)
		return
	end

	-- General Case
	if line > 1 and line < last_line then
		if dir > 0 then
			Move(cursor_position, line, line + 1, dir)
			return
		end
		if dir < 0 then
			Move(cursor_position, line - 2, line - 1, dir)
			return
		end
	end
end

local function get_target(sRow, eRow)
	return vim.api.nvim_buf_get_lines(0, sRow, eRow, true)
end

local function move_block(block, sRow, eRow)
	vim.api.nvim_buf_set_lines(0, sRow, eRow, true, block)
	vim.api.nvim_exec('execute "normal! \\e\\e"', false)
end

function MoveBlock(dir, line1, line2)
	local vSRow = line1 or vim.fn.line('v')
	local vERow = line2 or vim.api.nvim_win_get_cursor(0)[1]

	-- Zero-based and end exclusive
	vSRow = vSRow - 1

	if vSRow > vERow then
		local aux = vSRow
		vSRow = vERow
		vERow = aux
	end

	local vBlock = vim.api.nvim_buf_get_lines(0, vSRow, vERow, true)
	if dir < 0 then
		local vTarget = get_target(vSRow - 1, vSRow)

		table.insert(vBlock, vTarget[1])

		move_block(vBlock, vSRow - 1, vERow)
		vim.api.nvim_exec(':normal! '..vSRow..'ggV'..(vERow - 1)..'gg', false)
	else
		if dir > 0 then
			local vTarget = get_target(vERow, vERow + 1)

			table.insert(vBlock, 1, vTarget[1])

			move_block(vBlock, vSRow, vERow + 1)
			vim.api.nvim_exec(':normal! '..(vSRow + 2)..'ggV'..(vERow + 1)..'gg', false)
		end
	end
end

vim.api.nvim_set_keymap('n', '<C-A-j>', "<Cmd>lua MoveLine(1)<CR>", { noremap = true, silent = true, nowait = true })
vim.api.nvim_set_keymap('n', '<C-A-k>', "<Cmd>lua MoveLine(-1)<CR>", { noremap = true, silent = true, nowait = true })
vim.api.nvim_set_keymap('v', '<C-A-k>', "<Cmd>lua MoveBlock(-1)<CR>", { noremap = true, silent = true, nowait = true })
vim.api.nvim_set_keymap('v', '<C-A-j>', "<Cmd>lua MoveBlock(1)<CR>", { noremap = true, silent = true, nowait = true })

return { MoveLine = MoveLine, MoveBlock = MoveBlock }
