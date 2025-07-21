---@diagnostic disable:missing-fields

---@alias NFoxSubMod.Variant ('nightfox'|'carbonfox'|'dayfox'|'dawnfox'|'duskfox'|'nordfox'|'terafox')

---@class NFoxSubMod.Variants
---@field [1] 'carbonfox'
---@field [2] 'nightfox'
---@field [3] 'dawnfox'
---@field [4] 'dayfox'
---@field [5] 'duskfox'
---@field [6] 'nordfox'
---@field [7] 'terafox'

--- A colorscheme class for the `nightfox.nvim` colorscheme
--- ---
---@class NFoxSubMod
---@field variants NFoxSubMod.Variants
---@field setup fun(self: NFoxSubMod, variant: NFoxSubMod.Variant?, transparent: boolean?, override: table?)
---@field valid fun(): boolean
---@field mod_cmd string
---@field new fun(O: table?): table|NFoxSubMod

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type NFoxSubMod
local Nightfox = {
    variants = {
        'carbonfox',
        'nightfox',
        'dawnfox',
        'dayfox',
        'duskfox',
        'nordfox',
        'terafox',
    },
    mod_cmd = 'silent! colorscheme ', -- Leave a whitespace for variant selection
}

---@return boolean
function Nightfox.valid()
    return exists('nightfox')
end

---@param self NFoxSubMod
---@param variant? NFoxSubMod.Variants
---@param transparent? boolean
---@param override? table
function Nightfox:setup(variant, transparent, override)
    variant = (is_str(variant) and vim.tbl_contains(self.variants, variant)) and variant
        or self.variants[1]
    transparent = is_bool(transparent) and transparent or false
    override = is_tbl(override) and override or {}

    local compile_path = vim.fn.stdpath('state') .. '/nightfox'

    local NF = require('nightfox')

    NF.setup(vim.tbl_deep_extend('keep', override, {
        options = {
            -- Compiled file's destination location
            compile_path = compile_path,
            compile_file_suffix = '_compiled', -- Compiled file suffix
            transparent = not in_console() and transparent or false, -- Disable setting background
            terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
            dim_inactive = false, -- Non focused panes set to alternative background
            module_default = false, -- Default enable value for modules
            colorblind = { enable = false }, -- Disable colorblind support
            styles = { -- Style to be applied to different syntax groups
                comments = 'altfont', -- Value is any valid attr-list value `:help attr-list`
                conditionals = 'bold',
                constants = 'bold',
                functions = 'bold',
                keywords = 'bold',
                numbers = 'NONE',
                operators = 'NONE',
                preprocs = 'bold',
                strings = 'altfont',
                types = 'bold',
                variables = 'altfont',
            },

            inverse = { -- Inverse highlight for different types
                match_paren = false,
                visual = false,
                search = false,
            },

            modules = { -- List of various plugins and additional options
                barbar = exists('barbar'),
                blink = true,
                coc = { enable = false, background = true },
                cmp = exists('cmp'),
                dashboard = exists('dashboard'),
                diagnostic = { enable = true, background = true },
                fern = false,
                fidget = false,
                gitgutter = false,
                gitsigns = exists('gitsigns'),
                glyph_palette = true,
                hop = false,
                illuminate = false,
                indent_blanklines = exists('ibl'),
                lazy = exists('lazy'),
                leap = { enable = false, background = true, harsh = false },
                lsp_semantic_tokens = true,
                mini = true,
                native_lsp = { enable = true, background = true },
                notify = true,
                nvimtree = exists('nvim-tree'),
                pounce = true,
                telescope = exists('telescope'),
                treesitter = true,
                whichkey = true,
            },
        },
    }))

    vim.cmd(self.mod_cmd .. variant)

    NF.compile()
end

---@param O? table
---@return NFoxSubMod|table
function Nightfox.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = Nightfox })
end

User:register_plugin('plugin.colorschemes.nightfox')

return Nightfox

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
