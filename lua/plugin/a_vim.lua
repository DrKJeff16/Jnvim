local User = require('user_api')

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
        if vim.g.installed_a_vim ~= 1 then
            User.deregister_plugin('plugin.a_vim')
            return
        end

        local group = augroup('User.A_Vim', { clear = true })

        au({ 'BufEnter', 'BufWinEnter', 'WinEnter' }, {
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
                local buf = ev.buf

                ---@type AllModeMaps
                local Keys = {
                    i = {
                        ['<C-Tab>'] = { '<Esc>:IH<CR>', buffer = buf },
                    },

                    n = {
                        ['<leader><C-h>'] = {
                            group = '+Header/Source Switch (C/C++)',
                            buffer = buf,
                        },

                        ['<leader><C-h>s'] = {
                            ':A<CR>',
                            desc('Cycle Header/Source', true, buf),
                        },
                        ['<leader><C-h>x'] = {
                            ':AS<CR>',
                            desc('Horizontal Cycle Header/Source', true, buf),
                        },
                        ['<leader><C-h>v'] = {
                            ':AV<CR>',
                            desc('Vertical Cycle Header/Source', true, buf),
                        },
                        ['<leader><C-h>t'] = {
                            ':AT<CR>',
                            desc('Tab Cycle Header/Source', true, buf),
                        },
                        ['<leader><C-h>S'] = {
                            ':IH<CR>',
                            desc('Cycle Header/Source (Cursor)', true, buf),
                        },
                        ['<leader><C-h>X'] = {
                            ':IHS<CR>',
                            desc('Horizontal Cycle Header/Source (Cursor)', true, buf),
                        },
                        ['<leader><C-h>V'] = {
                            ':IHV<CR>',
                            desc('Vertical Cycle Header/Source (Cursor)', true, buf),
                        },
                        ['<leader><C-h>T'] = {
                            ':IHT<CR>',
                            desc('Tab Cycle Header/Source (Cursor)', true, buf),
                        },
                    },
                }

                Keymaps(Keys, buf)
            end,
        })

        ---HACK: Delete default plugin maps
        vim.keymap.del({ 'n', 'i' }, '<leader>ihn')
        vim.keymap.del({ 'n', 'i' }, '<leader>ih')
        vim.keymap.del({ 'n', 'i' }, '<leader>is')

        User.register_plugin('plugin.a_vim')
    end,
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
