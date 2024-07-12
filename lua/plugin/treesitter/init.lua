---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local is_nil = Check.value.is_nil

if not exists('nvim-treesitter') then
    return
end

local fs_stat = vim.uv.fs_stat
local buf_name = vim.api.nvim_buf_get_name

local Cfg = require('nvim-treesitter.configs')

require('nvim-treesitter.install').prefer_git = true

local ensure = {
    'bash',
    'c',
    'cmake',
    'comment',
    'commonlisp',
    'cpp',
    'css',
    'csv',
    'diff',
    'doxygen',
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
    'kconfig',
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
    'rst',
    'scss',
    'ssh_config',
    'tmux',
    'toml',
    'udev',
    'vim',
    'vimdoc',
    'xml',
    'yaml',
}

---@type TSConfig
---@diagnostic disable-next-line
local Opts = {
    auto_install = true,
    sync_install = false,
    ignore_install = {},
    ensure_installed = ensure,

    highlight = {
        enable = true,

        ---@type fun(lang: string, buf: integer): boolean
        disable = function(lang, buf)
            local max_fs = 1024 * 1024
            local ok, stats = pcall(fs_stat, buf_name(buf))

            local disable_ft = {
                'text',
            }

            local res = false

            res = vim.tbl_contains(disable_ft, vim.api.nvim_get_option_value('ft', { scope = 'local' }))

            return res or ok and not is_nil(stats) and stats.size > max_fs
        end,
        additional_vim_regex_highlighting = false,
    },

    indent = { enable = false },
    incremental_selection = { enable = false },
}

if exists('nvim-treesitter-refactor') then
    Opts.refactor = {
        refactor = {
            highlight_definitions = {
                enable = true,
                clear_on_cursor_move = true,
            },
            highlight_current_scope = { enable = true },
        },
    }
end

Cfg.setup(Opts)

require('plugin.treesitter.context')

if exists('ts_context_commentstring') then
    require('ts_context_commentstring').setup({
        enable_autocmd = not exists('Comment'),
    })
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
