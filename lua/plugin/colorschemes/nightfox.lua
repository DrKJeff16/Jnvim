---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_t = User.types.colorschemes

local exists = Check.exists.module

---@type CscSubMod
local M = {
    mod_pfx = 'plugin.colorschemes.nightfox',
    mod_cmd = 'colorscheme carbonfox',
}

if exists('nightfox') then
    function M.setup()
        local compile_path = vim.fn.stdpath('cache') .. '/nightfox'

        require('nightfox').setup({
            options = {
                -- Compiled file's destination location
                compile_path = compile_path,
                compile_file_suffix = '_compiled', -- Compiled file suffix
                transparent = false, -- Disable setting background
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
                    cmp = exists('cmp'),
                    dashboard = exists('dashboard'),
                    diagnostic = { enable = true, background = true },
                    gitsigns = exists('gitsigns'),
                    indent_blankline = exists('ibl'),
                    lazy = exists('lazy'),
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
        })

        vim.cmd(M.mod_cmd)

        require('nightfox').compile()
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
