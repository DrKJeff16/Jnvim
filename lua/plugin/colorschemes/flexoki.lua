---@alias Flexoki.Variant 'auto'|'dark'|'light'

---@alias Flexoki.Variants (Flexoki.Variant)[]

---@alias Flexoki.FloatWindowStyle 'auto'|'border'|'solid'|'borderless'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

---A submodule class for the `flexoki-nvim` colorscheme.
--- ---
---@class FlexokiSubMod
local Flexoki = {}

---@type Flexoki.Variants
Flexoki.variants = { 'auto', 'dark', 'light' }

Flexoki.mod_cmd = 'silent! colorscheme flexoki'

---@return boolean
function Flexoki.valid()
    return exists('flexoki')
end

---@param variant? Flexoki.Variant
---@param overrides? FlexokiOptions
function Flexoki.setup(variant, overrides)
    local Flex = require('flexoki')

    ---@type FlexokiOptions
    local Opts = {
        ---Set the desired variant: 'auto' will follow the vim background,
        ---defaulting to 'main' for dark and 'dawn' for light. To change the dark
        ---variant, use `options.dark_variant = 'moon'`.
        ---@type Flexoki.Variant
        variant = variant or 'moon',

        ---Set the desired dark variant: applies when `options.variant` is set to
        ---'auto' to match `vim.o.background`.
        ---@type Flexoki.Variant?
        dark_variant = 'dark',

        ---Set the desired light variant: applies when `options.variant` is set to
        ---'auto' to match `vim.o.background`
        ---@type Flexoki.Variant?
        light_variant = 'light',

        ---The style to use for float windows, `winborder == 'none'` works best
        ---with a different background than code, while all the other ones work
        ---best with the same one, 'auto' will check `vim.opt.winborder` when
        ---applying the colorscheme to decide
        ---@type Flexoki.FloatWindowStyle?
        float_window_style = 'auto',

        ---@type table<string, vim.api.keyset.highlight>?
        highlight_groups = {},
    }

    Flex.setup(vim.tbl_deep_extend('keep', overrides or {}, Opts))

    vim.cmd(Flexoki.mod_cmd)
end

return Flexoki

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
