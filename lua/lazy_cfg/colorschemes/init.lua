---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local exists = User.exists

require('user.types.colorschemes')

---@type CscMod
local M = {}

---@param subs string[]
local src = function(subs)
	for _, v in next, subs do
		local path = 'lazy_cfg.colorschemes.'..v
		if exists(path) then
			M[v] = require(path)
		end
	end
end

local submods = {
	'tokyonight',
	'catppuccin',
	'nightfox',
	'spaceduck',
	'dracula',
	'gloombuddy',
}

src(submods)

return M
