---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:need-check-nil
---@diagnostic disable:missing-fields

local types = require('user.types.user.check')

---@type UserCheck
local M = {
	value = {
		---Check whether a value is `nil`, i.e. non existant or explicitly set as nil.
		is_nil = function(var, multiple)
			if multiple == nil or type(multiple) ~= 'boolean' then
				multiple = false
			end

			if not multiple then
				return var == nil
			end
			if  type(var) ~= 'table' then
				return false
			end

			---@type boolean
			local res

			for _, v in next, var do
				res = v == nil

				if res then
					break
				end
			end

			return res
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

---@type fun(t: Types): ValueFunc
local function type_fun(t)
	return function(var, multiple)
		local is_nil = M.value.is_nil

		if is_nil(multiple) or type(multiple) ~= 'boolean' then
			multiple = false
		end

		if not multiple then
			return not is_nil(var) and type(var) == t
		end
		if is_nil(var) or type(var) ~= 'table' then
			return false
		end

		---@type boolean
		local res

		for _, v in next, var do
			res = not is_nil(t) and type(v) == t

			if not res then
				break
			end
		end

		return res
	end
end

for k, v in next, type_funcs do
	M.value[k] = type_fun(v)
end

function M.dry_run(f, ...)
	---@type boolean
	local ok
	---@type unknown
	local res

	ok, res = pcall(f, ...)

	return (ok and res or nil)
end

M.exists = {
	module = function(mod, return_mod)
		local is_nil = M.value.is_nil

		return_mod = not is_nil(return_mod) and false or return_mod

		---@type boolean
		local res
		---@type unknown
		local m
		res, m = pcall(require, mod)

		return (return_mod and m or res)
	end,
	field = function(field, t)
		local is_nil = M.value.is_nil
		local is_num = M.value.is_num
		local is_str = M.value.is_str
		local is_tbl = M.value.is_tbl

		if not is_tbl(t) then
			error('Cannot look up a field in the following type: ' .. type(t))
		end

		if not is_str(field) and not is_num(field) then
			error('Field type `' .. type(t) .. '` not parseable.')
			return false
		end

		return is_nil(t[field])
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
				break
			end
		end

		return res
	end

	return false
end

function M.exists.executable(exe, fallback)
	local is_nil = M.value.is_nil
	local is_tbl = M.value.is_tbl
	local is_str = M.value.is_str
	local is_fun = M.value.is_fun
	local vexecutable = vim.fn.executable

	if not vim.tbl_contains({ 'string', 'table' }, type(exe)) then
		error('Argument type is not string nor table!!')
		return false
	end

	fallback = (is_nil(fallback) and nil or fallback)

	local res = false

	if is_tbl(exe) then
		for _, v in next, exe do
			res = M.exists.executable(v)
			if not res then
				break
			end
		end
	elseif is_str(exe) then
		res = vexecutable(exe) == 1
	end

	if not res and is_fun(fallback) then
		fallback()
	end

	return res
end

function M.exists.modules(mod, need_all)
	local is_bool = M.value.is_bool
	local is_tbl = M.value.is_tbl
	local is_str = M.value.is_str
	local exists = M.exists.module

	need_all = is_bool(need_all) and need_all or false

	---@type boolean|table<string, boolean>
	local res = false

	if is_str(mod) then
		res = exists(mod)
	elseif is_tbl(mod) and not vim.tbl_isempty(mod) then
		res = {}

		for _, v in next, mod do
			local r = exists(v)
			if need_all then
				res[v] = r
			else
				res = r

				-- Break when a single module is not found.
				if not r then break end
			end
		end
	else
		error('`(user.check.exists.modules)`: Input is neither a string nor a string array.')
	end

	return res
end

function M.new()
	local self = setmetatable({}, { __index = M })
	self.exists = M.exists
	self.value = M.value
	self.dry_run = M.dry_run
	self.new = M.new

	return self
end

return M
