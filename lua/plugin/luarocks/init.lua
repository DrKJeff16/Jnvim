---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('luarocks-nvim') then
    return
end

local Rocks = require('luarocks-nvim')

Rocks.setup({
    rocks = {
        'fzy',
        'pathlib.nvim',
        'lua-utils.nvim',
        'nvim-nio',
    },
    luarocks_buird_args = { '--local' },
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
