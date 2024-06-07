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
        local path = 'lazy_cfg.colorschemes.' .. v

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

    self.new = M.new

    for _, c in next, submods do
        self[c] = exists(c, true) or nil
    end

    return self
end

return M
