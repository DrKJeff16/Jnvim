---@alias VSCodeSubMod.Variant
---|'dark'
---|'light'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_bool = Check.value.is_bool
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl

--- A colorscheme table for the `vscode` colorscheme
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

---@param self VSCodeSubMod
---@param variant? (VSCodeSubMod.Variant)[]
---@param transparent? boolean
---@param override? table
function VSCode:setup(variant, transparent, override)
    variant = (is_str(variant) and vim.tbl_contains(self.variants, variant)) and variant or 'dark'
    transparent = is_bool(transparent) and transparent or false
    override = is_tbl(override) and override or {}

    local C = require('vscode.colors').get_colors()

    require('vscode').setup(vim.tbl_extend('keep', override, {
        style = 'dark',
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

    vim.cmd(self.mod_cmd)
end

---@param O? table
---@return VSCodeSubMod|table
function VSCode.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = VSCode })
end

User.register_plugin('plugin.colorschemes.vscode')

return VSCode

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
