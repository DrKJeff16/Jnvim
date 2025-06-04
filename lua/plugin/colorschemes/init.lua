---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'

local User = require('user_api')
local Check = User.check

local is_tbl = Check.value.is_tbl

User:register_plugin('plugin.colorschemes')

---@type CscMod
local Colorschemes = {}

Colorschemes.catppuccin = require('plugin.colorschemes.catppuccin')

Colorschemes.dracula = require('plugin.colorschemes.dracula')

Colorschemes.gloombuddy = require('plugin.colorschemes.gloombuddy')

Colorschemes.gruvbox = require('plugin.colorschemes.gruvbox')

Colorschemes.kanagawa = require('plugin.colorschemes.kanagawa')

Colorschemes.molokai = require('plugin.colorschemes.molokai')

Colorschemes.nightfox = require('plugin.colorschemes.nightfox')

Colorschemes.oak = require('plugin.colorschemes.oak')

---@type ODSubMod
Colorschemes.onedark = require('plugin.colorschemes.onedark')

Colorschemes.space_vim_dark = require('plugin.colorschemes.space_vim_dark')

Colorschemes.spaceduck = require('plugin.colorschemes.spaceduck')

Colorschemes.spacemacs = require('plugin.colorschemes.spacemacs')

Colorschemes.tokyonight = require('plugin.colorschemes.tokyonight')

Colorschemes.vscode = require('plugin.colorschemes.vscode')

---@param O? table
---@return CscMod|table
function Colorschemes.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Colorschemes })
end

return Colorschemes

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
