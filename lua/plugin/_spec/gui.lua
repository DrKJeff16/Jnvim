---@module 'lazy'

local in_console = require('user_api.check').in_console

---@type LazySpec[]
local GUI = {
    {
        'equalsraf/neovim-gui-shim',
        version = false,
        cond = not in_console(),
    },
}

return GUI

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
