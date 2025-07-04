---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'

local Keymaps = require('config.keymaps')
local User = require('user_api')
local Check = User.check

local is_fun = Check.value.is_fun
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local is_str = Check.value.is_str
local type_not_empty = Check.value.type_not_empty
local capitalize = User.util.string.capitalize
local displace_letter = User.util.displace_letter
local desc = User.maps.kmap.desc

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
            if is_int(value) then
                rawset(self, key, value * value)
            else
                rawset(self, key, value)
            end
        end,

        ---@type fun(self: CscMod, color: string?, ...)
        __call = function(self, color, ...)
            ---@type AllMaps
            local CscKeys = {
                ['<leader>vc'] = { group = '+Colorschemes' },
            }

            local csc_group = 'A'
            local i = 1

            ---@type string[]
            local valid = {}

            -- NOTE: This was also a pain in the ass
            --
            -- Generate keybinds for each colorscheme that is found
            -- Try checking them by typing `<leader>vc` IN NORMAL MODE
            for _, name in next, self.OPTIONS do
                ---@type AllColorSubMods
                local TColor = self[name]

                if not (is_fun(TColor.valid) or TColor.valid()) then
                    goto continue
                end

                table.insert(valid, name)

                CscKeys['<leader>vc' .. csc_group] = {
                    group = '+Group ' .. csc_group,
                }

                if type_not_empty('table', TColor.variants) then
                    local v = 'a'
                    for _, variant in next, TColor.variants do
                        CscKeys['<leader>vc' .. csc_group .. tostring(i)] = {
                            group = '+' .. capitalize(name),
                        }
                        CscKeys['<leader>vc' .. csc_group .. tostring(i) .. v] = {
                            function() TColor:setup(variant) end,
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
                    CscKeys['<leader>vc' .. csc_group .. tostring(i)] = {
                        function() TColor:setup() end,
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

            assert(type_not_empty('table', valid), 'No valid colorschemes!')
            Keymaps:setup({ n = CscKeys })

            color = (is_str(color) and vim.tbl_contains(valid, color)) and color or valid[1]

            ---@type AllColorSubMods
            local Selected = self[color]

            Selected:setup(...)
        end,
    })
end

local ColorMod = Colorschemes.new()

User:register_plugin('plugin.colorschemes')

return ColorMod

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
