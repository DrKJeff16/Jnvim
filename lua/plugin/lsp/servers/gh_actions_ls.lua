local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('gh-actions-language-server') then
    User.deregister_plugin('plugin.lsp.servers.gh_actions_ls')
    return nil
end

User.register_plugin('plugin.lsp.servers.gh_actions_ls')

return {
    cmd = { 'gh-actions-language-server', '--stdio' },
    filetypes = { 'yaml' },
    init_options = {},
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
