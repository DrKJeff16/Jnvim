---@alias AllColorSubMods
---|CpcSubMod
---|DraculaSubMod
---|FlexokiSubMod
---|GloombuddySubMod
---|GruvboxSubMod
---|MolokaiSubMod
---|NFoxSubMod
---|ODSubMod
---|OakSubMod
---|SpaceDuckSubMod
---|SpaceVimSubMod
---|SpaceVimSubMod
---|SpacemacsSubMod
---|TNSubMod
---|VSCodeSubMod

local User = require('user_api')
local Check = User.check

local is_str = Check.value.is_str
local type_not_empty = Check.value.type_not_empty
local capitalize = User.util.string.capitalize
local displace_letter = User.util.displace_letter
local desc = User.maps.desc

local ERROR = vim.log.levels.ERROR

local fmt = string.format

---@class CscMod
local Colorschemes = {}

---@enum (key) AllCsc
---@diagnostic disable-next-line:unused-local
local Colors = {
    tokyonight = 1,
    nightfox = 2,
    kanagawa = 3,
    catppuccin = 4,
    onedark = 5,
    gruvbox = 6,
    vscode = 7,
    dracula = 8,
    flexoki = 9,
    gloombuddy = 10,
    molokai = 11,
    oak = 12,
    space_vim_dark = 13,
    spaceduck = 14,
    spacemacs = 15,
}

---@type AllCsc[]
Colorschemes.OPTIONS = vim.tbl_keys(Colors)

Colorschemes.catppuccin = require('plugin.colorschemes.catppuccin')
Colorschemes.dracula = require('plugin.colorschemes.dracula')
Colorschemes.flexoki = require('plugin.colorschemes.flexoki')
Colorschemes.gloombuddy = require('plugin.colorschemes.gloombuddy')
Colorschemes.gruvbox = require('plugin.colorschemes.gruvbox')
Colorschemes.kanagawa = require('plugin.colorschemes.kanagawa')
Colorschemes.molokai = require('plugin.colorschemes.molokai')
Colorschemes.nightfox = require('plugin.colorschemes.nightfox')
Colorschemes.oak = require('plugin.colorschemes.oak')
Colorschemes.onedark = require('plugin.colorschemes.onedark')
Colorschemes.space_vim_dark = require('plugin.colorschemes.space_vim_dark')
Colorschemes.spaceduck = require('plugin.colorschemes.spaceduck')
Colorschemes.spacemacs = require('plugin.colorschemes.spacemacs')
Colorschemes.tokyonight = require('plugin.colorschemes.tokyonight')
Colorschemes.vscode = require('plugin.colorschemes.vscode')

---@type CscMod|fun(color?: string|AllCsc, ...: any)
local M = setmetatable({}, {
    __index = Colorschemes,

    __newindex = function(self, key, value)
        rawset(self, key, value)
    end,

    ---@param self CscMod
    ---@param color? string|AllCsc
    ---@param ... any
    __call = function(self, color, ...)
        local Keymaps = require('user_api.config.keymaps')

        ---@type AllMaps
        local Keys = {
            ['<leader>u'] = { group = '+UI' },
            ['<leader>uc'] = { group = '+Colorschemes' },
        }

        local csc_group = 'A'
        local i = 1

        ---@type string[]
        local valid = {}

        -- NOTE: This was also a pain in the ass
        --
        -- Generate keybinds for each colorscheme that is found
        -- Try checking them by typing `<leader>uc` IN NORMAL MODE
        for _, name in next, self.OPTIONS do
            ---@type AllColorSubMods
            local TColor = self[name]

            if TColor.valid ~= nil and TColor.valid() then
                table.insert(valid, name)

                Keys['<leader>uc' .. csc_group] = {
                    group = '+Group ' .. csc_group,
                }

                local i_str = tostring(i)

                if type_not_empty('table', TColor.variants) then
                    local v = 'a'
                    for _, variant in next, TColor.variants do
                        Keys['<leader>uc' .. csc_group .. i_str] = {
                            group = fmt('+%s', capitalize(name)),
                        }
                        Keys['<leader>uc' .. csc_group .. i_str .. v] = {
                            function()
                                TColor.setup(variant)
                            end,
                            desc(fmt('Set Colorscheme `%s` (%s)', capitalize(name), variant)),
                        }

                        v = displace_letter(v, 'next')
                    end
                else
                    Keys['<leader>uc' .. csc_group .. i_str] = {
                        TColor.setup,
                        desc(fmt('Set Colorscheme `%s`', capitalize(name))),
                    }
                end

                -- NOTE: This was TOO PAINFUL to get right (including `displace_letter`)
                if i == 9 then
                    -- If last  keymap set ended on 9, reset back to 1,
                    -- and go to next letter alphabetically
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
        Keymaps({ n = Keys })

        if not (is_str(color) and vim.tbl_contains(valid, color)) then
            color = valid[1]
        end

        ---@type AllColorSubMods
        local Color = self[color]

        if Color ~= nil and Color.valid() then
            Color.setup(...)
            return
        end

        for _, csc in next, valid do
            ---@type AllColorSubMods
            Color = self[csc]

            if Color.valid ~= nil and Color.valid() then
                Color.setup()
                return
            end
        end

        vim.cmd.colorscheme('default')
    end,
})

User.register_plugin('plugin.colorschemes')

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
