local User = require('user_api')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type CscSubMod
local M = {
    mod_cmd = 'colorscheme gruvbox',
    setup = nil,
}

if exists('gruvbox') then
    User.register_plugin('plugin.colorschemes.gruvbox')
    function M.setup(variant, transparent, override)
        transparent = is_bool(transparent) and transparent or false
        override = is_tbl(override) and override or {}

        local GVBX = require('gruvbox')

        GVBX.setup(vim.tbl_extend('keep', override, {
            transparent_mode = transparent,
            dim_inactive = true,
            terminal_colors = true,
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                comments = true,
                emphasis = true,
                folds = true,
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

        vim.cmd(M.mod_cmd)
    end
end

function M.new() return setmetatable({}, { __index = M }) end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
