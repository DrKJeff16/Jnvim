---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user_api')
local Check = User.check
local maps_t = User.types.user.maps

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local empty = Check.value.empty
local map_dict = User.maps.map_dict

if not exists('scope') then
    return
end

local au_exec = vim.api.nvim_exec_autocmds
local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local Scope = require('scope')

local opts = { hooks = {} }

function opts.hooks.pre_tab_leave()
    au_exec('User', { pattern = 'ScopeTabLeavePre' })
    -- [other statements]
end

function opts.hooks.post_tab_enter()
    au_exec('User', { pattern = 'ScopeTabEnterPost' })
    -- [other statements]
end

local tab_hook = function()
    local WK = require('user_api.maps.wk')

    local desc = require('user_api.maps.kmap').desc
    local nop = require('user_api.maps').nop

    ---@param tabnr? integer
    ---@return fun()
    local function tab_cmd(tabnr)
        if not is_int(tabnr) or empty(tabnr) then
            return function() vim.cmd('ScopeMoveBuf') end
        end

        return function() vim.cmd('ScopeMoveBuf' .. tostring(tabnr)) end
    end

    local prefix = '<leader>b<C-t>'
    local nop_opts = { noremap = false, nowait = false, silent = true }
    local tab_count = #vim.api.nvim_list_tabpages()

    ---@type KeyMapDict
    local Keys = {
        [prefix .. 't'] = { tab_cmd(), desc('Prompt To Move Buf To Tab') },
    }

    if tab_count > 1 then
        local i = 1

        while i < 10 do
            local i_str = tostring(i)

            if i <= tab_count then
                Keys[prefix .. i_str] = { tab_cmd(i), desc('Move Current Buffer To Tab ' .. i_str) }
            else
                nop(prefix .. i_str, nop_opts, 'n')
            end

            i = i + 1
        end

        if WK.available() then
            map_dict({ [prefix] = { name = '+Move Buff To Tab' } }, 'wk.register', false, 'n', 0)
        end

        map_dict(Keys, 'wk.register', false, 'n', 0)
    else
        if WK.available() then
            require('which-key').add({ prefix, hidden = true, mode = 'n' })
        end

        local i = 1

        while i < 10 do
            local i_str = tostring(i)

            nop(prefix .. i_str, nop_opts, 'n')

            i = i + 1
        end
    end
end

au({ 'TabNew', 'TabNewEntered' }, {
    group = augroup('ScopeMapHook', { clear = false }),
    callback = tab_hook,
})
au('TabClosed', {
    group = augroup('ScopeMapHook', { clear = false }),
    callback = tab_hook,
})

Scope.setup(opts)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
