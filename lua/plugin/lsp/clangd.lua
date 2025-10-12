---@module 'lazy'

---@type LazySpec
return {
    'p00f/clangd_extensions.nvim',
    lazy = true,
    ft = { 'c', 'cpp' },
    dev = true,
    version = false,
    cond = require('user_api.check.exists').executable('clangd'),
    opts = {
        inlay_hints = { inline = false },
        ast = {
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
        symbol_info = { border = 'single' },
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
