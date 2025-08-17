---@class User.Config
local M = {}

M.keymaps = require('user_api.config.keymaps')
M.neovide = require('user_api.config.neovide')

local Config = setmetatable(M, {
    __index = M,

    __newindex = function(self, k, v)
        local Error = require('user_api.util.error')
        Error('User.Config table is Read-Only!')
    end,
})

return Config

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
