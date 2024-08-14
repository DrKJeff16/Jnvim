local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable

if not executable('doxygen') then
    return
end

User.register_plugin('plugin.doxygen')

vim.g.DoxygenToolkit_briefTag_pre = '@Synopsis  '
vim.g.DoxygenToolkit_paramTag_pre = '@Param '
vim.g.DoxygenToolkit_returnTag = '@Returns   '
vim.g.DoxygenToolkit_blockHeader =
    '--------------------------------------------------------------------------'
vim.g.DoxygenToolkit_blockFooter =
    '----------------------------------------------------------------------------'
vim.g.DoxygenToolkit_authorName = 'Mathias Lorente'
vim.g.DoxygenToolkit_licenseTag = 'My own license'
