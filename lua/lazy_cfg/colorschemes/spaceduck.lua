---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.colorschemes')

local let = vim.g

---@type CscSubMod
local M = {
	mod_cmd = 'colorscheme spaceduck',
	mod_pfx = 'spaceduck',
}

if let.installed_spaceduck == 1 then
	function M.setup()
		vim.cmd(M.mod_cmd)
	end
end

return M
