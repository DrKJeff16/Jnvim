local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('rust-analyzer') then
    User.deregister_plugin('plugin.lsp.servers.rust_analyzer')
    return nil
end

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
