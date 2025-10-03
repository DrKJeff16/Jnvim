---@alias KPSubMod.Variant 'ink'|'canvas'

---A submodule class for the `kanagawa-paper` colorscheme.
--- ---
---@class KPSubMod
local M = {}

---@class KPSubMod.Variants
M.variants = { 'ink', 'canvas' }
M.mod_cmd = 'silent! colorscheme kanagawa-paper'

---@return boolean
function M.valid()
    return require('user_api.check.exists').module('kanagawa-paper')
end

---@param variant? KPSubMod.Variant|'auto'
---@param transparent? boolean
---@param override? table
function M.setup(variant, transparent, override)
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
    variant = vim.list_contains({ 'ink', 'canvas', 'auto' }) and variant or 'auto'
    transparent = transparent ~= nil and transparent or false
    override = override or {}
    local opts = vim.tbl_deep_extend('force', {
        undercurl = true,
        gutter = true,
        diag_background = true,
        dim_inactive = true,
        terminal_colors = true,
        cache = true,
        styles = {
            comment = { italic = false },
            functions = { italic = false, bold = true },
            keyword = { italic = false, bold = true },
            statement = { italic = false, bold = true },
            type = { italic = false },
        },
        colors = {
            palette = {},
            theme = {
                ink = {},
                canvas = {},
            },
        },
        -- adjust overall color balance for each theme [-1, 1]
        color_balance = {
            ink = { brightness = 0, saturation = 0 },
            canvas = { brightness = 0, saturation = 0 },
        },
        overrides = function(_)
            return {}
        end,
        auto_plugins = true,
        -- enable highlights for all plugins (disabled if using lazy.nvim)
        all_plugins = package.loaded.lazy == nil,
        -- check the `groups/plugins` directory for the exact names
        plugins = {
            blink = true,
            bufferline = true,
            flash = true,
            gitsigns = true,
            indent_blankline = true,
            lazy = true,
            mini = true,
            neo_tree = true,
            noice = true,
            nvim_notify = true,
            nvim_treesitter_context = true,
            rainbow_delimiters = true,
            telescope = true,
            trouble = true,
            which_key = true,
        },
        integrations = {
            wezterm = {
                enabled = true,
                path = (os.getenv('TEMP') or '/tmp') .. '/nvim-theme',
            },
        },
    }, { _theme = variant, transparent = transparent }, override)
    require('kanagawa-paper').setup(opts)
    vim.cmd(M.mod_cmd)
end

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
