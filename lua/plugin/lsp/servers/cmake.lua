local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('cmake-language-server') then
    User.deregister_plugin('plugin.lsp.servers.cmake')
    return nil
end

User.register_plugin('plugin.lsp.servers.cmake')

return {
    cmd = { 'cmake-language-server' },
    filetypes = { 'cmake' },
    init_options = { buildDirectory = 'build' },
    root_markers = {
        '.git',
        'CMakePresets.json',
        'CTestConfig.cmake',
        'build',
        'cmake',
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
