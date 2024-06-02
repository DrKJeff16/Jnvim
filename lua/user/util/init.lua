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

function M.assoc()
	local ft = M.ft_set
	local is_nil = require('user.check.value').is_nil
	local is_fun = require('user.check.value').is_fun
	local is_tbl = require('user.check.value').is_tbl
	local is_str = require('user.check.value').is_str
	local empty = require('user.check.value').empty

	local au = vim.api.nvim_create_autocmd

	local group = vim.api.nvim_create_augroup('UserAssocs', { clear = false })

	---@type AuRepeatEvents[]
	local aus = {
		{
			events = { 'BufNewFile', 'BufReadPre' },
			opts_tbl = {
				{ pattern = '.spacemacs', callback = ft('lisp'), group = group },
				{ pattern = '.clangd', callback = ft('yaml'), group = group },
			},
		},
	}

	local ok, _ = pcall(require, 'orgmode')

	if ok then
		table.insert(aus[1].opts_tbl, { pattern = '*.org', callback = ft('org'), group = group })
	end

	for _, v in next, aus do
		if not (is_str(v.events) or is_tbl(v.events)) or empty(v.events) then
			M.notify.notify('(user.assoc): Event type `' .. type(v.events) .. '` is neither string nor table', 'error')
			goto continue
		end

		if not is_tbl(v.opts_tbl) or empty(v.opts_tbl) then
			M.notify.notify('(user.assoc): Event options in a non-table or an empty one', 'error')
			goto continue
		end

		for _, o in next, v.opts_tbl do
			if not is_tbl(o) or empty(o) then
				M.notify.notify('(user.assoc): Event option is not a table or an empty one', 'error')
				goto continue
			end

			if not is_nil(o.pattern) and (not is_str(o.pattern) or empty(o.pattern)) then
				M.notify.notify('(user.assoc): Pattern is not a string or is an empty one', 'error')
				goto continue
			end

			if not is_nil(o.callback) and not is_fun(o.callback) then
				M.notify.notify('(user.assoc): Callback is not a function', 'error')
				goto continue
			end

			au(v.events, o)
		end

		::continue::
	end
end

return M
