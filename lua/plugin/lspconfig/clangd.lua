---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check

local exists = Check.exists.module
local executable = Check.exists.executable

if not exists('clangd_extensions') or not executable('clangd') then
    return
end

local Exts = require('clangd_extensions')
local Inlay = require('clangd_extensions.inlay_hints')

Exts.setup({
    inlay_hints = {
        inline = vim.fn.has('nvim-0.10') == 1,
        -- Options other than `highlight' and `priority' only work
        -- if `inline' is disabled
        -- Only show inlay hints for the current line
        only_current_line = true,
        -- Event which triggers a refresh of the inlay hints.
        -- You can make this { "CursorMoved" } or { "CursorMoved,CursorMovedI" } but
        -- not that this may cause  higher CPU usage.
        -- This option is only respected when only_current_line and
        -- autoSetHints both are true
        only_current_line_autocmd = { 'CursorHold' },
        -- whether to show parameter hints with the inlay hints or not
        show_parameter_hints = false,
        -- prefix for parameter hints
        parameter_hints_prefix = '<- ',
        -- prefix for all the other hints (type, chaining)
        other_hints_prefix = '=> ',
        -- whether to align to the length of the longest line in the file
        max_len_align = true,
        -- padding from the left if max_len_align is true
        max_len_align_padding = 1,
        -- whether to align to the extreme right or not
        right_align = true,
        -- padding from the right if right_align is true
        right_align_padding = 4,
        -- The color of the hints
        highlight = 'Comment',
        -- The highlight group priority for extmark
        priority = 100,
    },
    ast = {
        -- These require codicons (https://github.com/microsoft/vscode-codicons)
        role_icons = {
            type = '',
            declaration = '',
            expression = '',
            specifier = '',
            statement = '',
            ['template argument'] = '',
        },

        kind_icons = {
            Compound = '',
            Recovery = '',
            TranslationUnit = '',
            PackExpansion = '',
            TemplateTypeParm = '',
            TemplateTemplateParm = '',
            TemplateParamObject = '',
        },

        highlights = { detail = 'Comment' },
    },
    memory_usage = { border = 'single' },
    symbol_info = { border = 'double' },
})

Inlay.setup_autocmd()
Inlay.set_inlay_hints()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
