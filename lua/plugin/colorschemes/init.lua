---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check
local csc_t = User.types.colorschemes

local is_tbl = Check.value.is_tbl

User:register_plugin('plugin.colorschemes')

---@type CscMod
local Colorschemes = {}

---@type ODSubMod
Colorschemes.onedark = require('plugin.colorschemes.onedark')

Colorschemes.tokyonight = require('plugin.colorschemes.tokyonight')

Colorschemes.catppuccin = require('plugin.colorschemes.catppuccin')

Colorschemes.nightfox = require('plugin.colorschemes.nightfox')

Colorschemes.vscode = require('plugin.colorschemes.vscode')

Colorschemes.gruvbox = require('plugin.colorschemes.gruvbox')

Colorschemes.kanagawa = require('plugin.colorschemes.kanagawa')

Colorschemes.gloombuddy = require('plugin.colorschemes.gloombuddy')

Colorschemes.oak = require('plugin.colorschemes.oak')

Colorschemes.molokai = require('plugin.colorschemes.molokai')

Colorschemes.spaceduck = require('plugin.colorschemes.spaceduck')

Colorschemes.dracula = require('plugin.colorschemes.dracula')

Colorschemes.spacemacs = require('plugin.colorschemes.spacemacs')

Colorschemes.space_vim_dark = require('plugin.colorschemes.space_vim_dark')

---@param O? table
---@return CscMod|table
function Colorschemes.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Colorschemes })
end

return Colorschemes

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
