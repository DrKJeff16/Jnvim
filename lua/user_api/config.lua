local ERROR = vim.log.levels.ERROR

---@class User.Config
local M = {
    keymaps = require('user_api.config.keymaps'),
    neovide = require('user_api.config.neovide'),
}

return setmetatable({}, {
    __index = M,

    __newindex = function(_, _, _)
        error('User.Config table is Read-Only!', ERROR)
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
