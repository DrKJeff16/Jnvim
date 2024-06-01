---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Types = require('user.types') -- Source all API annotations
local Check = require('user.check') -- Checker utilities
local Util = require('user.util') -- Coding utilities

local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local is_int = Check.value.is_int
local is_str = Check.value.is_str
local empty = Check.value.empty

---@type UserMod
local M = {
	types = require('user.types'),
	util = require('user.util'),
	check = require('user.check'),
	maps = require('user.maps'),
	highlight = require('user.highlight'),
	opts = require('user.opts'),

	assoc = function()
		local ft = Util.ft_set

		local au = vim.api.nvim_create_autocmd

		local group = vim.api.nvim_create_augroup('UserAssocs', { clear = false })

		---@type AuRepeatEvents[]
		local aus = {
			{
				events = { 'BufNewFile', 'BufReadPre' },
				opts_tbl = {
					{ pattern = '*.org', callback = ft('org'), group = group },
					{ pattern = '.spacemacs', callback = ft('lisp'), group = group },
					{ pattern = '.clangd', callback = ft('yaml'), group = group },
				},
			},
		}

		for _, v in next, aus do
			if not (is_str(v.events) or is_tbl(v.events)) or empty(v.events) then
				vim.notify('(user.assoc): Event type `' .. type(v.events) .. '` is neither string nor table')
				goto continue
			end

			if not is_tbl(v.opts_tbl) or empty(v.opts_tbl) then
				vim.notify('(user.assoc): Event options in a non-table or an empty one')
				goto continue
			end

			for _, o in next, v.opts_tbl do
				if not is_tbl(o) or empty(o) then
					vim.notify('(user.assoc): Event option is not a table or an empty one')
					goto continue
				end

				if not is_nil(o.pattern) and (not is_str(o.pattern) or empty(o.pattern)) then
					vim.notify('(user.assoc): Pattern is not a string or is an empty one')
					goto continue
				end

				if not is_nil(o.callback) and not is_fun(o.callback) then
					vim.notify('(user.assoc): Callback is not a function')
					goto continue
				end

				au(v.events, o)
			end

			::continue::
		end
	end,
}

return M
