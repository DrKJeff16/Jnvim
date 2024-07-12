---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('startup') then
    return
end

local Startup = require('startup')

local Opts = {}

Startup.setup(Opts)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
