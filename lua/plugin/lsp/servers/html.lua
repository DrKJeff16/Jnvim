local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('vscode-html-language-server') then
    User.deregister_plugin('plugin.lsp.servers.html')
    return nil
end

User.register_plugin('plugin.lsp.servers.html')

return {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html', 'templ' },
    init_options = {
        configurationSection = { 'html', 'css', 'javascript' },
        embeddedLanguages = {
            css = true,
            javascript = true,
        },
        provideFormatter = true,
    },
    root_markers = { 'package.json', '.git' },
    settings = {},
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
