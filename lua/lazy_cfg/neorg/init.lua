---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module

if not exists('neorg') then
    return
end

local Neorg = require('neorg')

Neorg.setup({
    load = {
        ['core.defaults'] = {},
    },
    lazy_loading = true,
})
