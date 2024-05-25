---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require("user")
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module

---@type CscSubMod
local M = {
	mod_cmd = "colorscheme gloombuddy",
	mod_pfx = "lazy_cfg.colorschemes.gloombuddy",
}

if exists("colorbuddy") then
	function M.setup()
		local Colorbuddy = require("colorbuddy")
		Colorbuddy.colorscheme("gloombuddy")

		vim.cmd(M.mod_cmd)
	end
end

return M
