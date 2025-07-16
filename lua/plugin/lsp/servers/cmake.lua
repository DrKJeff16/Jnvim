local User = require('user_api')

User:register_plugin('plugin.lsp.servers.cmake')

return {
    cmd = { 'cmake-language-server' },
    filetypes = { 'cmake' },
    init_options = { buildDirectory = 'build' },
    root_markers = { 'CMakePresets.json', 'CTestConfig.cmake', '.git', 'build', 'cmake' },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
