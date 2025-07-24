---@diagnostic disable:missing-fields

---@alias CpcSubMod.Variant ('frappe'|'latte'|'macchiato'|'mocha')

---@class CpcSubMod.Variants
---@field [1] 'frappe'
---@field [2] 'macchiato'
---@field [3] 'mocha'
---@field [4] 'latte'

--- A submodule class for the `catppuccin.nvim` colorscheme
--- ---
---@class CpcSubMod
---@field variants CpcSubMod.Variants
---@field setup fun(self: CpcSubMod, variant: CpcSubMod.Variant?, transparent: boolean?, override: table|CatppuccinOptions?)
---@field valid fun(): boolean
---@field mod_cmd string
---@field new fun(O: table?): table|CpcSubMod

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type CpcSubMod
local Catppuccin = {
    ---@type CpcSubMod.Variants
    variants = {
        'frappe',
        'macchiato',
        'mocha',
        'latte',
    },
    mod_cmd = 'silent! colorscheme catppuccin',
}

---@return boolean
function Catppuccin.valid()
    return exists('catppuccin')
end

---@param self CpcSubMod
---@param variant? CpcSubMod.Variant
---@param transparent? boolean
---@param override? table|CatppuccinOptions
function Catppuccin:setup(variant, transparent, override)
    variant = (is_str(variant) and vim.tbl_contains(self.variants, variant)) and variant
        or self.variants[1]
    transparent = is_bool(transparent) and transparent or false

    ---@type CatppuccinOptions
    local Opts = {
        flavour = variant, -- latte, frappe, macchiato, mocha
        -- flavour = "auto" -- will respect terminal's background
        background = { -- :h background
            light = 'latte',
            dark = variant ~= 'latte' and variant or 'mocha',
        },
        transparent_background = transparent and not in_console(), -- disables setting the background color
        show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = true, -- dims the background color of inactive window
            shade = 'dark',
            percentage = 0.20, -- percentage of the shade to apply to the inactive window
        },
        no_italic = true, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = { 'altfont' }, -- Change the style of comments
            conditionals = { 'bold' },
            loops = { 'bold' },
            functions = { 'bold' },
            keywords = { 'altfont' },
            strings = { 'altfont' },
            variables = { 'altfont' },
            numbers = { 'altfont' },
            booleans = { 'bold' },
            properties = { 'bold' },
            types = { 'undercurl' },
            operators = { 'altfont' },
            -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },

        color_overrides = {},
        custom_highlights = function(colors)
            return {
                NvimTreeNormal = { fg = colors.none },
                CmpBorder = { fg = colors.surface2 },
                Pmenu = { bg = colors.none },
                TabLineSel = { bg = colors.pink },
            }
        end,

        default_integrations = true,
        integrations = {
            barbar = exists('barbar'),
            blink_cmp = {
                style = 'bordered',
            },
            colorful_winsep = {
                enabled = exists('colorful-winsep'),
                color = 'teal',
            },
            cmp = exists('cmp'),
            dashboard = exists('dashboard'),
            diffview = exists('diffview'),
            gitsigns = exists('gitsigns'),
            headlines = exists('headlines'),
            indent_blankline = {
                enabled = exists('ibl'),
                scope_color = 'teal',
                colored_indent_levels = true,
            },
            lsp_trouble = exists('trouble'),
            markdown = true,
            mini = {
                enabled = true,
                indentscope_color = 'lavender',
            },
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { 'bold', 'underdouble' },
                    warnings = { 'bold', 'underline' },
                    hints = { 'bold', 'underline' },
                    information = { 'altfont', 'underline' },
                    ok = { 'bold' },
                },
                underlines = {
                    errors = { 'underdouble' },
                    hints = { 'underline' },
                    warnings = { 'underline' },
                    information = { 'underline' },
                    ok = { 'underline' },
                },
                inlay_hints = { background = true },
            },
            noice = exists('noice'),
            notify = exists('notify'),
            nvimtree = exists('nvim-tree'),
            rainbow_delimiters = exists('rainbow-delimiters'),
            telescope = {
                enabled = exists('telescope'),
                -- style = 'nvchad',
            },
            treesitter = exists('nvim-treesitter'),
            treesitter_context = exists('treesitter-context'),
            which_key = exists('which-key'),
            -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
    }

    override = is_tbl(override) and override or {}

    require('catppuccin').setup(vim.tbl_deep_extend('keep', override, Opts))

    vim.cmd(self.mod_cmd)
end

---@param O? table
---@return CpcSubMod|table
function Catppuccin.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Catppuccin })
end

User.register_plugin('plugin.colorschemes.catppuccin')

return Catppuccin

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
