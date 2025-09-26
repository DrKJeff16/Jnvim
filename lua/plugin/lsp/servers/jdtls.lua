local environ = vim.fn.environ()
local HOME = vim.fn.has_key(environ, 'HOME') and environ['HOME'] or environ['USERPROFILE']

return {
    cmd = {
        'jdtls',
        '-configuration',
        HOME .. '/.cache/jdtls/config',
        '-data',
        HOME .. '/.cache/jdtls/workspace',
    },
    filetypes = { 'java' },
    init_options = {
        jvm_args = {},
        workspace = HOME .. '/.cache/jdtls/workspace',
    },
    root_markers = {
        '.git',
        'build.gradle',
        'build.gradle.kts',
        'build.xml',
        'pom.xml',
        'settings.gradle',
        'settings.gradle.kts',
    },
    settings = {},
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
