---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types')

local api = vim.api
local fn = vim.fn

---@type UserMod
local M = {}

function M.opts()
	return require('user.opts')
end
M.maps = require('user.maps')
M.highlight = require('user.highlight')

function M.exists(mod)
	---@type boolean
	local res
	res, _ = pcall(require, mod)

	return res
end

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
			api.nvim_create_autocmd(v.events, o)
		end
	end
end

return M
