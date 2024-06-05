---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local maps_t = User.types.user.maps

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local empty = Check.value.empty

if not exists('scope') then
    return
end

local au_exec = vim.api.nvim_exec_autocmds
local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local Scope = require('scope')

local opts = { hooks = {} }

if exists('barbar') then
    function opts.hooks.pre_tab_leave()
        au_exec('User', { pattern = 'ScopeTabLeavePre' })
        -- [other statements]
    end

    function opts.hooks.post_tab_enter()
        au_exec('User', { pattern = 'ScopeTabEnterPost' })
        -- [other statements]
    end
end

Scope.setup(opts)

local tab_hook = function()
    local kmap = User.maps.kmap
    local WK = User.maps.wk

    local desc = kmap.desc
    local nop = User.maps.nop

    ---@type fun(tabnr: integer?): fun()
    local function tab_cmd(tabnr)
        if not is_int(tabnr) or empty(tabnr) then
            return function()
                vim.cmd('ScopeMoveBuf')
            end
        end

        return function()
            vim.cmd('ScopeMoveBuf' .. tostring(tabnr))
        end
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
            WK.register({ [prefix] = { name = '+Move Buff To Tab' } }, { mode = 'n' })

            WK.register(WK.convert_dict(Keys), { mode = 'n' })
        else
            for lhs, v in next, Keys do
                v[2] = is_tbl(v[2]) and v[2] or {}

                kmap.n(lhs, v[1], v[2])
            end
        end
    else
        --- TODO: Fix parsing for `'which_key_ignore'` in `maps.wk.register`
        --- HACK: Use `which-key` directly due to unnacounted behaviour
        if WK.available() then
            require('which-key').register({ [prefix] = 'which_key_ignore' }, { mode = 'n' })
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
