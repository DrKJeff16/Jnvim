---@alias AllColorSubMods
---|AriakeSubMod
---|CpcSubMod
---|DraculaSubMod
---|EmbarkSubMod
---|FlexokiSubMod
---|GloombuddySubMod
---|GruvDarkSubMod
---|GruvboxSubMod
---|KanagawaSubMod
---|KPSubMod
---|MolokaiSubMod
---|NFoxSubMod
---|ODSubMod
---|OakSubMod
---|SpaceDuckSubMod
---|SpaceNvimSubMod
---|SpaceVimSubMod
---|TNSubMod
---|TokyoDarkSubMod
---|VSCodeSubMod

local is_str = require('user_api.check.value').is_str
local type_not_empty = require('user_api.check.value').type_not_empty
local displace_letter = require('user_api.util').displace_letter
local desc = require('user_api.maps').desc
local ERROR = vim.log.levels.ERROR

---@class CscMod
local Colorschemes = {}

---@enum AllCsc
Colorschemes.OPTIONS = {
    'Tokyonight',
    'Tokyodark',
    'Nightfox',
    'Embark',
    'Kanagawa',
    'KanagawaPaper',
    'Catppuccin',
    'Spaceduck',
    'Onedark',
    'Gruvdark',
    'Gruvbox',
    'Vscode',
    'Ariake',
    'Dracula',
    'Flexoki',
    'Gloombuddy',
    'Molokai',
    'Oak',
    'SpaceVimDark',
    'SpaceNvim',
}

-- stylua: ignore start

Colorschemes.Ariake         = require('plugin.colorschemes.ariake')
Colorschemes.Catppuccin     = require('plugin.colorschemes.catppuccin')
Colorschemes.Dracula        = require('plugin.colorschemes.dracula')
Colorschemes.Embark         = require('plugin.colorschemes.embark')
Colorschemes.Flexoki        = require('plugin.colorschemes.flexoki')
Colorschemes.Gloombuddy     = require('plugin.colorschemes.gloombuddy')
Colorschemes.Gruvbox        = require('plugin.colorschemes.gruvbox')
Colorschemes.Gruvdark       = require('plugin.colorschemes.gruvdark')
Colorschemes.Kanagawa       = require('plugin.colorschemes.kanagawa')
Colorschemes.KanagawaPaper  = require('plugin.colorschemes.kanagawa_paper')
Colorschemes.Molokai        = require('plugin.colorschemes.molokai')
Colorschemes.Nightfox       = require('plugin.colorschemes.nightfox')
Colorschemes.Oak            = require('plugin.colorschemes.oak')
Colorschemes.Onedark        = require('plugin.colorschemes.onedark')
Colorschemes.SpaceNvim      = require('plugin.colorschemes.space-nvim')
Colorschemes.SpaceVimDark   = require('plugin.colorschemes.space_vim_dark')
Colorschemes.Spaceduck      = require('plugin.colorschemes.spaceduck')
Colorschemes.Tokyodark      = require('plugin.colorschemes.tokyodark')
Colorschemes.Tokyonight     = require('plugin.colorschemes.tokyonight')
Colorschemes.Vscode         = require('plugin.colorschemes.vscode')

-- stylua: ignore end

---@type CscMod|fun(color?: string|AllCsc, ...: any)
local M = setmetatable({}, {
    __index = Colorschemes,

    ---@param self CscMod
    ---@param color? string|AllCsc
    ---@param ... any
    __call = function(self, color, ...)
        local Keys = { ---@type AllMaps
            ['<leader>u'] = { group = '+UI' },
            ['<leader>uc'] = { group = '+Colorschemes' },
        }
        local valid = {} ---@type string[]
        local csc_group = 'A'
        local i = 1
        for _, name in ipairs(self.OPTIONS) do
            local TColor = self[name] ---@type AllColorSubMods
            if TColor and TColor.valid and TColor.valid() then
                table.insert(valid, name)
                Keys['<leader>uc' .. csc_group] = {
                    group = '+Group ' .. csc_group,
                }
                local i_str = tostring(i)
                if type_not_empty('table', TColor.variants) then
                    local v = 'a'
                    for _, variant in ipairs(TColor.variants) do
                        Keys['<leader>uc' .. csc_group .. i_str] = {
                            group = ('+%s'):format(name),
                        }
                        Keys['<leader>uc' .. csc_group .. i_str .. v] = {
                            function()
                                TColor.setup(variant)
                            end,
                            desc(('Set Colorscheme `%s` (%s)'):format(name, variant)),
                        }
                        v = displace_letter(v, 'next')
                    end
                else
                    Keys['<leader>uc' .. csc_group .. i_str] = {
                        TColor.setup,
                        desc(('Set Colorscheme `%s`'):format(name)),
                    }
                end
                if i == 9 then
                    i = 1
                    csc_group = displace_letter(csc_group, 'next')
                elseif i < 9 then
                    i = i + 1
                end
            end
        end
        if not type_not_empty('table', valid) then
            error('No valid colorschemes!', ERROR)
        end
        require('user_api.config').keymaps({ n = Keys })
        if not (is_str(color) and vim.list_contains(valid, color)) then
            color = valid[1]
        end

        ---@type AllColorSubMods
        local Color = self[color]
        if Color ~= nil and Color.valid() then
            Color.setup(...)
            return
        end
        for _, csc in ipairs(valid) do
            Color = self[csc] ---@type AllColorSubMods
            if Color.valid ~= nil and Color.valid() then
                Color.setup()
                return
            end
        end
        vim.cmd.colorscheme('default')
    end,
})

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
