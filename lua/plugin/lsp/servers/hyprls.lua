local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('hyprls') then
    User.deregister_plugin('plugin.lsp.servers.hyprls')
    return nil
end

vim.filetype.add({
    pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
})

User.register_plugin('plugin.lsp.servers.hyprls')

return {
    cmd = { 'hyprls', '--stdio' },
    filetypes = { 'hyprlang' },
    root_markers = { '.git' },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
