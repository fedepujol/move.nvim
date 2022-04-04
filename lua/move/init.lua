local move_hor = require('move.core.horiz')
local move_vert = require('move.core.vert')

return {
	MoveLine = move_vert.moveLine,
	MoveBlock = move_vert.moveBlock,
	MoveHChar = move_hor.horzChar,
	MoveHBlock = move_hor.horzBlock
}
