local User = require('user_api')

User.register_plugin('plugin.lsp.servers.<YOUR_CONFIG>')

return {
    cmd = { '<LSP_COMMAND>', '<OPTIONAL_ARGS>' },
    filetypes = {},
    init_options = {},
    root_markers = { '.git' },
    settings = {},
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
