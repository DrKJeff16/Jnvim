local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module

if not exists('nvim-treesitter') then
    return
end

local fs_stat = (vim.uv or vim.loop).fs_stat
local buf_name = vim.api.nvim_buf_get_name
local in_tbl = vim.tbl_contains
local curr_buf = vim.api.nvim_get_current_buf

local Cfg = require('nvim-treesitter.configs')

require('nvim-treesitter.install').prefer_git = true

local ensure = {
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

---@type TSConfig
---@diagnostic disable-next-line
local Opts = {
    auto_install = true,
    sync_install = false,
    ignore_install = {},
    ensure_installed = ensure,

    highlight = {
        enable = true,

        ---@param lang? string
        ---@param buf? integer
        ---@return boolean
        disable = function(lang, buf)
            local max_fs = 1024 * 1024
            local ok, stats = pcall(fs_stat, buf_name(buf))
            local ft_get = Util.ft_get

            local disable_ft = {
                'text',
            }

            local res = in_tbl(disable_ft, ft_get(buf or curr_buf()))

            return res or ok and not stats == nil and stats.size > max_fs ---@diagnostic disable-line
        end,
        additional_vim_regex_highlighting = false,
    },

    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn', -- set to `false` to disable one of the mappings
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
        },
    },

    textobjects = { enable = true },

    refactor = {
        refactor = {
            highlight_definitions = {
                enable = true,
                clear_on_cursor_move = true,
            },
            highlight_current_scope = { enable = true },
        },
    },
}

Cfg.setup(Opts)

vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')

require('plugin.treesitter.context')

if exists('ts_context_commentstring') then
    require('ts_context_commentstring').setup()
end

User:register_plugin('plugin.treesitter')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
