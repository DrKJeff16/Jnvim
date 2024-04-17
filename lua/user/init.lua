---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local types = require('user.types')

local api = vim.api
local fn = vim.fn
local set = vim.o
local let = vim.g
local opt = vim.opt
local bo = vim.bo
local cmd = vim.cmd

local au = api.nvim_create_autocmd

local old_exists = function(mod)
	---@type boolean
	local res
	res, _ = pcall(require, mod)

	return res
end

---@type UserMod
local M = {
	types = types,
	check = require('user.check'),
	maps = require('user.maps'),
	highlight = require('user.highlight'),
	opts = require('user.opts'),
}

--- Revert to legacy function if errors occur.
M.exists = (M.check.exists.module ~= nil and M.check.exists.module or old_exists)

---@param s string
---@return fun()
local ft = function(s)
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
			au(v.events, o)
		end
	end
end

return M
