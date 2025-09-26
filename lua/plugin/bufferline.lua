---@module 'lazy'

--@param count integer
--@param lvl 'error'|'warning'
---@param diags? table<string, string>
---@param context? table
---@return string
local function diagnostics_indicator(_, _, diags, context)
    if context == nil or not context.buffer:current() then
        return ''
    end

    ---@type string
    local s = ' '

    for e, n in next, diags do
        local sym = (e == 'error') and ' ' or (e == 'warning' and ' ' or '')
        s = ('%s%s%s'):format(s, n, sym)
    end

    return s
end

---@class Bufferline.Buf
---@field name string The basename of the active file
---@field path string The full path of the active file
---@field bufnr integer The number of the active buffer
---@field buffers integer[] The numbers of the buffers in the tab
---@field tabnr integer The "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`

---@type LazySpec
return {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    version = false,
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'tiagovla/scope.nvim',
    },
    cond = not in_console(),
    config = function()
        _G.__cached_neo_tree_selector = nil
        _G.__get_selector = function()
            return _G.__cached_neo_tree_selector
        end

        local exists = require('user_api.check.exists').module
        local BLine = require('bufferline')
        local Groups = require('bufferline.groups')
        local SP = BLine.style_preset

        BLine.setup({
            highlights = {
                fill = {
                    fg = { attribute = 'fg', highlight = 'Normal' },
                    bg = { attribute = 'bg', highlight = 'StatusLineNC' },
                    bold = true,
                    italic = false,
                    underline = false,
                    undercurl = false,
                },
                background = {
                    fg = { attribute = 'fg', highlight = 'Normal' },
                    bg = { attribute = 'bg', highlight = 'StatusLine' },
                },
                buffer_visible = {
                    fg = { attribute = 'fg', highlight = 'Normal' },
                    bg = { attribute = 'bg', highlight = 'Normal' },
                },
                buffer_selected = {
                    fg = { attribute = 'fg', highlight = 'Normal' },
                    bg = { attribute = 'bg', highlight = 'Normal' },
                },
                separator = {
                    fg = { attribute = 'bg', highlight = 'Normal' },
                    bg = { attribute = 'bg', highlight = 'StatusLine' },
                },
                separator_selected = {
                    fg = { attribute = 'fg', highlight = 'Special' },
                    bg = { attribute = 'bg', highlight = 'Normal' },
                },
                separator_visible = {
                    fg = { attribute = 'fg', highlight = 'Normal' },
                    bg = { attribute = 'bg', highlight = 'StatusLineNC' },
                },
                close_button = {
                    fg = { attribute = 'fg', highlight = 'Normal' },
                    bg = { attribute = 'bg', highlight = 'StatusLine' },
                },
                close_button_selected = {
                    fg = { attribute = 'fg', highlight = 'Normal' },
                    bg = { attribute = 'bg', highlight = 'Normal' },
                },
                close_button_visible = {
                    fg = { attribute = 'fg', highlight = 'Normal' },
                    bg = { attribute = 'bg', highlight = 'Normal' },
                },
            },
            options = {
                -- style_preset = {
                --     SP.minimal,
                --     SP.no_bold,
                --     SP.no_italic,
                -- },

                themable = true,
                mode = 'tabs',
                style_preset = {
                    SP.no_italic,
                    SP.default,
                },

                numbers = 'ordinal',
                close_command = 'bdelete! %d',
                right_mouse_command = nil,
                left_mouse_command = nil,

                indicator = {
                    icon = '▎',
                    style = 'none',
                },

                buffer_close_icon = '󰅖',
                modified_icon = '●',
                close_icon = '',
                left_trunc_marker = '',
                right_trunc_marker = '',

                max_name_length = 28,
                max_prefix_length = 16,
                truncate_names = true,
                tab_size = 16,

                diagnostics = 'nvim_lsp',
                diagnostics_update_in_insert = false,
                diagnostics_update_on_event = false,
                diagnostics_indicator = diagnostics_indicator,
                color_icons = true,
                show_buffer_icons = true,
                show_buffer_close_icons = false,
                show_tab_indicators = true,
                show_duplicate_prefix = true,
                duplicates_across_groups = true,
                persist_buffer_sort = true,
                move_wraps_at_ends = true,

                get_element_icon = exists('nvim-web-devicons')
                        and function(element)
                            local DEVIC = require('nvim-web-devicons')
                            -- element consists of {filetype: string, path: string, extension: string, directory: string}
                            -- This can be used to change how bufferline fetches the icon
                            -- e.g.
                            -- for an element e.g. a buffer or a tab
                            local icon, hl = DEVIC.get_icon_by_filetype(element.filetype, {
                                default = false,
                            })
                            return icon, hl
                        end
                    or nil,

                separator_style = 'padded_slope',
                enforce_regular_tabs = true,
                always_show_bufferline = true,
                auto_toggle_bufferline = false,

                groups = {
                    options = { toggle_hidden_on_enter = true },
                    items = { Groups.builtin.pinned:with({ icon = '' }) },
                },

                hover = {
                    enabled = false,
                    delay = 150,
                    reveal = { 'close' },
                },

                sort_by = 'tabs',
                pick = {
                    alphabet = 'abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890',
                },

                offsets = {
                    {
                        filetype = 'NvimTree',
                        text = 'Nvim Tree',
                        text_align = 'center',
                        separator = true,
                    },
                    {
                        filetype = 'lazy',
                        text = 'Lazy',
                        text_align = 'center',
                        separator = true,
                    },
                    {
                        filetype = 'notify',
                        text = 'Notification',
                        text_align = 'center',
                        separator = true,
                    },
                    {
                        filetype = 'neo-tree',
                        raw = ' %{%v:lua.__get_selector()%} ',
                        highlight = { sep = { link = 'WinSeparator' } },
                        separator = '┃',
                    },
                },
            },
        })
    end,
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
