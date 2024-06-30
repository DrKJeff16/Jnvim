---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check

local exists = Check.exists.module

if not exists('colorful-winsep') then
    return
end

local CW = require('colorful-winsep')

local Opts = {
    hi = {
        fg = '#16161E',
        bg = '#1F3442',
    },

    no_exec_files = {
        'packer',
        'lazy',
        'NvimTree',
        'qf',
        'TelescopePrompt',
        'mason',
    },

    symbols = { '━', '┃', '┏', '┓', '┗', '┛' },
    -- Smooth moving switch
    smooth = true,
    exponential_smoothing = true,
    anchor = {
        left = { height = 1, x = -1, y = -1 },
        right = { height = 1, x = -1, y = 0 },
        up = { width = 0, x = -1, y = 0 },
        bottom = { width = 0, x = 1, y = 0 },
    },
}

CW.setup(Opts)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
