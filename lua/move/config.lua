---@class MWordConfig
---@field enable boolean

---@class MLineConfig
---@field enable boolean
---@field indent boolean

---@class MBlockConfig
---@field enable boolean
---@field indent boolean

---@class MCharConfig
---@field enable boolean

---@class MoveConfig
---@field line MLineConfig
---@field block MBlockConfig
---@field word MWordConfig
---@field char MCharConfig

local M = {}

---@class MoveConfig
local default_config = {
	line = {
		enable = true,
		indent = true
	},
	block = {
		enable = true,
		indent = true
	},
	word = {
		enable = true,
	},
	char = {
		enable = false
	}
}

---@type MoveConfig
M.default_config = setmetatable({}, {
	__index = function(_, k)
		return default_config[k]
	end
})

---@param config MoveConfig
M.apply = function(config)
	default_config = vim.tbl_deep_extend('force', default_config, config or {})
end

return M
