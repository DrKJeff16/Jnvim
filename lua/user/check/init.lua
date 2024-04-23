---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:need-check-nil
---@diagnostic disable:missing-fields

local types = require('user.types.user.check')

---@type UserCheck
local M = {
	value = {
		---Check whether a value is `nil`, i.e. non existant or explicitly set as nil.
		is_nil = function(var)
			return not var and var == nil
		end,
	},
}
-- NOTE: We define `is_nil` first as it's used by the other checkers.

local type_funcs = {
	['is_str'] = 'string',
	['is_bool'] = 'boolean',
	['is_fun'] = 'function',
	['is_num'] = 'number',
	['is_tbl'] = 'table',
}

---@param t Types
---@return ValueFunc
local function type_fun(t)
	return function(var)
		return var ~= nil and type(var) == t
	end
end

for k, v in next, type_funcs do
	M.value[k] = type_fun(v)
end

function M.dry_run(f, ...)
	local ok, res = pcall(f, ...)

	return (ok and res or nil)
end

M.exists = {
	data = function(v)
		return M.value.is_nil(v)
	end,
	module = function(mod, return_mod)
		return_mod = not M.value.is_nil(return_mod) and false or return_mod

		---@type boolean
		local res
		---@type unknown
		local m
		res, m = pcall(require, mod)

		return (return_mod and m or res)
	end,
	field = function(field, t)
		if not M.value.is_tbl(t) then
			error('Cannot look up a field in the following type: ' .. type(t))
		end

		return M.value.is_nil(t[field])
	end,
}

function M.exists.vim_exists(expr)
	local exists = vim.fn.exists
	local is_str = M.value.is_str
	local is_tbl = M.value.is_tbl

	if is_str(expr) then
		return exists(expr) == 1
	end

	if is_tbl(expr) and not vim.tbl_isempty(expr) then
		local res = false
		for _, v in next, expr do
			res = M.exists.vim_exists(expr)

			if not res then
				return false
			end
		end

		return true
	end

	return false
end

function M.exists.executable(exe, fallback)
	if not vim.tbl_contains({ 'string', 'table' }, type(exe)) then
		error('Argument type is not string nor table!!')
		return false
	end

	fallback = (M.value.is_nil(fallback) and nil or fallback)

	local res = false

	if M.value.is_tbl(exe) then
		for _, v in next, exe do
			res = M.exists.executable(v)
			if not res then
				break
			end
		end
	elseif M.value.is_str(exe) then
		res = vim.fn.executable(exe)
	end

	if not res and M.value.is_fun(fallback) then
		fallback()
	end

	return res
end

function M.exists.modules(mod, need_all)
	need_all = M.value.is_nil(need_all)

	---@type boolean|table<string, boolean>
	local res = false

	if M.value.is_str(mod) then
		res = M.exists.module(mod)
	elseif M.value.is_tbl(mod) and not vim.tbl_isempty(mod) then
		res = {}

		for _, v in next, mod do
			local r = M.exists.module(v)
			if need_all then
				res[v] = r
			else
				res = r

				-- Break when a single module is not found.
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
