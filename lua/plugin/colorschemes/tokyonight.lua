---@alias TNSubMod.Variant
---|'night'
---|'moon'
---|'day'
---|'storm'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

local in_tbl = vim.tbl_contains

--- A colorscheme class for the `tokyonight.nvim` colorscheme.
--- ---
---@class TNSubMod
local TokyoNight = {}

---@type (TNSubMod.Variant)[]
TokyoNight.variants = {
    'storm',
    'night',
    'moon',
    'day',
}

TokyoNight.mod_cmd = 'silent! colorscheme tokyonight'

---@return boolean
function TokyoNight.valid()
    return exists('tokyonight')
end

---@param variant? TNSubMod.Variant
---@param transparent? boolean
---@param override? tokyonight.Config
function TokyoNight.setup(variant, transparent, override)
    variant = (is_str(variant) and in_tbl(TokyoNight.variants, variant)) and variant or 'moon'
    transparent = is_bool(transparent) and transparent or false
    override = is_tbl(override) and override or {}

    local TN = require('tokyonight')
    local Opts = {
        cache = true,

        ---@param colors ColorScheme|table
        on_colors = function(colors)
            colors.error = '#df4f4f'
            colors.info = colors.teal
        end,

        terminal_colors = true,
        transparent = transparent and not in_console(),

        sidebars = {
            'NvimTree',
            'TelescopePrompt',
            'diffview',
            'help',
            'lazy',
            'noice',
            'packer',
            'qf',
            'terminal',
            'toggleterm',
            'trouble',
            'vista_kind',
        },

        style = variant,
        live_reload = true,

        use_background = true,
        hide_inactive_statusline = true,
        lualine_bold = false,
        styles = {
            comments = { italic = false },
            keywords = { italic = false, bold = true },
            functions = { bold = true, italic = false },
            variables = { italic = false },
            sidebars = 'dark',
            floats = 'dark',
        },

        plugins = {
            all = package.loaded.lazy ~= nil,
            auto = true,
        },
    }

    TN.setup(vim.tbl_deep_extend('keep', override, Opts))

    vim.cmd(TokyoNight.mod_cmd)
end

return TokyoNight

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
