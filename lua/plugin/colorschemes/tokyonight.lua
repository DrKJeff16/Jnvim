---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check
local csc_m = User.types.colorschemes

local exists = Check.exists.module
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

---@type CscSubMod
local TokyoNight = {
    ---@type TN.Variants
    variants = {
        'night',
        'moon',
        'day',
    },
    mod_cmd = 'colorscheme tokyonight',
    setup = nil,
}

if exists('tokyonight') then
    User:register_plugin('plugin.colorschemes.tokyonight')

    ---@param self CscSubMod
    ---@param variant? 'night'|'moon'|'day'
    ---@param transparent? boolean
    ---@param override? tokyonight.Config|table
    function TokyoNight:setup(variant, transparent, override)
        variant = (is_str(variant) and vim.tbl_contains(self.variants, variant)) and variant
            or 'moon'
        transparent = is_bool(transparent) and transparent or false
        override = is_tbl(override) and override or {}

        require('tokyonight').setup(vim.tbl_deep_extend('keep', override, {
            cache = false,

            ---@param colors ColorScheme|table
            on_colors = function(colors)
                colors.error = '#df4f4f'
                colors.info = colors.teal
            end,

            ---@param hl tokyonight.Highlights|table
            ---@param c ColorScheme|table
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
            transparent = transparent,
            sidebars = {
                'NvimTree',
                'TelescopePrompt',
                'diffview',
                'help',
                'lazy',
                'noice',
                'packer',
                'qf',
                'terminal',
                'toggleterm',
                'trouble',
                'vista_kind',
            },

            style = variant,
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
                all = not require('user_api.check.value').is_nil(package.loaded.lazy),
                auto = true,
            },
        }))

        vim.cmd(self.mod_cmd)
    end
end

function TokyoNight.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, { __index = TokyoNight })
end

return TokyoNight

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
