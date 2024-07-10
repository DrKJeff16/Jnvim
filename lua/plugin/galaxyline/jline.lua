---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local Highlight = User.highlight
local Types = User.types.galaxyline

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

local JLineUtils = require('plugin..galaxyline.util')

local default_colors = JLineUtils.themes.catppuccin_frappe

_G.VistaPlugin = Extensions.vista_nearest

GL.short_line_list = {
    'LuaTree',
    'NvimTree',
    'dbui',
    'fugitive',
    'fugitiveblame',
    'lazy',
    'nerdtree',
    'plug',
    'plugins',
    'startify',
    'term',
    'toggleterm',
    'vista',
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

---@type JLine.Section
GL.section.left[1] = {
    ViMode = {
        provider = function()
            -- auto change color() according the vim mode
            local mode_colorpairs = {
                R = { default_colors.magenta, default_colors.darkblue },
                Rv = { default_colors.magenta, default_colors.bg },
                S = { default_colors.orange, default_colors.bg },
                V = { default_colors.orange, default_colors.bg },
                ['!'] = { default_colors.magenta, default_colors.cyan },
                [''] = { default_colors.blue, 'NONE' },
                ['r?'] = { default_colors.cyan, default_colors.bg },
                c = { default_colors.red, default_colors.bg },
                ce = { default_colors.red, default_colors.bg },
                cv = { default_colors.red, default_colors.bg },
                i = { default_colors.blue, default_colors.bg },
                ic = { default_colors.yellow, default_colors.bg },
                n = { default_colors.green, default_colors.bg },
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
        highlight = { default_colors.cyan, default_colors.bg },
        separator = SEPARATORS.right_separator.provider,
        separator_highlight = { default_colors.violet, default_colors.bg },
    },

    ---@type JLine.Section.Component
    GitBranch = {
        provider = 'GitBranch',
        condition = Providers.vcs.check_git_workspace,
        icon = '  ',
        separator_highlight = { default_colors.cyan, default_colors.bg },
        separator = SEPARATORS.right_separator.provider,
    },
}

GL.load_galaxyline()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
