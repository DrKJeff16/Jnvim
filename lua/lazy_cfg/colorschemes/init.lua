---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local exists = User.exists

local pfx = 'lazy_cfg.colorschemes.'
require(pfx..'types')

---@type CscMod
local M = {}

---@param subs string[]
---@param prefix? string
local src = function(subs, prefix)
	prefix = prefix or pfx

	for _, v in next, subs do
		local path = prefix..v
		if exists(path) then
			M[v] = require(path)
		end
	end
end

---@type string[]
local submods = {
	'tokyonight',
	'catpucchin',
	'spaceduck',
	'dracula',
}

src(submods)

return M
