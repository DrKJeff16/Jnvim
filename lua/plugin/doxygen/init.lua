local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable

if not executable('doxygen') or vim.g.installed_doxygen_toolkit ~= 1 then
    return
end

User.register_plugin('plugin.doxygen')

local g_vars = {
    DoxygenToolkit_briefTag_pre = '@brief  ',
    DoxygenToolkit_paramTag_pre = '@param ',
    DoxygenToolkit_returnTag = '@return ',
    DoxygenToolkit_blockHeader = '--------------------------------------------------------------------------',
    DoxygenToolkit_blockFooter = '----------------------------------------------------------------------------',
    DoxygenToolkit_authorName = 'Guennadi "DrKJeff16" Maximov C',
    DoxygenToolkit_licenseTag = 'MIT',
}

for k, v in next, g_vars do
    vim.g[k] = v
end
