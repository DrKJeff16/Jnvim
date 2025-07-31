local User = require('user_api')

User.register_plugin('plugin.lsp.servers.dockerls')

return {
    cmd = { 'docker-langserver', '--stdio' },
    filetypes = { 'dockerfile' },
    root_markers = { 'Dockerfile' },
    settings = {
        docker = {
            languageserver = {
                formatter = {
                    ignoreMultilineInstructions = true,
                },
            },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
