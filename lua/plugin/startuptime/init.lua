---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local Maps = User.maps

local is_int = Check.value.is_int
local desc = Maps.kmap.desc
local map_dict = Maps.map_dict

if not is_int(vim.g.installed_startuptime) or vim.g.installed_startuptime ~= 1 then
    return
end

vim.g.startuptime_tries = 10

local KEY = {
    ['<leader>vS'] = {
        function()
            vim.cmd('StartupTime')
        end,
        desc('Run StartupTime'),
    },
}

---@type table<MapModes, KeyMapDict>
local Keys = {
    n = vim.deepcopy(KEY),
    v = vim.deepcopy(KEY),
}

map_dict(Keys, 'wk.register', true)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
