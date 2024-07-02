---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

local User = require('user')
local Check = User.check
local csc_m = User.types.colorschemes

local exists = Check.exists.module

local M = {
    mod_pfx = 'plugin.colorschemes.tokyonight',
    mod_cmd = 'colorscheme tokyonight',
}

if exists('tokyonight') then
    function M.setup()
        local TN = require('tokyonight')

        TN.setup({
            cache = false,

            ---@param colors ColorScheme
            on_colors = function(colors)
                colors.error = '#df4f4f'
            end,

            ---@param hl tokyonight.Highlights
            ---@param c ColorScheme
            on_highlights = function(hl, c)
                local prompt = '#2d3149'
                hl.TelescopeNormal = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.TelescopeBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopePromptNormal = {
                    bg = prompt,
                }
                hl.TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePromptTitle = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopeResultsTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
            end,
            terminal_colors = true,
            transparent = false,
            sidebars = {
                'qf',
                'help',
                'lazy',
                'terminal',
                'toggleterm',
                'packer',
                'TelescopePrompt',
                'vista_kind',
                'NvimTree',
                'trouble',
            },

            style = 'moon',
            live_reload = true,
            use_background = true,
            hide_inactive_statusline = false,
            lualine_bold = false,
            styles = {
                comments = { italic = true },
                keywords = { italic = false, bold = true },
                functions = { bold = true, italic = false },
                variables = {},
                sidebars = 'dark',
                floats = 'dark',
            },

            plugins = {
                all = require('user.check.value').is_nil(package.loaded.lazy),
                auto = true,
            },
        })

        vim.cmd(M.mod_cmd)
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
