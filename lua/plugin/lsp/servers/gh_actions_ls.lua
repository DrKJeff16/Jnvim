local User = require('user_api')

User.register_plugin('plugin.lsp.servers.gh_actions_ls')

return {
    cmd = { 'gh-actions-language-server', '--stdio' },
    filetypes = { 'yaml' },
    init_options = {},
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
