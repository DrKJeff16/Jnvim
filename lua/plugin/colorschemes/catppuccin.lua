---@alias CpcSubMod.Variant ('frappe'|'latte'|'macchiato'|'mocha')

--- A submodule class for the `catppuccin.nvim` colorscheme.
--- ---
---@class CpcSubMod
local Catppuccin = {}

---@class CpcSubMod.Variants
Catppuccin.variants = { 'frappe', 'macchiato', 'mocha', 'latte' }
Catppuccin.mod_cmd = 'silent! colorscheme catppuccin'

---@return boolean
function Catppuccin.valid()
    return require('user_api.check.exists').module('catppuccin')
end

---@param variant? CpcSubMod.Variant
---@param transparent? boolean
---@param override? CatppuccinOptions
function Catppuccin.setup(variant, transparent, override)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('variant', variant, 'string', true)
        vim.validate('transparent', transparent, 'boolean', true)
        vim.validate('override', override, 'table', true)
    else
        vim.validate({
            variant = { variant, { 'string', 'nil' } },
            transparent = { transparent, { 'boolean', 'nil' } },
            override = { override, { 'table', 'nil' } },
        })
    end
    variant = variant or 'auto'
    variant = vim.list_contains(Catppuccin.variants, variant) and variant or 'auto'
    transparent = transparent ~= nil and transparent or false
    override = override or {}

    ---@type CatppuccinOptions
    local Opts = {
        flavour = 'auto', -- will respect terminal's background
        background = { light = 'latte', dark = variant ~= 'latte' and variant or 'mocha' },
        default_integrations = true,
        float = { solid = true, transparent = true },
        transparent_background = transparent and not require('user_api.check').in_console(), -- disables setting the background color
        show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = { enabled = true, shade = 'dark', percentage = 0.20 },
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
            types = { 'altfont' },
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
        integrations = {
            alpha = true,
            barbar = true,
            blink_cmp = { style = 'bordered' },
            cmp = false,
            diffview = true,
            fzf = true,
            gitsigns = true,
            headlines = false,
            indent_blankline = {
                enabled = true,
                scope_color = 'teal',
                colored_indent_levels = true,
            },
            lsp_trouble = true,
            markdown = true,
            mini = { enabled = true, indentscope_color = 'lavender' },
            native_lsp = {
                enabled = true,
                inlay_hints = { background = true },
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
            },
            neotree = true,
            noice = true,
            notify = true,
            nvimtree = false,
            rainbow_delimiters = true,
            render_markdown = true,
            telescope = { enabled = true },
            treesitter = true,
            treesitter_context = true,
            which_key = true,
        },
    }
    require('catppuccin').setup(vim.tbl_deep_extend('keep', override, Opts))
    vim.cmd(Catppuccin.mod_cmd)
end

return Catppuccin
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
