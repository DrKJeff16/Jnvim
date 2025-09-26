return {
    cmd = { 'css-variables-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_markers = { 'package.json', '.git' },

    settings = {
        cssVariables = {
            blacklistFolders = {
                '**/.cache',
                '**/.DS_Store',
                '**/.git',
                '**/.hg',
                '**/.next',
                '**/.svn',
                '**/bower_components',
                '**/CVS',
                '**/dist',
                '**/node_modules',
                '**/tests',
                '**/tmp',
            },
            lookupFiles = { '**/*.less', '**/*.scss', '**/*.sass', '**/*.css' },
        },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
