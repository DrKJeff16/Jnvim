---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local Types = require('user.types')
local Check = require('user.check')

local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str

---@param s string
---@return fun()
local function ft(s)
	return function()
		if is_str(s) then
			vim.cmd('setlocal ft=' .. s)
		end
	end
end

---@type UserMod
local M = {
	types = require('user.types'),
	check = require('user.check'),
	maps = require('user.maps'),
	highlight = require('user.highlight'),
	opts = require('user.opts'),
	--- DONE: Refactor using Lua API.
	--- TODO: Refactor using own API modules.
	assoc = function()
		local au = vim.api.nvim_create_autocmd

		---@type AuRepeatEvents[]
		local aus = {
			{
				events = { 'BufNewFile', 'BufReadPre' },
				opts_tbl = {
					{ pattern = '*.org',      callback = ft('org') },
					{ pattern = '.spacemacs', callback = ft('lisp') },
					{ pattern = '.clangd',    callback = ft('yaml') },
				},
			},
		}

		for _, v in next, aus do
			for _, o in next, v.opts_tbl do
				if is_tbl(v.events) or is_str(v.events) then
					au(v.events, o)
				end
			end
		end
	end,
}

return M
