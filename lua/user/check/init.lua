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

--- Check whether Nvim is running in a Linux Console rather than a `pty`.
--- ---
--- ## Description
--- This function can be useful for (un)loading certain elements that conflict with the Linux console, for example.
--- ---
--- ## Return
--- A boolean that confirms whether the environment is a Linux Console.
function M.in_console()
	local env = vim.fn.environ()
	---@type string
	local TERM = env['TERM']

	--- TODO: This is not a good enough check. Must find a better solution.
	return vim.tbl_contains({ 'screen', 'linux' }, TERM)
end

function M.new()
	local self = setmetatable({}, { __index = M })

	self.value = M.value
	self.exists = M.exists
	self.in_console = M.in_console

	return self
end

return M
