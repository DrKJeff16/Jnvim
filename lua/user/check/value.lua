---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:need-check-nil
---@diagnostic disable:missing-fields

require('user.types.user.check')

---@type ValueCheck
local M = {
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

		for _, v in next, var do
			if v ~= nil then
				return false
			end
		end

		return true
	end,
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
		local is_nil = M.is_nil

		multiple = (multiple ~= nil and type(multiple) == 'boolean') and multiple or false

		if not multiple then
			return not is_nil(var) and type(var) == t
		end

		if is_nil(var) or type(var) ~= 'table' then
			return false
		end

		for _, v in next, var do
			if is_nil(t) or type(v) ~= t then
				return false
			end
		end

		return true
	end
end

for k, v in next, type_funcs do
	M[k] = type_fun(v)
end

--- Returns whether a data value is "empty", including these scenarios:
--- * Empty string
--- * Number equal to zero
--- * Empty table
--- ---
--- * `v`: Must be either a string, number or a table. Otherwise you'll get complaints.
function M.empty(v)
	local is_str = M.is_str
	local is_tbl = M.is_tbl
	local is_num = M.is_num
	local notify = require('user.util.notify').notify

	if is_str(v) then
		return v == ''
	end

	if is_num(v) then
		return v == 0
	end

	if is_tbl(v) then
		return vim.tbl_isempty(v)
	end

	notify("(user.check.value.empty): Value isn't a table, string nor a number", 'warn', { title = 'user.value.empty' })
	return true
end

function M.is_int(var, multiple)
	local is_nil = M.is_nil
	local is_tbl = M.is_tbl
	local is_bool = M.is_bool
	local is_num = M.is_num

	multiple = is_bool(multiple) and multiple or false

	if not multiple then
		return is_num(var) and var >= 0 and var == math.floor(var)
	end

	if not is_tbl(var) then
		return false
	end

	for _, v in next, var do
		if not (is_num(v) and v >= 0 and v == math.floor(v)) then
			return false
		end
	end

	return true
end

function M.fields(fields, T)
	local is_nil = M.is_nil
	local is_tbl = M.is_tbl
	local is_str = M.is_str
	local is_num = M.is_num
	local empty = M.empty

	if not is_tbl(T) then
		error('(user.check.value.fields): Cannot look up a field in the following type: ' .. type(T))
	end

	if not (is_str(fields) or is_num(fields) or is_tbl(fields)) or empty(fields) then
		error('(user.check.value.fields): Field type `' .. type(T) .. '` not parseable')
	end

	if not is_tbl(fields) then
		return not is_nil(T[fields])
	end

	for _, v in next, fields do
		if not M.fields(v, T) then
			return false
		end
	end

	return true
end

function M.tbl_values(values, T, return_keys)
	local is_tbl = M.is_tbl
	local is_str = M.is_str
	local is_int = M.is_int
	local is_bool = M.is_bool
	local empty = M.empty

	if not is_tbl(values) or empty(values) then
		error('(user.check.value.tbl_values): Value argument is either not a table or an empty one')
	end

	if not is_tbl(T) or empty(T) then
		error('(user.check.value.tbl_values): Table to check is either not a table or an empty one')
	end

	return_keys = is_bool(return_keys) and return_keys or false

	---@type boolean|string|integer|(string|integer)[]
	local res = return_keys and {} or false

	for _, val in next, values do
		for k, v in next, T do
			if return_keys and v == val then
				table.insert(res, k)
			elseif not return_keys and v == val then
				res = v == val
				break
			end
		end

		--- If not returning key, and no value found after this sweep, break
		if not (return_keys or res) then
			break
		end
	end

	if return_keys then
		if #res == 1 then
			res = res[1]
		elseif empty(res) then
			res = false
		end
	end

	return res
end

return M
