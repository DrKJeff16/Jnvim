---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

require('user.types.user.util')

local Value = require('user.check.value')
local is_tbl = Value.is_tbl
local is_str = Value.is_str
local empty = Value.empty
local field = Value.field

---@type UserUtils
local M = {}

function M.strip_fields(T, fields)
	if not is_tbl(T) then
		error('(maps:strip_options): Empty table')
	end

	if empty(T) then
		return T
	end

	if not (is_str(fields) or is_tbl(fields)) or empty(fields) then
		return T
	end

	---@type UserMaps.Keymap.Opts
	local res = {}

	if is_str(fields) then
		if not field(fields, T) then
			return T
		end

		for k, v in next, T do
			if k ~= fields then
				res[k] = v
			end
		end
	else
		for k, v in next, T do
			if not vim.tbl_contains(fields, k) then
				res[k] = v
			end
		end
	end

	return res
end

return M
