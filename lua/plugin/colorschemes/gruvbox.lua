---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type CscSubMod
local M = {
    mod_cmd = 'colorscheme gruvbox',
}

if exists('gruvbox') then
    function M:setup(variant, transparent, override)
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

        vim.cmd(self.mod_cmd)
    end
end

function M.new()
    return setmetatable({}, { __index = M })
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
