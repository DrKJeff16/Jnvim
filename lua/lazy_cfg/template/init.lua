---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require("user")
local Check = User.check

local exists = Check.exists.module

if not exists("template") then
	return
end

local TPL = require("template")

local opts = {
	-- temp_dir = '/home/drjeff16/Templates',
	author = "DrKJeff16",
	email = "g.maxc.fox@protonmail.com",
}

TPL.setup(opts)
