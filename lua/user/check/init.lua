---@diagnostic disable:unused-local

local types = require('user.types.user.check')

---@type UserCheck
local M = {}
M.value = {}
function M.dry_run(f, ...)
	local res, _ = pcall(f, ...)
	return res
end
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
		if not t[field] and t[field] == nil then
			return false
		end
		return true
	end,
}

function M.exists.executable(exe, fallback)
	if exe == nil or not vim.tbl_contains({ 'string', 'table' }, type(exe)) then
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

function M.exists.modules(mod, need_all)
	if need_all == nil then
		need_all = true
	end

	---@type boolean|table<string, boolean>
	local res = false

	if type(mod) == 'string' then
		res = M.exists.module(mod)
	elseif type(mod) == 'table' and not vim.tbl_isempty(mod) then
		res = {}

		for _, v in next, mod do
			local r = M.exists.module(v)
			if need_all then
				res[v] = r
			elseif not need_all then
				res = r
				if not r then break end
			end
		end
	else
		error('`(user.check.exists.modules)`: Input not a string nor a string array.')
	end

	return res
end

function M.new()
	local self = setmetatable({}, { __index = M })
	self.exists = M.exists
	self.value = M.value
	self.dry_run = M.dry_run

	return self
end

return M
