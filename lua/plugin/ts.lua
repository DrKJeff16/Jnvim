local User = require('user_api')
local Check = User.check

local Keymaps = User.config.keymaps
local desc = User.maps.desc
local exists = Check.exists.module
if not exists('nvim-treesitter') then
    return
end

local TS = require('nvim-treesitter')
local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
local ensure_langs = {
    'bash',
    'c',
    'comment',
    'cpp',
    'css',
    'diff',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'gpg',
    'html',
    'ini',
    'json',
    'json5',
    'jsonc',
    'lua',
    'luadoc',
    'luap',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'readline',
    'regex',
    'ssh_config',
    'toml',
    'udev',
    'vim',
    'vimdoc',
    'yaml',
}

TS.setup({
    ---Directory to install parsers and queries to
    install_dir = vim.fn.stdpath('data') .. '/site',
})

TS.install(ensure_langs):wait(300000)

vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(ev)
        vim.treesitter.start(ev.buf)
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

---@type AllMaps
local Keys = {
    [';'] = {
        ts_repeat_move.repeat_last_move,
        desc('Repeat Last Move (Next)'),
    },
    [','] = {
        ts_repeat_move.repeat_last_move_opposite,
        desc('Repeat Last Move (Previous)'),
    },
    ['f'] = {
        ts_repeat_move.builtin_f_expr,
        desc('Builtin `f` Expr', true, nil, true, false, true),
    },
    ['F'] = {
        ts_repeat_move.builtin_F_expr,
        desc('Builtin `F` Expr', true, nil, true, false, true),
    },
    ['t'] = {
        ts_repeat_move.builtin_t_expr,
        desc('Builtin `t` Expr', true, nil, true, false, true),
    },
    ['T'] = {
        ts_repeat_move.builtin_T_expr,
        desc('Builtin `T` Expr', true, nil, true, false, true),
    },
}

Keymaps({ n = Keys, o = Keys, x = Keys })

require('plugin.ts.autotag')
require('plugin.ts.context')

if exists('ts_context_commentstring') then
    require('ts_context_commentstring').setup({ enable_autocmd = false })
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
