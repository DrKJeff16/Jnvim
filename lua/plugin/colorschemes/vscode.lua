---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type CscSubMod
local VSCode = {
    mod_cmd = 'colorscheme vscode', -- Leave a whitespace for variant selection
    setup = nil,
}

if exists('vscode') then
    User:register_plugin('plugin.colorschemes.vscode')

    ---@param self CscSubMod
    ---@param variant? any
    ---@param transparent? boolean
    ---@param override? table
    function VSCode:setup(variant, transparent, override)
        transparent = is_bool(transparent) and transparent or false
        override = is_tbl(override) and override or {}

        local C = require('vscode.colors').get_colors()

        require('vscode').setup(vim.tbl_extend('keep', override, {
            style = 'dark',
            transparent = transparent,
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
end

function VSCode.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = VSCode })
end

return VSCode

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
