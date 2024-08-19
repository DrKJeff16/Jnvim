local User = require('user_api')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type ODSubMod
---@diagnostic disable-next-line:missing-fields
local M = {
    variants = {
        'cool',
        'dark',
        'darker',
        'deep',
        'light',
        'warm',
        'warmer',
    },
    mod_cmd = 'colorscheme onedark',
    setup = nil,
}

if exists('onedark') then
    User.register_plugin('plugin.colorschemes.onedark')

    function M.setup(variant, transparent, override)
        variant = (is_str(variant) and vim.tbl_contains(M.variants, variant)) and variant or 'deep'
        transparent = is_bool(transparent) and transparent or false
        override = is_tbl(override) and override or {}

        local OD = require('onedark')

        OD.setup(vim.tbl_extend('keep', override, {
            style = variant,
            transparent = transparent,
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

            lualine = { transparent = false },

            diagnostics = {
                darker = true,
                undercurl = true,
                background = true,
            },
        }))

        OD.load()
    end
end

function M.new() return setmetatable({}, { __index = M }) end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
