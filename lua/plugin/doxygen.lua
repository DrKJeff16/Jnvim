local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable

if not executable('doxygen') or vim.g.installed_doxygen_toolkit ~= 1 then
    User.deregister_plugin('plugin.doxygen')
    return
end

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

User.register_plugin('plugin.doxygen')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
