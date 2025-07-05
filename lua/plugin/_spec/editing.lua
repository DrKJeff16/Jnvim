---@module 'user_api.types.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local source = CfgUtil.source
local set_tgc = CfgUtil.set_tgc
local flag_installed = CfgUtil.flag_installed
local is_root = Check.is_root
local executable = Check.exists.executable
local in_console = Check.in_console

---@type LazySpecs
local Editing = {
    {
        'folke/persistence.nvim',
        lazy = false,
        version = false,
        config = source('plugin.persistence'),
        enabled = false,
    },
    {
        'olimorris/persisted.nvim',
        lazy = false,
        version = false,
        config = source('plugin.persisted'),
    },
    {
        'folke/twilight.nvim',
        lazy = true,
        version = false,
        config = source('plugin.twilight'),
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
        event = 'VeryLazy',
        version = false,
    },
    --- TODO COMMENTS
    {
        'folke/todo-comments.nvim',
        event = 'VeryLazy',
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
        event = 'VeryLazy',
        version = false,
        config = source('plugin.autopairs'),
    },
    {
        'vim-scripts/a.vim',
        ft = { 'c', 'cpp' },
        version = false,
        init = flag_installed('a_vim'),
        config = function()
            local desc = require('user_api.maps.kmap').desc
            local map_dict = require('user_api.maps').map_dict
            local curr_buf = vim.api.nvim_get_current_buf

            local buf = curr_buf()

            ---@type AllMaps
            local Keys = {
                ['<leader><C-h>'] = {
                    group = '+Header/Source Switch (C/C++)',
                    buffer = buf,
                },

                ['<leader><C-h>s'] = {
                    ':A<CR>',
                    desc('Cycle Header/Source', true, buf),
                    buffer = buf,
                },
                ['<leader><C-h>x'] = {
                    ':AS<CR>',
                    desc('Horizontal Cycle Header/Source', true, buf),
                    buffer = buf,
                },
                ['<leader><C-h>v'] = {
                    ':AV<CR>',
                    desc('Vertical Cycle Header/Source', true, buf),
                    buffer = buf,
                },
                ['<leader><C-h>t'] = {
                    ':AT<CR>',
                    desc('Tab Cycle Header/Source', true, buf),
                    buffer = buf,
                },
                ['<leader><C-h>S'] = {
                    ':IH<CR>',
                    desc('Cycle Header/Source (Cursor)', true, buf),
                    buffer = buf,
                },
                ['<leader><C-h>X'] = {
                    ':IHS<CR>',
                    desc('Horizontal Cycle Header/Source (Cursor)', true, buf),
                    buffer = buf,
                },
                ['<leader><C-h>V'] = {
                    ':IHV<CR>',
                    desc('Vertical Cycle Header/Source (Cursor)', true, buf),
                    buffer = buf,
                },
                ['<leader><C-h>T'] = {
                    ':IHT<CR>',
                    desc('Tab Cycle Header/Source (Cursor)', true, buf),
                    buffer = buf,
                },
            }

            local Keymaps = require('config.keymaps')
            Keymaps:setup({ n = Keys })

            -- Kill plugin-defined mappings
            vim.schedule(function()
                local opts = desc('', true, buf)
                opts.hidden = true

                ---@type AllModeMaps
                local i_del = {
                    i = {
                        ['<leader>ih'] = {
                            '<Nop>',
                            opts,
                            hidden = true,
                            buffer = buf,
                        },
                        ['<leader>is'] = {
                            '<Nop>',
                            opts,
                            hidden = true,
                            buffer = buf,
                        },
                        ['<leader>ihn'] = {
                            '<Nop>',
                            opts,
                            hidden = true,
                            buffer = buf,
                        },
                    },
                    n = {
                        ['<leader>ih'] = {
                            '<Nop>',
                            opts,
                            hidden = true,
                            buffer = buf,
                        },
                        ['<leader>is'] = {
                            '<Nop>',
                            opts,
                            hidden = true,
                            buffer = buf,
                        },
                        ['<leader>ihn'] = {
                            '<Nop>',
                            opts,
                            hidden = true,
                            buffer = buf,
                        },
                    },
                }

                map_dict(i_del, 'wk.register', true, nil, buf)
            end)
        end,
    },
    {
        'folke/zen-mode.nvim',
        event = 'VeryLazy',
        version = false,
        config = source('plugin.zen_mode'),
        cond = not is_root(),
    },
}

return Editing

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
