local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('css-variables-language-server') then
    User.deregister_plugin('plugin.lsp.servers.css_variables')
    return nil
end

User.register_plugin('plugin.lsp.servers.css_variables')

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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
