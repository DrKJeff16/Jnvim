local Keymaps = require('user_api.config.keymaps')
local desc = require('user_api.maps').desc

local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
return {
    'vim-scripts/a.vim',
    ft = { 'c', 'cpp' },
    version = false,
    init = require('config.util').flag_installed('a_vim'),
    config = function()
        local group = augroup('User.A_Vim', { clear = true })

        au('BufEnter', {
            group = group,
            pattern = {
                '*.c',
                '*.cc',
                '*.cpp',
                '*.cxx',
                '*.c++',
                '*.C',
                '*.h',
                '*.hh',
                '*.hpp',
                '*.hxx',
                '*.h++',
                '*.H',
            },

            callback = function(ev)
                ---@type AllModeMaps
                local Keys = {
                    i = {
                        ['<C-Tab>'] = { '<Esc>:IH<CR>', buffer = ev.buf },
                    },

                    n = {
                        ['<leader><C-h>'] = {
                            group = '+Header/Source Switch (C/C++)',
                            buffer = ev.buf,
                        },

                        ['<leader><C-h>s'] = {
                            ':A<CR>',
                            desc('Cycle Header/Source', true, ev.buf),
                        },
                        ['<leader><C-h>x'] = {
                            ':AS<CR>',
                            desc('Horizontal Cycle Header/Source', true, ev.buf),
                        },
                        ['<leader><C-h>v'] = {
                            ':AV<CR>',
                            desc('Vertical Cycle Header/Source', true, ev.buf),
                        },
                        ['<leader><C-h>t'] = {
                            ':AT<CR>',
                            desc('Tab Cycle Header/Source', true, ev.buf),
                        },
                        ['<leader><C-h>S'] = {
                            ':IH<CR>',
                            desc('Cycle Header/Source (Cursor)', true, ev.buf),
                        },
                        ['<leader><C-h>X'] = {
                            ':IHS<CR>',
                            desc('Horizontal Cycle Header/Source (Cursor)', true, ev.buf),
                        },
                        ['<leader><C-h>V'] = {
                            ':IHV<CR>',
                            desc('Vertical Cycle Header/Source (Cursor)', true, ev.buf),
                        },
                        ['<leader><C-h>T'] = {
                            ':IHT<CR>',
                            desc('Tab Cycle Header/Source (Cursor)', true, ev.buf),
                        },
                    },
                }

                Keymaps(Keys, ev.buf)
            end,
        })

        ---HACK: Delete default plugin maps
        vim.keymap.del({ 'n', 'i' }, '<leader>ihn')
        vim.keymap.del({ 'n', 'i' }, '<leader>ih')
        vim.keymap.del({ 'n', 'i' }, '<leader>is')
    end,
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
