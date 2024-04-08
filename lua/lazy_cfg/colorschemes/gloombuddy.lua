---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local types = require('user').types.colorschemes

local User = require('user')
local exists = User.exists

local Colorbuddy = require('colorbuddy')

---@type CscSubMod
local M = {
	mod_cmd = 'colorscheme gloombuddy',
	mood_pfx = 'lazy_cfg.colorschemes.gloombuddy',
}

if exists('colorbuddy') then
	function M.setup()
		Colorbuddy.colorscheme('gloombuddy')
		vim.cmd(M.mod_cmd)
	end
end

return M
