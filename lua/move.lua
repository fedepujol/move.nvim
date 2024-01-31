local Config = require('move.config')
local commands = require('move.commands')

local M = {}

M.setup = function(config)
	Config.apply(config)

	commands.create_user_commands(Config.default_config)
end

return M
