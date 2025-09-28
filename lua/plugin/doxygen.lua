---@module 'lazy'

---@type LazySpec
return {
    'vim-scripts/DoxygenToolkit.vim',
    ft = { 'c', 'cpp' },
    version = false,
    init = require('config.util').flag_installed('doxygen_toolkit'),
    cond = require('user_api.check.exists').executable('doxygen'),
    config = function()
        local g_vars = {
            authorName = 'Guennadi "DrKJeff16" Maximov C.',
            blockFooter = '----------------------------------------------------------------------------',
            blockHeader = '--------------------------------------------------------------------------',
            briefTag_pre = '@brief  ',
            licenseTag = 'MIT',
            paramTag_pre = '@param ',
            returnTag = '@return ',
        }

        for k, v in next, g_vars do
            vim.g['DoxygenToolkit_' .. k] = v
        end
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
