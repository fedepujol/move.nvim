DOWN = -1
UP = 1

-- Contains
-- tab: table of values
-- val: value to check if exists
-- return boolean
function Contains(tab, val)
	for _, value in ipairs(tab) do
		if val == value then
			return true
		end
	end
	return false
end

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
	if dir > 0 then
		if vim.fn.mode():byte() == 86 or vim.fn.mode():byte() == 118 then
            local vSRow = vim.fn.line('v') - 1
			local vERow= vim.api.nvim_win_get_cursor(0)[1]

			if vSRow > vERow then
				local aux = vSRow
				vSRow = vERow
				vERow = aux
			end

			local vBlock = vim.api.nvim_buf_get_lines(0, vSRow, vERow, true)
			local vTarget = vim.api.nvim_buf_get_lines(0, vSRow - 1, vSRow, true)

			table.insert(vBlock, vTarget[1])

			vim.api.nvim_buf_set_lines(0, vSRow - 1, vERow, true, vBlock)
			vim.api.nvim_exec('execute "normal! \\e\\e"', false)
			vim.api.nvim_exec(':normal! '..vSRow..'ggV'..vERow..'gg', false)
		else
			vim.api.nvim_buf_set_lines(0, start_pos, end_pos, true, { current_line })
			vim.api.nvim_buf_set_lines(0, end_pos, cursor_line, true, target_line)
		end
		else if dir < 0 then
			if vim.fn.mode():byte() == 86 or vim.fn.mode():byte() == 118 then
				local vSRow = vim.fn.line('v') - 1
				local vERow= vim.api.nvim_win_get_cursor(0)[1]

				if vSRow > vERow then
					local aux = vSRow
					vSRow = vERow
					vERow = aux
				end

				local vBlock = vim.api.nvim_buf_get_lines(0, vSRow, vERow, true)
				local vTarget = vim.api.nvim_buf_get_lines(0, vERow, vERow + 1, true)

				table.insert(vBlock, 1, vTarget[1])
				vim.api.nvim_buf_set_lines(0, vSRow, vSRow + (vERow - vSRow) + 1, true, vBlock)
				vim.api.nvim_exec('execute "normal! \\e\\e"', false)
				vim.api.nvim_exec(':normal! '..(vSRow + 2)..'ggV'..(vERow + 1)..'gg', false)
			else
				vim.api.nvim_buf_set_lines(0, start_pos - 1, end_pos - 1, true, target_line)
				vim.api.nvim_buf_set_lines(0, start_pos, end_pos, true, { current_line })
			end
		end
	end
	-- Set cursor position
	vim.api.nvim_win_set_cursor(0, { end_pos, cursor[2] })
end

function MoveLine(direction)
	-- Get the last line of current buffer
	local last_line = vim.fn.line('$')

	-- Get current cursor position
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local line = cursor_position[1]
	local valid_directions = {DOWN, UP}
	local res = nil

	if direction == nil then
		vim.api.nvim_notify('Missing direction', 4, {})
		return
	end

	res = Contains(valid_directions, direction)

	if res == nil or not res then
		vim.api.nvim_notify('Invalid direction', 4, {})
		return
	end

	-- Edge Case
	if line == 1 and direction < 0 then
		Move(cursor_position, line, line + 1, DOWN)
		return
	end
	if line == last_line and direction > 0 then
		Move(cursor_position, line - 2, line -1, UP)
		return
	end

	-- General Case
	if line > 1 and line < last_line then
		if direction < 0 then
			Move(cursor_position, line, line + 1, DOWN)
			return
		end
		if direction > 0 then
			Move(cursor_position, line - 2, line - 1, UP)
			return
		end
	end
end

vim.api.nvim_set_keymap('n', '<C-A-k>', "<Cmd>lua MoveLine(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-A-j>', "<Cmd>lua MoveLine(-1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-A-k>', "<Cmd>lua MoveLine(1)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-A-j>', "<Cmd>lua MoveLine(-1)<CR>", { noremap = true, silent = true })

return { Move = MoveLine }
