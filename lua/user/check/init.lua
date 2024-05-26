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
	dry_run = function(f, ...)
		---@type boolean
		local ok
		---@type unknown
		local res

		ok, res = pcall(f, ...)

		return ok and res or nil
	end,
}

function M.new()
	local self = setmetatable({}, { __index = M })
	self.value = M.value
	self.exists = M.exists
	self.dry_run = M.dry_run

	return self
end

return M
