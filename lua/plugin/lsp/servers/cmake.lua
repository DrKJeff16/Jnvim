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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
