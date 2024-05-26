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

function M.is_int(var, multiple)
	local is_nil = M.is_nil
	local is_tbl = M.is_tbl
	local is_bool = M.is_bool
	local is_num = M.is_num

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

		if not res then
			break
		end
	end

	return res
end

return M
