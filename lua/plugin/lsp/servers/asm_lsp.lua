local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('asm-lsp') then
    User.deregister_plugin('plugin.lsp.servers.asm_lsp')
    return nil
end

User.register_plugin('plugin.lsp.servers.asm_lsp')

return {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'vmasm' },
    root_markers = { '.asm-lsp.toml', '.git' },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
