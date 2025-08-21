local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@class GruvboxSubMod
local Gruvbox = {}

Gruvbox.mod_cmd = 'silent! colorscheme gruvbox'

---@return boolean
function Gruvbox.valid()
    return exists('gruvbox')
end

---@param transparent? boolean
---@param override? table|GruvboxConfig
function Gruvbox.setup(transparent, override)
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

    vim.cmd(Gruvbox.mod_cmd)
end

return Gruvbox

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
