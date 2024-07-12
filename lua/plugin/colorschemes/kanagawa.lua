---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user_api')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type CscSubMod
local M = {
    ---@type ('dragon'|'wave'|'lotus')[]
    variants = {
        'dragon',
        'wave',
        'lotus',
    },
    mod_cmd = 'colorscheme kanagawa',
    setup = nil,
}

if exists('kanagawa') then
    ---@param variant? 'dragon'|'wave'|'lotus'
    ---@param transparent? boolean
    ---@param override? table
    function M.setup(variant, transparent, override)
        variant = (is_str(variant) and not vim.tbl_contains(M.variants, variant)) and variant
            or 'wave'
        transparent = is_bool(transparent) and transparent or false
        override = is_tbl(override) and override or {}

        local kanagawa_compile = true
        local KGW = require('kanagawa')

        KGW.setup(vim.tbl_extend('keep', override, {
            compile = kanagawa_compile, -- enable compiling the colorscheme
            undercurl = true, -- enable undercurls
            commentStyle = { italic = true },
            functionStyle = { bold = true },
            keywordStyle = { bold = true },
            statementStyle = { bold = true },
            typeStyle = { italic = true },
            transparent = transparent, -- do not set background color
            dimInactive = true, -- dim inactive window `:h hl-NormalNC`
            terminalColors = true, -- define vim.g.terminal_color_{0,17}
            colors = { -- add/modify theme and palette colors
                palette = {},
                theme = {
                    wave = {},
                    lotus = {},
                    dragon = {},
                    all = {},
                },
            },
            overrides = function(colors) -- add/modify highlights
                local theme = colors.theme
                return {
                    NormalFloat = { bg = 'none' },
                    FloatBoarder = { bg = 'none' },
                    FloatTitle = { bg = 'none' },

                    NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

                    LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                    MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                    TelescopeTitle = { fg = theme.ui.special, bold = true },
                    TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                    TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                    TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                    TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                    TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                    TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend }, -- add `blend = vim.o.pumblend` to enable transparency
                    PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },
                }
            end,
            theme = variant, -- Load "wave" theme when 'background' option is not set
            background = { -- map the value of 'background' option to a theme
                dark = variant ~= 'lotus' and variant or 'wave', -- try "dragon" !
                light = 'lotus',
            },
        }))

        vim.cmd(M.mod_cmd)
    end
end

function M.new() return setmetatable({}, { __index = M }) end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
