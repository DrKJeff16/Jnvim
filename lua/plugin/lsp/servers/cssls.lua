local User = require('user_api')

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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
