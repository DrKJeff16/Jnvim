local ensure_langs = {
    'bash',
    'c',
    'comment',
    'cpp',
    'css',
    'desktop',
    'diff',
    'doxygen',
    'editorconfig',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'gpg',
    'html',
    'hyprlang',
    'ini',
    'json',
    'json5',
    'jsonc',
    'kitty',
    'latex',
    'lua',
    'luadoc',
    'luap',
    'markdown',
    'markdown_inline',
    'meson',
    'ninja',
    'passwd',
    'python',
    'query',
    'readline',
    'regex',
    'requirements',
    'robots',
    'rust',
    'scss',
    'ssh_config',
    'tmux',
    'toml',
    'udev',
    'vim',
    'vimdoc',
    'yaml',
    'zathurarc',
}

require('nvim-treesitter').setup({ install_dir = vim.fn.stdpath('data') .. '/site' })
require('nvim-treesitter').install(ensure_langs):wait(300000)
vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        'bash',
        'c',
        'cpp',
        'css',
        'desktop',
        'diff',
        'dockerfile',
        'dosini',
        'doxygen',
        'editorconfig',
        'gitattributes',
        'gitcommit',
        'gitconfig',
        'gitignore',
        'gitrebase',
        'gpg',
        'html',
        'hyprlang',
        'java',
        'json',
        'json5',
        'jsonc',
        'kitty',
        'tex',
        'lua',
        'markdown',
        'meson',
        'ninja',
        'passwd',
        'python',
        'query',
        'readline',
        'regex',
        'requirements',
        'robots',
        'rust',
        'scss',
        'sh',
        'sshconfig',
        'tmux',
        'toml',
        'udevconf',
        'udevrules',
        'vim',
        'yaml',
        'zathurarc',
        'zsh',
    },
    callback = function(ev)
        if vim.api.nvim_buf_is_loaded(ev.buf) then
            local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
            if not (lang and vim.treesitter.language.add(lang)) then
                return
            end

            vim.treesitter.start()

            -- -- Set folding if available
            -- if vim.treesitter.query.get(lang, 'folds') then
            --     vim.wo[vim.api.nvim_get_current_win()].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            -- end

            -- Set indentation if available (overrides traditional indent)
            if vim.treesitter.query.get(lang, 'indents') then
                vim.bo[ev.buf].indentexpr = 'nvim_treesitter#indent()'
            end
        end
    end,
})
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
