---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module

if not exists('bufferline') or exists('barbar') then
    return
end

local BLine = require('bufferline')

---@param count integer
---@param lvl 'error'|'warning'
---@param diags? table<string, any>
---@param context? table
---@return string
local diagnostics_indicator = function(count, lvl, diags, context)
    if not context.buffer:current() then
        return ''
    end

    local s = ' '

    for e, n in next, diags do
        local sym = (e == 'error') and ' ' or (e == 'warning' and ' ' or '')
        s = s .. n .. sym
    end

    return s
end

---@class Bufferline.Buf
---@field name string @the basename of the active file
---@field path string @the full path of the active file
---@field bufnr integer @the number of the active buffer
---@field buffers integer[] @the numbers of the buffers in the tab
---@field tabnr integer @the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`

---@param buf Bufferline.Buf
---@return string?
local name_formatter = function(buf) -- buf contains:
    -- name                | str        | the basename of the active file
    -- path                | str        | the full path of the active file
    -- bufnr (buffer only) | int        | the number of the active buffer
    -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
    -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`

    return nil
end

BLine.setup({
    highlights = {
        fill = {
            bold = true,
            italic = false,
            underline = false,
            undercurl = false,
        },
    },
    options = {
        mode = 'tabs',

        --[[ style_preset = {
            BLine.style_preset.no_italic,
            BLine.style_preset.minimal,
        }, ]]

        style_preset = BLine.style_preset.default,
        themable = true,

        numbers = 'both',

        close_command = 'bdelete! %d',
        right_mouse_command = nil,
        left_mouse_command = nil,

        indicator = {
            icon = '▎',
            style = 'underline',
        },

        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',

        max_name_length = 25,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 20,

        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_indicator = diagnostics_indicator,

        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_tab_indicators = true,

        show_duplicate_prefix = true,
        duplicates_across_groups = true,

        persist_buffer_sort = true,

        move_wraps_at_ends = false,
        get_element_icon = function(element)
            -- element consists of {filetype: string, path: string, extension: string, directory: string}
            -- This can be used to change how bufferline fetches the icon
            -- e.g.
            -- for an element e.g. a buffer or a tab
            local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
            return icon, hl
        end,

        separator_style = 'padded_slope',
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        auto_toggle_bufferline = true,

        groups = {
            options = { toggle_hidden_on_enter = true },
            items = { require('bufferline.groups').builtin.pinned:with({ icon = '' }) },
        },

        hover = {
            enabled = false,
            delay = 250,
            reveal = { 'close' },
        },

        sort_by = 'tabs',

        offsets = {
            {
                filetype = 'NvimTree',
                text = 'Nvim Tree',
                text_align = 'center',
                separator = true,
            },
        },
    },
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
