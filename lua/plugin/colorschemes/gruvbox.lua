---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module

---@type CscSubMod
local M = {
    mod_pfx = 'plugin.colorschemes.gruvbox',
    mod_cmd = 'colorscheme gruvbox',
}

if exists('gruvbox') then
    function M.setup()
        local GVBX = require('gruvbox')

        GVBX.setup({
            transparent_mode = false,
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
        })

        vim.cmd(M.mod_cmd)
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
