local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local executable = Check.exists.executable

if not (executable('clangd') and exists('clangd_extensions')) then
    return
end

local Clangd = require('clangd_extensions')

Clangd.setup({
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
    memory_usage = { border = 'double' },
    symbol_info = { border = 'rounded' },
})

User:register_plugin('plugin.lsp.clangd')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
