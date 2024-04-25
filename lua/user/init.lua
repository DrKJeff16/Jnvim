---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local types = require('user.types')
local Check = require('user.check')

local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str

local api = vim.api
local fn = vim.fn
local set = vim.o
local let = vim.g
local opt = vim.opt
local bo = vim.bo
local cmd = vim.cmd

local au = api.nvim_create_autocmd

---@type UserMod
local M = {
	types = types,
	check = Check,
	maps = require('user.maps'),
	highlight = require('user.highlight'),
	opts = require('user.opts'),
}

---@param s string
---@return fun()
local function ft(s)
	return function() vim.cmd('setlocal ft='..s) end
end

--- DONE: Refactor using Lua API.
--- TODO: Refactor using own API modules.
function M.assoc()
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
			if is_tbl(v.events) or is_str(v.events) then
				au(v.events, o)
			end
		end
	end
end

return M
