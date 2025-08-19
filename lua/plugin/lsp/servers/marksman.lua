local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('marksman') then
    User.deregister_plugin('plugin.lsp.servers.marksman')
    return nil
end

User.register_plugin('plugin.lsp.servers.marksman')

return {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown', 'markdown.mdx' },
    root_markers = { '.git', '.marksman.toml' },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
