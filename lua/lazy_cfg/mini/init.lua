---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local exists = Check.exists.module

---@param mini_mod string
---@param opts? table
local function src(mini_mod, opts)
	mini_mod = 'mini.' .. mini_mod
	if not exists(mini_mod) then
		return
	end

	local M = require(mini_mod)

	if not Check.value.is_tbl(opts) then
		opts = {}
	end

	if Check.value.is_fun(M.setup) then
		M.setup(opts)
	end
end

---@class MiniModule
---@field [1] string
---@field [2]? table

---@type MiniModule[]
local modules = {
	{ 'starter', {} },
	{ 'basics', {} },
	{ 'cursorword', {} },
	{ 'doc', {} },
	{ 'hipatterns', {} },
	{ 'trailspace', {} },
	{ 'move', {} },
}

for _, t in next, modules do
	src(t[1], t[2] or nil)
end
