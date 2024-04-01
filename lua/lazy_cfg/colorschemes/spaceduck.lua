---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.colorschemes')

local g = vim.g

if not g.installed_spaceduck then
	return
end

---@type CscSubMod
local M = {
	mod_cmd = 'colorscheme spaceduck',
	mod_pfx = 'spaceduck',
	setup = function()
		vim.cmd('colorscheme spaceduck')
	end
}

return M
