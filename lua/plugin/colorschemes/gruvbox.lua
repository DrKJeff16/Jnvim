---@diagnostic disable:missing-fields

---@module 'plugin._types.colorschemes'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type CscSubMod
local Gruvbox = {
    mod_cmd = 'silent! colorscheme gruvbox',
}

function Gruvbox.valid()
    return exists('gruvbox')
end

function Gruvbox:setup(variant, transparent, override)
    variant = variant or nil
    transparent = is_bool(transparent) and transparent or false
    override = is_tbl(override) and override or {}

    require('gruvbox').setup(vim.tbl_deep_extend('keep', override, {
        transparent_mode = transparent and not in_console(),
        dim_inactive = true,
        terminal_colors = true,

        undercurl = true,
        underline = true,
        bold = true,
        italic = {
            comments = false,
            emphasis = false,
            folds = false,
            operators = false,
            strings = false,
        },
        strikethrough = true,

        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = false,

        contrast = 'soft',
        overrides = {},
        palette_overrides = {},
    }))

    vim.cmd(self.mod_cmd)
end

function Gruvbox.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Gruvbox })
end

User:register_plugin('plugin.colorschemes.gruvbox')

return Gruvbox

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
