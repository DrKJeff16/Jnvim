local User = require('user_api')

User.register_plugin('plugin.lsp.servers.clangd')

return {
    cmd = { 'clangd' },
    filetypes = {
        'c',
        'cpp',
        'objc',
        'objcpp',
        'cuda',
    },

    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac', -- AutoTools
        '.git',
    },

    settings = {
        clangd = {
            checkUpdates = false,
            detectExtensionConflicts = true,
            enableCodeCompletion = true,
            onConfigChanged = 'restart',
            path = '/usr/bin/clangd',
            restartAfterCrash = true,
            serverCompletionRanking = false,
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
