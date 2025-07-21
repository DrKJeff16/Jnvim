---@diagnostic disable:missing-fields

---@alias TNSubMod.Variant ('night'|'moon'|'day')

---@class TNSubMod.Variants
---@field [1] 'night'
---@field [2] 'moon'
---@field [3] 'day'

--- A colorscheme class for the `tokyonight.nvim` colorscheme
--- ---
---@class TNSubMod
---@field setup fun(self: TNSubMod, variant: TNSubMod.Variant?, transparent: boolean?, override: table?)
---@field variants TNSubMod.Variants
---@field valid fun(): boolean
---@field mod_cmd string
---@field new fun(O: table?): TNSubMod|table

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type TNSubMod
local TokyoNight = {
    ---@type TNSubMod.Variants
    variants = {
        'night',
        'moon',
        'day',
    },
    mod_cmd = 'silent! colorscheme tokyonight',
}

---@return boolean
function TokyoNight.valid()
    return exists('tokyonight')
end

---@param self TNSubMod
---@param variant? TNSubMod.Variant
---@param transparent? boolean
---@param override? tokyonight.Config|table
function TokyoNight:setup(variant, transparent, override)
    variant = (is_str(variant) and vim.tbl_contains(self.variants, variant)) and variant or 'moon'
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

        -- ---@param hl tokyonight.Highlights|table
        -- ---@param c ColorScheme|table
        -- on_highlights = function(hl, c)
        --     local prompt = '#2d3149'
        --     hl.TelescopeNormal = {
        --         bg = c.bg_dark,
        --         fg = c.fg_dark,
        --     }
        --     hl.TelescopeBorder = {
        --         bg = c.bg_dark,
        --         fg = c.bg_dark,
        --     }
        --     hl.TelescopePromptNormal = {
        --         bg = prompt,
        --     }
        --     hl.TelescopePromptBorder = {
        --         bg = prompt,
        --         fg = prompt,
        --     }
        --     hl.TelescopePromptTitle = {
        --         bg = prompt,
        --         fg = prompt,
        --     }
        --     hl.TelescopePreviewTitle = {
        --         bg = c.bg_dark,
        --         fg = c.bg_dark,
        --     }
        --     hl.TelescopeResultsTitle = {
        --         bg = c.bg_dark,
        --         fg = c.bg_dark,
        --     }
        -- end,

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
            all = not is_nil(package.loaded.lazy),
            auto = true,
        },
    }

    TN.setup(vim.tbl_deep_extend('keep', override, Opts))

    vim.cmd(self.mod_cmd)
end

---@param O? table
---@return table|CscSubMod
function TokyoNight.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = TokyoNight })
end

User:register_plugin('plugin.colorschemes.tokyonight')

return TokyoNight

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
