---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local exists = User.exists

local pfx = 'lazy_cfg.colorschemes.'
require(pfx..'types')

---@type CscMod
local M = {}

---@param subs string[]
local src = function(subs)
	for _, v in next, subs do
		local path = pfx..v
		if exists(path) then
			M[v] = require(path)
		end
	end
end

---@type string[]
local submods = {
	'tokyonight',
	'catppuccin',
	'spaceduck',
	'dracula',
}

src(submods)

return M
