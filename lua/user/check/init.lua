---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:need-check-nil
---@diagnostic disable:missing-fields

require('user.types.user.check')

---@type UserCheck
local M = {
	value = {
		-- NOTE: We define `is_nil` first as it's used by the other checkers.

		--- Check whether a value is `nil`, i.e. non existant or explicitly set as nil.
		--- ---
		--- * `var`: Any data type to be checked if it's nil.
		--- **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
		--- Otherwise it will be flagged as non-existant and function will return `true`.
		---
		--- * `multiple`: Tell the function you're checking multiple values. (Default: `false`).
		--- If set to `true`, the result will be `false` _unless any item on the table is `nil`_.
		--- In that case, function will immediately stop checking. The result will be returned regardless.
		is_nil = function(var, multiple)
			multiple = (multiple ~= nil and type(multiple) == 'boolean') and multiple or false

			if not multiple then
				return var == nil
			end

			if type(var) ~= 'table' or vim.tbl_isempty(var) then
				return false
			end

			---@type boolean
			local res

			for _, v in next, var do
				res = v == nil

				if res then break end
			end

			return res
		end,
	},
}

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

		multiple = (multiple ~= nil and type(multiple) == 'boolean') and multiple or false

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

			if not res then break end
		end

		return res
	end
end

for k, v in next, type_funcs do
	M.value[k] = type_fun(v)
end

--- Returns whether a data value is "empty", including these scenarios:
--- * Empty string
--- * Number equal to zero
--- * Empty table
--- ---
--- * `v`: Must be either a string, number or a table. Otherwise you'll get complaints.
function M.value.empty(v)
	local is_str = M.value.is_str
	local is_tbl = M.value.is_tbl
	local is_num = M.value.is_num

	local res = true

	if is_str(v) then
		res = v == ''
	end

	if is_num(v) then
		res = v == 0
	end

	if is_tbl(v) then
		res = vim.tbl_isempty(v)
	end

	return res
end

function M.value.is_int(var, multiple)
	local is_nil = M.value.is_nil
	local is_tbl = M.value.is_tbl
	local is_bool = M.value.is_bool
	local is_num = M.value.is_num

	multiple = is_bool(multiple) and multiple or false

	if not multiple then
		return is_num(var) and var >= 0
	end
	if not is_tbl(var) then
		return false
	end

	---@type boolean
	local res

	for _, v in next, var do
		res = is_num(var) and var >= 0

		if not res then break end
	end

	return res
end

function M.dry_run(f, ...)
	---@type boolean
	local ok
	---@type unknown
	local res

	ok, res = pcall(f, ...)

	return ok and res or nil
end

M.exists = {
	module = function(mod, return_mod)
		local is_bool = M.value.is_bool
		local is_nil = M.value.is_nil

		return_mod = is_bool(return_mod) and return_mod or false

		---@type boolean
		local res
		---@type unknown
		local m
		res, m = pcall(require, mod)

		if return_mod then
			return not is_nil(m) and m or nil
		else
			return res
		end
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
		end

		return not is_nil(t[field])
	end,
}

function M.exists.vim_has(expr)
	local is_str = M.value.is_str
	local is_tbl = M.value.is_tbl
	local empty = M.value.empty

	local has = vim.fn.has

	if is_str(expr) then
		return has(expr) == 1
	end

	if is_tbl(expr) and not empty(expr) then
		local res = false

		for _, v in next, expr do
			res = M.exists.vim_has(v)

			if not res then break end
		end

		return res
	end

	return false
end

function M.exists.vim_exists(expr)
	local exists = vim.fn.exists
	local is_str = M.value.is_str
	local is_tbl = M.value.is_tbl
	local empty = M.value.empty

	if is_str(expr) then
		return exists(expr) == 1
	end

	if is_tbl(expr) and not empty(expr) then
		local res = false
		for _, v in next, expr do
			res = M.exists.vim_exists(v)

			if not res then break end
		end

		return res
	end

	return false
end

function M.exists.vim_isdir(path)
	local is_str = M.value.is_str
	local empty = M.value.empty

	return (is_str(path) and not empty(path)) and (vim.fn.isdirectory(path) == 1) or false
end

function M.exists.executable(exe, fallback)
	local is_nil = M.value.is_nil
	local is_tbl = M.value.is_tbl
	local is_str = M.value.is_str
	local is_fun = M.value.is_fun
	local executable = vim.fn.executable

	if not (is_str(exe) or is_tbl(exe)) then
		error('(user.check.exists.executable): Argument type is neither string nor table')
	end

	fallback = is_fun(fallback) and fallback or nil

	local res = false

	if is_str(exe) then
		res = executable(exe) == 1
	elseif is_tbl(exe) then
		for _, v in next, exe do
			res = M.exists.executable(v)

			if not res then break end
		end
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
	local empty = M.value.empty
	local exists = M.exists.module

	if not (is_str(mod) or is_tbl(mod)) or empty(mod) then
		error('`(user.check.exists.modules)`: Input is neither a string nor a string array.')
	end

	need_all = is_bool(need_all) and need_all or false

	---@type boolean|table<string, boolean>
	local res = false

	if is_str(mod) then
		res = exists(mod)
	elseif is_tbl(mod) and not empty(mod) then
		res = {}

		for _, v in next, mod do
			local r = exists(v)

			if need_all then
				res[v] = r
			else
				res = r

				-- Break when a module is not found.
				if not r then break end
			end
		end
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
