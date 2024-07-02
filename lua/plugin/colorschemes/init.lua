---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module

---@type fun(subs: string[]): CscMod
local function src(subs)
    ---@type CscMod
    local res = {}

    for _, v in next, subs do
        local path = 'plugin.colorschemes.' .. v

        if exists(path) then
            res[v] = require(path)
        else
            res[v] = nil
        end
    end

    return res
end

local submods = {
    'onedark',
    'tokyonight',
    'catppuccin',
    'nightfox',
    'gruvbox',
    'gloombuddy',
    'oak',
    'molokai',
    'spaceduck',
    'dracula',
    'spacemacs',
    'space_vim_dark',
}

local M = src(submods)

function M.new()
    local self = setmetatable({}, { __index = M })

    for _, c in next, submods do
        self[c] = exists(c, true) or nil
    end

    return self
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
