---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

---@alias ModTbl string[]
---|{ [string]: string }
---|table<string, boolean>

local M = {}

M.pfx = 'user'

---@return table
function M:new()
	local self = setmetatable({}, { __index = M })
	self.pfx = M.pfx
	return self
end
M.cond = {}

---@param mod string|string[]
---@return boolean|{[string]: any} res
function M.exists(mod)
	local res = false
	res, recv = pcall(require, mod)
	return res
end

---@param mods ModTbl
---@param pfx? string
---@return any
function M:multisrc(mods, pfx)
	pfx = pfx or self.pfx
	local t = M.types:new()
	for k,v in next, mods do
		t = {type(k), type(v)}
	end
end

function M.assoc()
	vim.cmd[[
	au BufNewFile,BufReadPre *.org set ft=org
	au BufNewFile,BufReadPre *.clangd set ft=yaml
	au BufNewFile,BufReadPre .spacemacs set ft=lisp
	]]
end

return M
