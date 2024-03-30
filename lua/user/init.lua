---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types')
require('user.types.user.maps')

local pfx = 'user.'

---@type UserMod
local M = {}

M.pfx = pfx

M.opts = function()
	return require(M.pfx..'opts')
end

---@param prefix? string
---@return UserMod
function M:new(prefix)
	self = setmetatable({}, { __index = M })
	self.pfx = M.pfx
	return self
end

M.cond = {}

---@param mod string
---@return boolean res
function M.exists(mod)
	---@type boolean
	local res
	if mod and type(mod) == 'string' and mod ~= '' then
		res, _ = pcall(require, mod)
	end

	return res
end

function M.assoc()
	vim.cmd[[
	au BufNewFile,BufReadPre *.org set ft=org
	au BufNewFile,BufReadPre *.clangd set ft=yaml
	au BufNewFile,BufReadPre .spacemacs set ft=lisp
	]]
end

return M
