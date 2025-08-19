local User = require('user_api')
local executable = require('user_api.check.exists').executable

if not executable('vim-language-server') then
    User.deregister_plugin('plugin.lsp.servers.vimls')
    return nil
end

User.register_plugin('plugin.lsp.servers.vimls')

return {
    cmd = { 'vim-language-server', '--stdio' },
    filetypes = { 'vim' },
    init_options = {
        diagnostic = { enable = true },
        indexes = {
            count = 3,
            gap = 100,
            projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
            runtimepath = true,
        },
        isNeovim = true,
        iskeyword = '@,48-57,_,192-255,-#',
        runtimepath = '',
        suggest = {
            fromRuntimepath = true,
            fromVimruntime = true,
        },
        vimruntime = '',
    },
    root_markers = { '.git' },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
