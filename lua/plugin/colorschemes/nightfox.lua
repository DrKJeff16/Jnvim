---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user_api')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type CscSubMod
local M = {
    ---@type ('carbonfox'|'dayfox'|'nightfox'|'dawnfox'|'duskfox'|'nordfox'|'terafox')[]
    variants = {
        'carbonfox',
        'nightfox',
        'dawnfox',
        'dayfox',
        'duskfox',
        'nordfox',
        'terafox',
    },
    mod_cmd = 'colorscheme ', -- Leave a whitespace for variant selection
    setup = nil,
}

if exists('nightfox') then
    ---@param variant? 'carbonfox'|'dayfox'|'nightfox'|'dawnfox'|'duskfox'|'nordfox'|'terafox'
    ---@param transparent? boolean
    ---@param override? table
    function M.setup(variant, transparent, override)
        variant = (is_str(variant) and vim.tbl_contains(M.variants, variant)) and variant or 'carbonfox'
        transparent = is_bool(transparent) and transparent or false
        override = is_tbl(override) and override or {}

        local compile_path = vim.fn.stdpath('cache') .. '/nightfox'

        require('nightfox').setup(vim.tbl_extend('keep', override, {
            options = {
                -- Compiled file's destination location
                compile_path = compile_path,
                compile_file_suffix = '_compiled', -- Compiled file suffix
                transparent = transparent, -- Disable setting background
                terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
                dim_inactive = false, -- Non focused panes set to alternative background
                module_default = false, -- Default enable value for modules
                colorblind = { enable = false }, -- Disable colorblind support
                styles = { -- Style to be applied to different syntax groups
                    comments = 'NONE', -- Value is any valid attr-list value `:help attr-list`
                    conditionals = 'bold',
                    constants = 'bold',
                    functions = 'bold',
                    keywords = 'NONE',
                    numbers = 'NONE',
                    operators = 'NONE',
                    preprocs = 'bold',
                    strings = 'NONE',
                    types = 'bold',
                    variables = 'NONE',
                },

                inverse = { -- Inverse highlight for different types
                    match_paren = false,
                    visual = false,
                    search = false,
                },

                modules = { -- List of various plugins and additional options
                    barbar = exists('barbar'),
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
                    notify = exists('notify'),
                    nvimtree = exists('nvim-tree'),
                    telescope = exists('telescope'),
                    treesitter = exists('treesitter'),
                    whichkey = exists('which-key'),
                },
            },
        }))

        vim.cmd(M.mod_cmd .. variant)

        require('nightfox').compile()
    end
end

function M.new()
    return setmetatable({}, { __index = M })
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
