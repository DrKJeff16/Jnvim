---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check

local Keymaps = User.config.keymaps
local exists = Check.exists.module
local desc = User.maps.desc

local fs_stat = (vim.uv or vim.loop).fs_stat
local buf_name = vim.api.nvim_buf_get_name

if not exists('nvim-treesitter') then
    User.deregister_plugin('plugin.ts')
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
    require('nvim-treesitter.install').prefer_git = true

    require('nvim-treesitter.configs').setup({
        auto_install = true,
        sync_install = false,
        ignore_install = { 'javascript' },
        ensure_installed = ensure_langs,

        highlight = {
            enable = true,

            ---@param bufnr? integer
            ---@return boolean
            disable = function(_, bufnr)
                local max_fs = 1024 * 1024
                local ok, stats = pcall(fs_stat, buf_name(bufnr))

                return ok and stats ~= nil and stats.size > max_fs
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

        textobjects = {
            lsp_interop = {
                enable = true,
                border = 'none',
                floating_preview_opts = {},
                peek_definition_code = {
                    ['<leader>df'] = '@function.outer',
                    ['<leader>dF'] = '@class.outer',
                },
            },

            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                keymaps = {
                    ['if'] = '@function.inner',
                    -- You can use the capture groups defined in textobjects.scm
                    af = '@function.outer',
                    ac = '@class.outer',
                    -- You can optionally set descriptions to the mappings (used in the desc parameter of
                    -- nvim_buf_set_keymap) which plugins like which-key display
                    ic = {
                        query = '@class.inner',
                        desc = 'Select inner part of a class region',
                    },
                    -- You can also use captures from other query groups like `locals.scm`
                    as = {
                        query = '@local.scope',
                        query_group = 'locals',
                        desc = 'Select language scope',
                    },
                },
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V', -- linewise
                    ['@class.outer'] = '<c-v>', -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * selection_mode: eg 'v'
                -- and should return true or false
                include_surrounding_whitespace = true,
            },

            swap = {
                enable = true,
                swap_next = { ['<leader>a'] = '@parameter.inner' },
                swap_previous = { ['<leader>A'] = '@parameter.inner' },
            },

            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = { query = '@class.outer', desc = 'Next class start' },

                    -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
                    -- [']o'] = '@loop.*',
                    [']o'] = { query = { '@loop.inner', '@loop.outer' } },

                    -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                    -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                    [']s'] = { query = '@local.scope', query_group = 'locals', desc = 'Next scope' },
                    [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
                },
                goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
                goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
                goto_previous_end = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' },
                -- Below will go to either the start or the end, whichever is closer.
                -- Use if you want more granular movements
                -- Make it even more gradual by adding multiple queries and regex.,
                goto_next = { [']d'] = '@conditional.outer' },
                goto_previous = { ['[d'] = '@conditional.outer' },
            },
        },

        refactor = {
            highlight_definitions = { enable = true, clear_on_cursor_move = true },
            highlight_current_scope = { enable = true },
            smart_rename = { enable = true, keymaps = { smart_rename = 'grr' } },
        },
    })
end

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
    require('ts_context_commentstring').setup({
        enable_autocmd = false,
    })
end

User.register_plugin('plugin.ts')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
