local User = require('user_api')
local Check = User.check
local CfgUtil = require('config.util')
local types = User.types.lazy

local source = CfgUtil.source
local set_tgc = CfgUtil.set_tgc
local flag_installed = CfgUtil.flag_installed
local is_root = Check.is_root
local executable = Check.exists.executable
local vim_exists = Check.exists.vim_exists
local in_console = Check.in_console

---@type (LazySpec)[]
local M = {
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        version = false,
        config = source('plugin.persistence'),
        enabled = false,
    },
    {
        'olimorris/persisted.nvim',
        event = 'BufReadPre',
        version = false,
        config = source('plugin.persisted'),
    },
    {
        'numToStr/Comment.nvim',
        event = 'VeryLazy',
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        config = source('plugin.Comment'),
    },

    {
        'tpope/vim-endwise',
        lazy = false,
        version = false,
    },
    --- TODO COMMENTS
    {
        'folke/todo-comments.nvim',
        event = 'BufReadPre',
        version = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-lua/plenary.nvim',
        },
        init = set_tgc(),
        config = source('plugin.todo_comments'),
        cond = executable('rg') and not in_console(),
    },
    {
        'windwp/nvim-autopairs',
        main = 'nvim-autopairs',
        version = false,
        config = source('plugin.autopairs'),
    },
    {
        'vim-scripts/a.vim',
        ft = { 'c', 'cpp' },
        version = false,
        init = flag_installed('a_vim'),
        config = function()
            local wk_avail = require('user_api.maps.wk').available
            local desc = require('user_api.maps.kmap').desc
            local map_dict = require('user_api.maps').map_dict
            local curr_buf = vim.api.nvim_get_current_buf

            ---@type KeyMapDict
            local Keys = {
                ['<leader><C-h>s'] = {
                    ':A<CR>',
                    desc('Cycle Header/Source', true, curr_buf()),
                },
                ['<leader><C-h>x'] = {
                    ':AS<CR>',
                    desc('Horizontal Cycle Header/Source', true, curr_buf()),
                },
                ['<leader><C-h>v'] = {
                    ':AV<CR>',
                    desc('Vertical Cycle Header/Source', true, curr_buf()),
                },
                ['<leader><C-h>t'] = {
                    ':AT<CR>',
                    desc('Tab Cycle Header/Source', true, curr_buf()),
                },
                ['<leader><C-h>S'] = {
                    ':IH<CR>',
                    desc('Cycle Header/Source (Cursor)', true, curr_buf()),
                },
                ['<leader><C-h>X'] = {
                    ':IHS<CR>',
                    desc('Horizontal Cycle Header/Source (Cursor)', true, curr_buf()),
                },
                ['<leader><C-h>V'] = {
                    ':IHV<CR>',
                    desc('Vertical Cycle Header/Source (Cursor)', true, curr_buf()),
                },
                ['<leader><C-h>T'] = {
                    ':IHT<CR>',
                    desc('Tab Cycle Header/Source (Cursor)', true, curr_buf()),
                },
            }
            ---@type RegKeysNamed
            local Names = {
                ['<leader><C-h>'] = { group = '+Header/Source Switch (C/C++)' },
            }
            if wk_avail() then
                map_dict(Names, 'wk.register', false, 'n', curr_buf())
            end
            map_dict(Keys, 'wk.register', false, 'n', curr_buf())

            vim.schedule(function()
                -- Kill plugin-defined mappings

                local opts = desc('', true, curr_buf())
                opts.hidden = true

                local i_del = {
                    i = {
                        ['<leader>ih'] = { '<Nop>', opts, hidden = true },
                        ['<leader>is'] = { '<Nop>', opts, hidden = true },
                        ['<leader>ihn'] = { '<Nop>', opts, hidden = true },
                    },
                    n = {
                        ['<leader>ih'] = { '<Nop>', opts, hidden = true },
                        ['<leader>is'] = { '<Nop>', opts, hidden = true },
                        ['<leader>ihn'] = { '<Nop>', opts, hidden = true },
                    },
                }

                for _, lhs in next, i_del do
                    map_dict(i_del, 'wk.register', true, nil, curr_buf())
                end
            end)
        end,
    },
    {
        'folke/zen-mode.nvim',
        version = false,
        config = source('plugin.zen_mode'),
        cond = not is_root(),
    },
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
