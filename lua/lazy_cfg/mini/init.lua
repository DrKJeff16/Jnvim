---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local exists = User.check.exists.module

local src = function(mini_mod)
	if not exists(mini_mod) then
		return
	end
	local M = require(mini_mod)

	M.setup()
end

src('mini.basics')
src('mini.extra')
src('mini.doc')
-- src('mini.hues')
src('mini.hipatterns')
src('mini.pairs')
src('mini.trailspace')
src('mini.move')
