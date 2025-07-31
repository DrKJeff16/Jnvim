local User = require('user_api')

User.register_plugin('plugin.lsp.servers.rust_analyzer')

return {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'package.json', '.git' },

    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = true,
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
