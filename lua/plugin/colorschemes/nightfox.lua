---@alias NFoxSubMod.Variant
---|'nightfox'
---|'carbonfox'
---|'dayfox'
---|'dawnfox'
---|'duskfox'
---|'nordfox'
---|'terafox'

---@alias NFoxSubMod.Variants (NFoxSubMod.Variant)[]

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

local in_tbl = vim.tbl_contains

--- A colorscheme class for the `nightfox.nvim` colorscheme.
--- ---
---@class NFoxSubMod
local Nightfox = {}

---@type NFoxSubMod.Variants
Nightfox.variants = {
    'carbonfox',
    'nightfox',
    'dawnfox',
    'dayfox',
    'duskfox',
    'nordfox',
    'terafox',
}

Nightfox.mod_cmd = 'silent! colorscheme '

---@return boolean
function Nightfox.valid()
    return exists('nightfox')
end

---@param variant? NFoxSubMod.Variants
---@param transparent? boolean
---@param override? table
function Nightfox.setup(variant, transparent, override)
    variant = (is_str(variant) and in_tbl(Nightfox.variants, variant)) and variant
        or Nightfox.variants[1]
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

    vim.cmd(Nightfox.mod_cmd .. variant)

    NF.compile()
end

return Nightfox

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
