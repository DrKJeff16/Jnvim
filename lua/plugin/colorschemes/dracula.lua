---@alias DraculaSubMod.Variant ('dracula'|'dracula-soft')

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool

---A colorscheme table for the `dracula.nvim` colorscheme
--- ---
---@class DraculaSubMod
local Dracula = {}

---@class DraculaSubMod.Variants
Dracula.variants = {
    'dracula',
    'dracula-soft',
}

---@type string
Dracula.mod_cmd = 'colorscheme '

---@return boolean
function Dracula.valid()
    return exists('dracula')
end

---@param variant? DraculaSubMod.Variant
---@param transparent? boolean
---@param override? table
function Dracula.setup(variant, transparent, override)
    variant = (is_str(variant) and vim.tbl_contains(Dracula.variants, variant)) and variant
        or Dracula.variants[1]
    transparent = is_bool(transparent) and transparent or false
    override = is_tbl(override) and override or {}

    local Drac = require('dracula')

    local Opts = {
        colors = {},

        -- show the '~' characters after the end of buffers
        show_end_of_buffer = false, -- default false
        -- use transparent background
        transparent_bg = transparent, -- default false
        -- set custom lualine background color
        lualine_bg_color = '#44475a', -- default nil
        -- set italic comment
        italic_comment = false, -- default false
        -- overrides the default highlights with table see `:h synIDattr`
        overrides = {},
        -- You can use overrides as table like this
        -- overrides = {
        --   NonText = { fg = "white" }, -- set NonText fg to white
        --   NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
        --   Nothing = {} -- clear highlight of Nothing
        -- },
        -- Or you can also use it like a function to get color from theme
        -- overrides = function (colors)
        --   return {
        --     NonText = { fg = colors.white }, -- set NonText fg to white of theme
        --   }
        -- end,
    }

    Drac.setup(vim.tbl_deep_extend('keep', override, Opts))

    vim.cmd(Dracula.mod_cmd .. variant)
end

return Dracula

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
