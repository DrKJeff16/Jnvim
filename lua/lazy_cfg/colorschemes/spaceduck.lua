---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require("user")
local csc_t = User.types.colorschemes

---@type CscSubMod
local M = {
	mod_cmd = "colorscheme spaceduck",
	mod_pfx = "lazy_cfg.colorschemes.spaceduck",
}

if vim.g.installed_spaceduck == 1 then
	function M.setup()
		vim.cmd(M.mod_cmd)
	end
end

return M
