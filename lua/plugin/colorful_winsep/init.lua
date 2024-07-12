---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('colorful-winsep') then
    return
end

local CW = require('colorful-winsep')

CW.setup({
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
        'help',
        'prompt',
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
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
