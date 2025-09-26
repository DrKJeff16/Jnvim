---@alias TokyoDarkHl table<string, vim.api.keyset.highlight>

local User = require('user_api')
local Check = User.check

local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module

local d_extend = vim.tbl_deep_extend

---@class TokyoDarkOpts
local defaults = {
    ---@type boolean
    transparent_background = false, -- set background to transparent

    ---@type number
    gamma = 1.00, -- adjust the brightness of the theme

    ---@class TokyoDarkOpts.Styles
    styles = {
        comments = { italic = false }, -- style for comments
        keywords = { italic = false }, -- style for keywords
        identifiers = { bold = true, italic = false }, -- style for identifiers
        functions = { bold = true }, -- style for functions
        variables = {}, -- style for variables
    },

    -- custom_highlights = function(highlights, palette) return {} end,

    ---@type TokyoDarkHl|fun(highlights?: TokyoDarkHl, palette?: table<string, string>): TokyoDarkHl
    custom_highlights = {}, -- extend highlights

    -- custom_palette = function(palette) return {} end,

    ---@type table<string, string>|fun(palette?: table<string, string>): table<string, string>
    custom_palette = {}, -- extend palette

    ---@type boolean
    terminal_colors = vim.o.termguicolors, -- enable terminal colors
}

---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class TokyoDarkSubMod
local TokyoDark = {}

TokyoDark.mod_cmd = 'silent! colorscheme tokyodark'

---@return boolean
function TokyoDark.valid()
    return exists('tokyodark')
end

---@param transparent? boolean
---@param overrides? TokyoDarkOpts
function TokyoDark.setup(_, transparent, overrides)
    overrides = is_tbl(overrides) and overrides or {}
    transparent = is_bool(transparent) and transparent or false

    require('tokyodark').setup(
        d_extend('keep', { transparent_background = transparent }, overrides, defaults)
    )

    vim.cmd(TokyoDark.mod_cmd)
end

return TokyoDark

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
