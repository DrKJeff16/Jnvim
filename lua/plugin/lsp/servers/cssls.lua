local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('vscode-css-language-server') then
    User.deregister_plugin('plugin.lsp.servers.cssls')
    return nil
end

User.register_plugin('plugin.lsp.servers.cssls')

return {
    cmd = { 'vscode-css-language-server', '--stdio' },

    filetypes = { 'css', 'scss', 'less' },
    init_options = { provideFormatter = true },
    root_markers = { 'package.json', '.git' },

    settings = {
        css = { validate = true },
        less = { validate = true },
        scss = { validate = true },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
