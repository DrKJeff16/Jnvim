local Keymaps = require('config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local type_not_empty = Check.value.type_not_empty

local au_exec = vim.api.nvim_exec_autocmds
local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

if not exists('scope') then
    return
end

local Scope = require('scope')

local Opts = {}
Opts.hooks = {}

function Opts.hooks.pre_tab_leave()
    au_exec('User', { pattern = 'ScopeTabLeavePre' })
end

function Opts.hooks.post_tab_enter()
    au_exec('User', { pattern = 'ScopeTabEnterPost' })
end

local group = augroup('ScopeMapHook', { clear = false })

au({ 'TabNew', 'TabNewEntered', 'TabClosed', 'TabEnter', 'TabLeave' }, {
    group = group,
    pattern = '*',
    callback = function()
        local WK = require('which-key')
        local desc = require('user_api.maps.kmap').desc
        local nop = require('user_api.maps').nop

        ---@param tabnr? integer
        ---@return fun()
        local function tab_cmd(tabnr)
            local cmd = 'ScopeMoveBuf '

            if type_not_empty('integer', tabnr) then
                cmd = cmd .. tostring(tabnr)
            end

            return function()
                vim.cmd(cmd)
            end
        end

        local prefix = '<leader>b<C-t>'
        local nop_opts = { noremap = false, nowait = false, silent = true }
        local tab_count = #vim.api.nvim_list_tabpages()

        ---@type AllMaps
        local Keys = {
            [prefix] = { group = '+Move Buf To Tab' },

            [prefix .. 't'] = { tab_cmd(), desc('Prompt Moving Buf To Tab', false) },
        }

        if tab_count > 1 then
            ---@type integer
            local i = 1

            while i < 10 do
                local i_str = tostring(i)

                if i <= tab_count then
                    Keys[prefix .. i_str] =
                        { tab_cmd(i), desc('Move Current Buffer To Tab #' .. i_str) }
                else
                    nop(i_str, nop_opts, 'n', prefix)
                end

                i = i + 1
            end

            Keymaps({ n = Keys })
        else
            if User.maps.wk.available() then
                WK.add({
                    prefix,
                    hidden = true,
                    mode = 'n',
                })
            end

            ---@type integer
            local i = 1

            while i < 10 do
                nop(tostring(i), nop_opts, 'n', prefix)

                i = i + 1
            end
        end
    end,
})

Scope.setup(Opts)

User:register_plugin('plugin.scope')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
