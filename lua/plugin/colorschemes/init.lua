---@diagnostic disable:missing-fields

---@module 'plugin._types.colorschemes'

---@alias AllCsc
---|'catppuccin'
---|'dracula'
---|'gloombuddy'
---|'gruvbox'
---|'kanagawa'
---|'molokai'
---|'nightfox'
---|'oak'
---|'onedark'
---|'space_vim_dark'
---|'spaceduck'
---|'spacemacs'
---|'tokyonight'
---|'vscode'

---@alias AllColorSubMods
---|CpcSubMod
---|DraculaSubMod
---|ODSubMod
---|NFoxSubMod
---|TNSubMod
---|VSCodeSubMod
---|GloombuddySubMod
---|GruvboxSubMod
---|MolokaiSubMod
---|OakSubMod
---|SpaceVimSubMod
---|SpaceVimSubMod
---|SpaceDuckSubMod
---|SpacemacsSubMod

---@class CscMod
---@field OPTIONS (AllCsc)[]
---@field catppuccin CpcSubMod
---@field dracula DraculaSubMod
---@field gloombuddy GloombuddySubMod
---@field gruvbox GruvboxSubMod
---@field kanagawa KanagawaSubMod
---@field molokai MolokaiSubMod
---@field nightfox NFoxSubMod
---@field oak OakSubMod
---@field onedark ODSubMod
---@field space_vim_dark SpaceVimSubMod
---@field spaceduck SpaceDuckSubMod
---@field spacemacs SpacemacsSubMod
---@field tokyonight TNSubMod
---@field vscode VSCodeSubMod
---@field new fun(O: table?): CscMod|table|fun(color: string?, ...)

local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local is_fun = Check.value.is_fun
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local type_not_empty = Check.value.type_not_empty
local capitalize = User.util.string.capitalize
local displace_letter = User.util.displace_letter
local desc = User.maps.kmap.desc

local ERROR = vim.log.levels.ERROR

---@type CscMod|fun(color: string?, ...)
local Colorschemes = {}

---@type (AllCsc)[]
Colorschemes.OPTIONS = {
    'catppuccin',
    'tokyonight',
    'vscode',
    'kanagawa',
    'gruvbox',
    'nightfox',
    'dracula',
    'onedark',
    'gloombuddy',
    'molokai',
    'oak',
    'space_vim_dark',
    'spaceduck',
    'spacemacs',
}

---@type CpcSubMod
Colorschemes.catppuccin = require('plugin.colorschemes.catppuccin')

---@type DraculaSubMod
Colorschemes.dracula = require('plugin.colorschemes.dracula')

Colorschemes.gloombuddy = require('plugin.colorschemes.gloombuddy')

Colorschemes.gruvbox = require('plugin.colorschemes.gruvbox')

---@type KanagawaSubMod
Colorschemes.kanagawa = require('plugin.colorschemes.kanagawa')

Colorschemes.molokai = require('plugin.colorschemes.molokai')

---@type NFoxSubMod
Colorschemes.nightfox = require('plugin.colorschemes.nightfox')

Colorschemes.oak = require('plugin.colorschemes.oak')

---@type ODSubMod
Colorschemes.onedark = require('plugin.colorschemes.onedark')

Colorschemes.space_vim_dark = require('plugin.colorschemes.space_vim_dark')

Colorschemes.spaceduck = require('plugin.colorschemes.spaceduck')

Colorschemes.spacemacs = require('plugin.colorschemes.spacemacs')

---@type TNSubMod
Colorschemes.tokyonight = require('plugin.colorschemes.tokyonight')

---@type VSCodeSubMod
Colorschemes.vscode = require('plugin.colorschemes.vscode')

---@param O? table
---@return CscMod|table|fun(color: string?, ...)
function Colorschemes.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, {
        ---@diagnostic disable-next-line:unused-local
        __index = Colorschemes,

        __newindex = function(self, key, value)
            rawset(self, key, value)
        end,

        ---@type fun(self: CscMod, color: string?, ...)
        __call = function(self, color, ...)
            ---@type AllMaps
            local CscKeys = {
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

                if not (is_fun(TColor.valid) or TColor.valid()) then
                    goto continue
                end

                table.insert(valid, name)

                CscKeys['<leader>uc' .. csc_group] = {
                    group = '+Group ' .. csc_group,
                }

                if type_not_empty('table', TColor.variants) then
                    local v = 'a'
                    for _, variant in next, TColor.variants do
                        CscKeys['<leader>uc' .. csc_group .. tostring(i)] = {
                            group = string.format('+%s', capitalize(name)),
                        }
                        CscKeys['<leader>uc' .. csc_group .. tostring(i) .. v] = {
                            function()
                                TColor:setup(variant)
                            end,
                            desc(
                                string.format(
                                    'Set Colorscheme `%s` (%s)',
                                    capitalize(name),
                                    variant
                                )
                            ),
                        }

                        v = displace_letter(v, 'next', false)
                    end
                else
                    CscKeys['<leader>uc' .. csc_group .. tostring(i)] = {
                        function()
                            TColor:setup()
                        end,
                        desc(string.format('Set Colorscheme `%s`', capitalize(name))),
                    }
                end

                -- NOTE: This was TOO PAINFUL to get right (including `displace_letter`)
                if i == 9 then
                    -- If last  keymap set ended on 9, reset back to 1, and go to next letter alphabetically
                    i = 1
                    csc_group = displace_letter(csc_group, 'next', false)
                elseif i < 9 then
                    i = i + 1
                end

                ::continue::
            end

            if not type_not_empty('table', valid) then
                error('No valid colorschemes!', ERROR)
            end
            Keymaps({ n = CscKeys })

            if not (is_str(color) and vim.tbl_contains(valid, color)) then
                color = valid[1]
            end

            ---@type AllColorSubMods|nil
            local Selected = nil

            if self[color] ~= nil and self[color].valid() then
                ---@type AllColorSubMods
                Selected = self[color]

                Selected:setup(...)
                return
            end

            for _, csc in next, valid do
                if self[csc].valid() then
                    ---@type AllColorSubMods
                    Selected = self[csc]

                    Selected:setup()
                    return
                end
            end

            vim.cmd('silent! colorscheme default')
        end,
    })
end

local ColorMod = Colorschemes.new()

User:register_plugin('plugin.colorschemes')

return ColorMod

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
