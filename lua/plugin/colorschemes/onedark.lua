---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type ODSubMod
local OneDark = {
    ---@type OD.Variant[]
    variants = {
        'cool',
        'dark',
        'darker',
        'deep',
        'light',
        'warm',
        'warmer',
    },
    mod_cmd = 'silent! colorscheme onedark',
}

function OneDark.valid()
    return exists('onedark')
end

---@param variant? OD.Variant
---@param transparent? boolean
---@param override? table|OD
function OneDark:setup(variant, transparent, override)
    variant = (is_str(variant) and vim.tbl_contains(self.variants, variant)) and variant or 'deep'
    transparent = is_bool(transparent) and transparent or false
    override = is_tbl(override) and override or {}

    local OD = require('onedark')

    ---@type OD
    local Opts = {
        style = variant,
        transparent = transparent and not in_console(),
        term_colors = true,
        ending_tildes = true,
        cmp_itemkind_reverse = true,

        toggle_style_key = nil,
        toggle_style_list = { 'deep', 'warmer', 'darker' },

        code_style = {
            comments = 'altfont',
            conditionals = 'bold',
            loops = 'bold',
            functions = 'bold',
            keywords = 'bold',
            strings = 'altfont',
            variables = 'altfont',
            numbers = 'altfont',
            booleans = 'bold',
            properties = 'bold',
            types = 'bold',
            operators = 'altfont',
            -- miscs = '', -- Uncomment to turn off hard-coded styles
        },

        lualine = { transparent = transparent and not in_console() },

        diagnostics = {
            darker = false,
            undercurl = false,
            background = true,
        },
    }

    OD.setup(vim.tbl_deep_extend('keep', override, Opts))

    OD.load()
end

---@param O? table
---@return table|ODSubMod
function OneDark.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = OneDark })
end

User:register_plugin('plugin.colorschemes.onedark')

return OneDark

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
