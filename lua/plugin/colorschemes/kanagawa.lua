---@alias KanagawaSubMod.Variant ('dragon'|'wave'|'lotus')

---@class KanagawaSubMod.Variants
---@field [1] 'dragon'
---@field [2] 'wave'
---@field [3] 'lotus'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl
local in_console = Check.in_console

--- A `CscSubMod` variant but for the `kanagawa` colorscheme.
--- ---
---@class KanagawaSubMod
local Kanagawa = {}

---@type KanagawaSubMod.Variants
Kanagawa.variants = {
    'dragon',
    'wave',
    'lotus',
}

Kanagawa.mod_cmd = 'silent! colorscheme kanagawa'

---@return boolean
function Kanagawa.valid()
    return exists('kanagawa')
end

---@param variant? KanagawaSubMod.Variant
---@param transparent? boolean
---@param override? KanagawaConfig
function Kanagawa.setup(variant, transparent, override)
    variant = (is_str(variant) and vim.tbl_contains(Kanagawa.variants, variant)) and variant
        or 'dragon'
    transparent = is_bool(transparent) and transparent or false
    override = is_tbl(override) and override or {}

    local KANAGAWA_COMPILE = true
    local KGW = require('kanagawa')

    ---@type KanagawaConfig
    local DEFAULTS = {
        compile = KANAGAWA_COMPILE, -- enable compiling the colorscheme
        undercurl = not in_console(), -- enable undercurls

        commentStyle = { italic = false },
        functionStyle = { bold = true, italic = false },
        keywordStyle = { bold = true, italic = false },
        statementStyle = { bold = true, italic = false },
        typeStyle = { italic = false, bold = true },

        transparent = transparent and not in_console(), -- do not set background color
        dimInactive = not in_console(), -- dim inactive window `:h hl-NormalNC`
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
            dark = variant ~= 'lotus' and variant or 'dragon', -- try "dragon" !
            light = 'lotus',
        },
    }

    KGW.setup(vim.tbl_deep_extend('keep', override, DEFAULTS))

    vim.cmd(Kanagawa.mod_cmd)
end

function Kanagawa.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Kanagawa })
end

User.register_plugin('plugin.colorschemes.kanagawa')

return Kanagawa

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
