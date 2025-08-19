---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('nvim-treesitter') then
    User.deregister_plugin('plugin.ts')
    return
end

local fs_stat = (vim.uv or vim.loop).fs_stat
local buf_name = vim.api.nvim_buf_get_name
local in_tbl = vim.tbl_contains

local TS = require('nvim-treesitter')

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

--- If using `main` branch, like I do
if TS.install then
    ---@diagnostic disable-next-line
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

    --- If using `legacy` version
else
    local Cfg = require('nvim-treesitter.configs')

    require('nvim-treesitter.install').prefer_git = true

    Cfg.setup({
        auto_install = true,
        sync_install = false,
        ignore_install = {},
        ensure_installed = ensure_langs,

        highlight = {
            enable = true,

            ---@param lang? string
            ---@param buf? integer
            ---@return boolean
            disable = function(lang, buf)
                local max_fs = 1024 * 1024
                local ok, stats = pcall(fs_stat, buf_name(buf))

                local disable_lang = {
                    'text',
                }

                local res = in_tbl(disable_lang, lang)

                return (res or ok and stats ~= nil and stats.size > max_fs)
            end,

            additional_vim_regex_highlighting = false,
        },

        indent = { enable = true },

        incremental_selection = {
            enable = false,
            keymaps = {
                init_selection = 'gnn', -- set to `false` to disable one of the mappings
                node_incremental = 'grn',
                scope_incremental = 'grc',
                node_decremental = 'grm',
            },
        },

        textobjects = { enable = true },

        refactor = {
            highlight_definitions = {
                enable = true,
                clear_on_cursor_move = true,
            },

            highlight_current_scope = { enable = true },
        },
    })
end

require('plugin.ts.autotag')
require('plugin.ts.context')

if exists('ts_context_commentstring') then
    require('ts_context_commentstring').setup({
        enable_autocmd = false,
    })
end

User.register_plugin('plugin.ts')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
