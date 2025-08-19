local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('taplo') then
    User.deregister_plugin('plugin.lsp.servers.taplo')
    return nil
end

User.register_plugin('plugin.lsp.servers.taplo')

return {
    cmd = { 'taplo', 'lsp', 'stdio' },
    filetypes = { 'toml' },
    root_markers = { '.taplo.toml', 'taplo.toml', '.git' },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
