---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Types = require('user.types') -- Source all API annotations
local Check = require('user.check') -- Checker utilities

local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local empty = Check.value.empty

---@type UserMod
local M = {
	types = Types,
	check = Check,
	maps = require('user.maps'),
	highlight = require('user.highlight'),
	opts = require('user.opts'),

	assoc = function()
		---@type fun(s: string): fun()
		local function ft(s)
			return function()
				if is_str(s) then
					vim.cmd('setlocal ft=' .. s)
				end
			end
		end

		local au = vim.api.nvim_create_autocmd

		---@type AuRepeatEvents[]
		local aus = {
			{
				events = { 'BufNewFile', 'BufReadPre' },
				opts_tbl = {
					{ pattern = '*.org', callback = ft('org') },
					{ pattern = '.spacemacs', callback = ft('lisp') },
					{ pattern = '.clangd', callback = ft('yaml') },
				},
			},
		}

		for _, v in next, aus do
			for _, o in next, v.opts_tbl do
				au(v.events, o)
			end
		end
	end,
}

return M
