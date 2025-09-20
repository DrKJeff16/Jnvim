---@alias GruvDarkSubMod.Variant 'gruvdark'|'gruvdark-light'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_bool = Check.value.is_bool

local in_tbl = vim.tbl_contains

---A submodule class for the `<NAME>` colorscheme.
--- ---
---@class GruvDarkSubMod
local GruvDark = {}

---@class GruvDarkSubMod.Variants
GruvDark.variants = {
    'gruvdark',
    'gruvdark-light',
}

GruvDark.mod_cmd = 'silent! colorscheme '

---@return boolean
function GruvDark.valid()
    return exists('gruvdark')
end

---@param variant? GruvDarkSubMod.Variant
---@param transparent? boolean
---@param overrides? GruvDarkSubMod.Opts
function GruvDark.setup(variant, transparent, overrides)
    variant = (is_str(variant) and in_tbl(GruvDark.variants, variant)) and variant
        or GruvDark.variants[1]
    transparent = is_bool(transparent) and transparent or false
    overrides = is_tbl(overrides) and overrides or {}

    ---@class GruvDarkSubMod.Opts
    local Opts = {
        transparent = transparent, -- Show or hide background
        colors = {}, -- Override default colors
        highlights = {}, -- Override highlight groups}
    }

    require('gruvdark').setup(vim.tbl_deep_extend('keep', overrides, Opts))

    vim.cmd(GruvDark.mod_cmd .. variant)
end

return GruvDark

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
