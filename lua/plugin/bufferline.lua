---@module 'lazy'

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
        require('bufferline').setup({
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
                color_icons = true,
                show_buffer_icons = true,
                show_buffer_close_icons = false,
                show_tab_indicators = true,
                show_duplicate_prefix = true,
                duplicates_across_groups = true,
                persist_buffer_sort = true,
                move_wraps_at_ends = true,
                themable = true,
                mode = 'tabs',
                sort_by = 'tabs',
                numbers = 'ordinal',
                close_command = 'bdelete! %d',
                right_mouse_command = nil,
                left_mouse_command = nil,
                buffer_close_icon = '󰅖',
                modified_icon = '●',
                close_icon = '',
                left_trunc_marker = '',
                right_trunc_marker = '',
                max_name_length = 28,
                max_prefix_length = 16,
                truncate_names = true,
                tab_size = 16,
                separator_style = 'padded_slope',
                enforce_regular_tabs = true,
                always_show_bufferline = true,
                auto_toggle_bufferline = false,
                diagnostics = 'nvim_lsp',
                diagnostics_update_in_insert = false,
                diagnostics_update_on_event = false,
                style_preset = {
                    require('bufferline').style_preset.no_italic,
                    require('bufferline').style_preset.default,
                },
                indicator = { icon = '▎', style = 'none' },
                ---@param diags table<string, string>
                ---@param context? table
                ---@return string
                diagnostics_indicator = function(_, _, diags, context)
                    local s = ''
                    if not (context and context.buffer:current()) then
                        return s
                    end
                    s = ' '
                    for e, n in pairs(diags) do
                        local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or '')
                        s = ('%s%s%s'):format(s, n, sym)
                    end
                    return s
                end,
                ---@param element { filetype: string, path: string, extension: string, directory: string }
                ---@return string
                ---@return string
                get_element_icon = function(element)
                    return require('nvim-web-devicons').get_icon_by_filetype(element.filetype, {
                        default = false,
                    })
                end,
                groups = {
                    options = { toggle_hidden_on_enter = true },
                    items = { require('bufferline.groups').builtin.pinned:with({ icon = '' }) },
                },
                hover = { enabled = false },
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
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
