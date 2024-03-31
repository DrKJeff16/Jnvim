---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types')
require('user.types.user.maps')

local pfx = 'user.'

---@type UserMod
local M = {
	pfx = pfx,
	opts = function()
		return require('user.opts')
	end,
	maps = function()
		return require('user.maps')
	end,
	exists = function(mod)
		---@type boolean
		local res
		if mod and type(mod) == 'string' and mod ~= '' then
			res, _ = pcall(require, mod)
		end

		return res
	end,

	assoc = function()
		vim.cmd[[
		au BufNewFile,BufReadPre *.org set ft=org
		au BufNewFile,BufReadPre *.clangd set ft=yaml
		au BufNewFile,BufReadPre .spacemacs set ft=lisp
		]]
	end,
}

return M
