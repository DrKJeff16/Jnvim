---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

require('user.types.user.util')

---@type UserUtils
---@diagnostic disable-next-line:missing-fields
local M = {}

function M.strip_fields(T, fields)
	local is_tbl = require('user.check.value').is_tbl
	local is_str = require('user.check.value').is_str
	local is_int = require('user.check.value').is_int
	local empty = require('user.check.value').empty
	local field = require('user.check.value').field

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

function M.ft_set(s, bufnr)
	local is_int = require('user.check.value').is_int
	local is_str = require('user.check.value').is_str

	bufnr = is_int(bufnr) and bufnr or vim.api.nvim_get_current_buf()

	return function()
		if is_str(s) then
			vim.api.nvim_set_option_value('ft', s, { buf = bufnr })
		end
	end
end

function M.ft_get(bufnr)
	local is_int = require('user.check.value').is_int
	bufnr = is_int(bufnr) and bufnr or vim.api.nvim_get_current_buf()

	return vim.api.nvim_get_option_value('ft', { buf = bufnr })
end

M.notify = require('user.util.notify')

return M
