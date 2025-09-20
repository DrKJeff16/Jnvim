local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('cssmodules-language-server') then
    User.deregister_plugin('plugin.lsp.servers.cssmodules_ls')
    return
end

User.register_plugin('plugin.lsp.servers.cssmodules_ls')

return {
    cmd = { 'cssmodules-language-server' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'package.json' },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
