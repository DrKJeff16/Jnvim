local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('vscode-json-language-server') then
    User.deregister_plugin('plugin.lsp.servers.jsonls')
    return nil
end

User.register_plugin('plugin.lsp.servers.jsonls')

return {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    init_options = { provideFormatter = true },
    root_markers = { '.git' },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
