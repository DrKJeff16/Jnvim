---@alias ConiferSubMod.Variant 'lunar'|'solar'

local exists = require('user_api.check.exists').module

---A submodule class for the `conifer.nvim` colorscheme.
--- ---
---@class ConiferSubMod
local Conifer = {}

---@class ConiferSubMod.Variants
Conifer.variants = { 'lunar', 'solar' }

Conifer.mod_cmd = 'silent! colorscheme conifer'

---@return boolean
function Conifer.valid()
    return exists('conifer')
end

---@param variant? ConiferSubMod.Variant
---@param transparent? boolean
---@param overrides? table
function Conifer.setup(variant, transparent, overrides)
    variant = variant or 'lunar'
    transparent = transparent ~= nil and transparent or false
    require('conifer').setup(
        vim.tbl_deep_extend(
            'keep',
            { variant = variant },
            { transparent = transparent },
            overrides or {},
            {
                styles = {
                    comments = {},
                    functions = {},
                    keywords = {},
                    lsp = {},
                    match_paren = {},
                    type = {},
                    variables = {},
                },
            }
        )
    )

    vim.cmd(Conifer.mod_cmd .. '-' .. variant)
end

return Conifer
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
