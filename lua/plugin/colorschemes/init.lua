---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user_api')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module
local is_nil = Check.value.is_nil

---@type CscMod
---@diagnostic disable-next-line:missing-fields
local M = {
    onedark = exists('plugin.colorschemes.onedark') and (function()
        return require('plugin.colorschemes.onedark')
    end)() or nil,
    tokyonight = exists('plugin.colorschemes.tokyonight') and (function()
        return require('plugin.colorschemes.tokyonight')
    end)() or nil,
    catppuccin = exists('plugin.colorschemes.catppuccin') and (function()
        return require('plugin.colorschemes.catppuccin')
    end)() or nil,
    nightfox = exists('plugin.colorschemes.nightfox') and (function()
        return require('plugin.colorschemes.nightfox')
    end)() or nil,
    vscode = exists('plugin.colorschemes.vscode') and (function()
        return require('plugin.colorschemes.vscode')
    end)() or nil,
    gruvbox = exists('plugin.colorschemes.gruvbox') and (function()
        return require('plugin.colorschemes.gruvbox')
    end)() or nil,
    kanagawa = exists('plugin.colorschemes.kanagawa') and (function()
        return require('plugin.colorschemes.kanagawa')
    end)() or nil,
    gloombuddy = exists('plugin.colorschemes.gloombuddy') and (function()
        return require('plugin.colorschemes.gloombuddy')
    end)() or nil,
    oak = exists('plugin.colorschemes.oak') and (function()
        return require('plugin.colorschemes.oak')
    end)() or nil,
    molokai = exists('plugin.colorschemes.molokai') and (function()
        return require('plugin.colorschemes.molokai')
    end)() or nil,
    spaceduck = exists('plugin.colorschemes.spaceduck') and (function()
        return require('plugin.colorschemes.spaceduck')
    end)() or nil,
    dracula = exists('plugin.colorschemes.dracula') and (function()
        return require('plugin.colorschemes.dracula')
    end)() or nil,
    spacemacs = exists('plugin.colorschemes.spacemacs') and (function()
        return require('plugin.colorschemes.spacemacs')
    end)() or nil,
    space_vim_dark = exists('plugin.colorschemes.space_vim_dark') and (function()
        return require('plugin.colorschemes.space_vim_dark')
    end)() or nil,
}

function M.new()
    local self = setmetatable({}, { __index = M })

    for k, v in next, self do
        if k ~= 'new' and not is_nil(v) then
            self[k] = v
        end
    end

    return self
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
