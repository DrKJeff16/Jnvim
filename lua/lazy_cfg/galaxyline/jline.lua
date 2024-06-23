---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local Highlight = User.highlight

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local empty = Check.value.empty

if not exists('galaxyline') then
    return
end

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opt_get = vim.api.nvim_get_option_value

local GROUP = augroup('JLine', { clear = false })

local Devicons = require('nvim-web-devicons')
local GL = require('galaxyline')
local Extensions = require('galaxyline.provider_extensions')

local JLineUtils = require('lazy_cfg.galaxyline.util').new('tokyonight')

local default_colors = JLineUtils:palette()

_G.VistaPlugin = Extensions.vista_nearest

GL.short_line_list = {
    'LuaTree',
    'NvimTree',
    'vista',
    'dbui',
    'startify',
    'term',
    'toggleterm',
    'nerdtree',
    'fugitive',
    'fugitiveblame',
    'plug',
    'plugins',
}

local Providers = {
    -- source provider function
    diagnostic = require('galaxyline.provider_diagnostic'),
    vcs = require('galaxyline.provider_vcs'),
    fileinfo = require('galaxyline.provider_fileinfo'),
    colors = require('galaxyline.colors'),
    buffer = require('galaxyline.provider_buffer'),
    whitespace = require('galaxyline.provider_whitespace'),
    lsp = require('galaxyline.provider_lsp'),
}

--- Set buffer variables for file icon and color.
---@return { color: string, icon: string }
local function buf_init_devicons()
    local icon, color = Devicons.get_icon(vim.fn.expand('%:t'), vim.fn.expand('%:e'), { default = true })
    local dev_icons = { color = vim.api.nvim_get_hl(0, { link = false, name = color }).fg, icon = icon }

    vim.b.dev_icons = dev_icons
    return dev_icons
end

--- @return { color: string, icon: string }
local function filetype_info()
    return vim.b.dev_icons or buf_init_devicons()
end

local SEPARATORS = {
    --- Components separated by this component will be padded with an equal number of spaces.
    align = { provider = '%=' },
    --- A left separator.
    left_separator = { provider = '' },
    --- A right separator.
    right_separator = { provider = ' ' },
}
---@class JLine.Highlight.Spec

---@class JLine.Section.Component
---@field condition? boolean
---@field highlight? JLine.Highlight.Spec
---@field separator_highlight? JLine.Highlight.Spec
---@field icon? string
---@field provider string|fun(...): string
---@field separator? string

---@alias JLine.Section JLine.Section.Component[]

---@type JLine.Section
GL.section.left[1] = {
    ViMode = {
        provider = function()
            -- auto change color() according the vim mode
            local mode_colorpairs = {
                R = { default_colors.magenta, default_colors.bg_visual },
                Rv = { default_colors.magenta, default_colors.bg_visual },
                S = { default_colors.orange, default_colors.dark3 },
                V = { default_colors.orange, default_colors.bg_visual },
                ['!'] = { default_colors.magenta, default_colors.cyan },
                [''] = { default_colors.blue, 'NONE' },
                ['r?'] = { default_colors.cyan, default_colors.bg_visual },
                c = { default_colors.red, default_colors.bg_float },
                ce = { default_colors.red, default_colors.bg_float },
                cv = { default_colors.red, default_colors.bg_float },
                i = { default_colors.blue, default_colors.bg_statusline },
                ic = { default_colors.yellow, default_colors.bg_sidebar },
                n = { default_colors.green, default_colors.bg_statusline },
                no = { default_colors.magenta, default_colors.bg },
                r = { default_colors.red, default_colors.bg },
                rm = { default_colors.red, default_colors.bg },
                s = { default_colors.orange, default_colors.bg },
                t = { default_colors.green, default_colors.bg },
                v = { default_colors.orange, default_colors.bg },
            }
            local vim_mode = vim.fn.mode()
            ---@see HlPair
            Highlight.hl_from_arr({
                {
                    name = 'GalaxyViMode',
                    opts = { fg = mode_colorpairs[vim_mode][1], bg = mode_colorpairs[vim_mode][2] },
                },
            })
            return string.upper('  ' .. vim_mode .. '')
            -- return string.upper('  ' .. vim_mode .. '   ')
        end,

        separator = SEPARATORS.right_separator.provider,
    },
}

---@type JLine.Section
GL.section.left[2] = {
    ---@type JLine.Section.Component
    FileSize = {
        provider = 'FileSize',
        condition = function()
            return empty(vim.fn.expand('%:t')) ~= 1
        end,

        icon = '  ',
        highlight = { default_colors.teal, default_colors.bg_float },
        separator = SEPARATORS.right_separator.provider,
        separator_highlight = { default_colors.purple, default_colors.terminal_black },
    },

    ---@type JLine.Section.Component
    GitBranch = {
        provider = 'GitBranch',
        condition = Providers.vcs.check_git_workspace,
        icon = '  ',
        separator_highlight = { default_colors.pink, default_colors.bg_popup },
        separator = SEPARATORS.right_separator.provider,
    },
}

GL.load_galaxyline()
