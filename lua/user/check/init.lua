---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:need-check-nil
---@diagnostic disable:missing-fields

require('user.types.user.check')
local Value = require('user.check.value')
local Exists = require('user.check.exists')

---@type UserCheck
local M = {
	value = Value,
	exists = Exists,
}

function M.new()
	local self = setmetatable({}, { __index = M })

	self.value = M.value
	self.exists = M.exists

	return self
end

return M
