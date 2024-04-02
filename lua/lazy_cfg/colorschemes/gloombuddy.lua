---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

require('user.types.colorschemes')

local User = require('user')
local exists = User.exists

if not exists('colorbuddy') then
	return
end

local Colorbuddy = require('colorbuddy')

---@type CscSubMod
local M = {
	mod_cmd = 'colorscheme gloombuddy',
	mood_pfx = 'lazy_cfg.colorschemes.gloombuddy',
}

function M.setup()
	Colorbuddy.colorscheme('gloombuddy')
	vim.cmd(M.mod_cmd)
end

return M
