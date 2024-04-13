---@diagnostic disable:unused-local

local types = require('user.types.user.check')

---@type UserCheck
local M = {}
M.exists = {
	data = function(v)
		if not v or v == nil then
			return false
		end
		return true
	end,
	module = function(mod)
		---@type boolean
		local res
		res, _ = pcall(require, mod)

		return res
	end,
	field = function(field, t)
		if not t[field] or t[field] == nil then
			return false
		end
		return true
	end,

	-- TODO: Do this table
	vim = {},
}

function M.exists.executable(exe, fallback)
	if not exe or vim.tbl_contains({ 'string', 'table' }, type(exe)) then
		vim.notify('Argument type is not string nor table!!', 'error')
		return false
	end
	fallback = fallback or nil

	local res = false

	if type(exe) == 'table' then
		for _, v in next, exe do
			res = M.exists.executable(v)
			if not res then
				break
			end
		end
	elseif type(exe) == 'string' then
		res = vim.fn.executable(exe) == 1
	end

	if not res and fallback ~= nil then
		fallback()
	end

	return res
end

function M.new()
	local self = setmetatable({}, { __index = M })
	self.exists = {}
	self.exists.executable = M.executable

	return self
end

return M
