---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type CscSubMod
local M = {
    ---@type ('frappe'|'latte'|'macchiato'|'mocha')[]
    variants = {
        'frappe',
        'latte',
        'macchiato',
        'mocha',
    },
    mod_cmd = 'colorscheme catppuccin',
}

if exists('catppuccin') then
    ---@param variant? 'frappe'|'macchiato'|'mocha'|'latte'
    ---@param transparent? boolean
    ---@param override? table
    function M:setup(variant, transparent, override)
        variant = (is_str(variant) and not vim.tbl_contains(self.variants, variant)) and variant or 'macchiato'
        transparent = is_bool(transparent) and transparent or false
        override = is_tbl(override) and override or {}

        local Cppc = require('catppuccin')

        Cppc.setup(vim.tbl_extend('keep', override, {
            flavour = variant, -- latte, frappe, macchiato, mocha
            -- flavour = "auto" -- will respect terminal's background
            background = { -- :h background
                light = 'latte',
                dark = variant ~= 'latte' and variant or 'mocha',
            },
            transparent_background = transparent, -- disables setting the background color.
            show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
            term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
            dim_inactive = {
                enabled = true, -- dims the background color of inactive window
                shade = 'dark',
                percentage = 0.20, -- percentage of the shade to apply to the inactive window
            },
            no_italic = false, -- Force no italic
            no_bold = false, -- Force no bold
            no_underline = false, -- Force no underline
            styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
                comments = { 'altfont' }, -- Change the style of comments
                conditionals = { 'bold' },
                loops = { 'bold' },
                functions = { 'bold' },
                keywords = { 'italic' },
                strings = { 'italic' },
                variables = { 'altfont' },
                numbers = { 'altfont' },
                booleans = { 'altfont' },
                properties = { 'altfont' },
                types = { 'undercurl' },
                operators = { 'altfont' },
                -- miscs = {}, -- Uncomment to turn off hard-coded styles
            },

            color_overrides = {},
            custom_highlights = {},

            default_integrations = true,
            integrations = {
                barbar = exists('barbar'),
                colorful_winsep = {
                    enabled = exists('colorful-winsep'),
                    color = 'teal',
                },
                cmp = exists('cmp'),
                dashboard = exists('dashboard'),
                diffview = exists('diffview'),
                gitsigns = exists('gitsigns'),
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
                        errors = { 'bold', 'undercurl' },
                        warnings = { 'underline' },
                        hints = { 'italic' },
                        information = { 'altfont', 'underline' },
                        ok = { 'bold' },
                    },
                    underlines = {
                        errors = { 'underline' },
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
        }))

        vim.cmd(self.mod_cmd)
    end
end

function M.new()
    return setmetatable({}, { __index = M })
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
