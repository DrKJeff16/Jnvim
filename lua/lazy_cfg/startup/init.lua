---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module

if not exists('startup') then
	return
end

local Startup = require('startup')

local Opts = {}

Startup.setup(Opts)
