---@alias VSCodeSubMod.Variant
---|'dark'
---|'light'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_bool = Check.value.is_bool
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl

local in_tbl = vim.tbl_contains

--- A colorscheme table for the `vscode.nvim` colorscheme.
--- ---
---@class VSCodeSubMod
local VSCode = {}

---@type (VSCodeSubMod.Variant)[]
VSCode.variants = {
    'dark',
    'light',
}

VSCode.mod_cmd = 'silent! colorscheme vscode'

---@return boolean
function VSCode.valid()
    return exists('vscode')
end

---@param variant? (VSCodeSubMod.Variant)[]
---@param transparent? boolean
---@param override? table
function VSCode.setup(variant, transparent, override)
    variant = (is_str(variant) and in_tbl(VSCode.variants, variant)) and variant or 'dark'
    transparent = is_bool(transparent) and transparent or false
    override = is_tbl(override) and override or {}

    local C = require('vscode.colors').get_colors()

    require('vscode').setup(vim.tbl_extend('keep', override, {
        style = variant,
        transparent = transparent and not in_console(),
        italic_comments = false,
        underline_links = true,
        disable_nvimtree_bg = false,
        color_overrides = {},
        group_overrides = {
            -- this supports the same val table as vim.api.nvim_set_hl
            -- use colors from this colorscheme by requiring vscode.colors!
            Cursor = { fg = C.vscDarkBlue, bg = C.vscLightGreen, bold = true },
        },
    }))

    require('vscode').load()

    vim.cmd(VSCode.mod_cmd)
end

return VSCode

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
