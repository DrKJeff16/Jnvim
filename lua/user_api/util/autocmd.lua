require('user_api.types.user.util')

local au = vim.api.nvim_create_autocmd

---@type User.Util.Autocmd
---@diagnostic disable-next-line:missing-fields
local M = {}

---@param T AuPair
function M.au_pair(T)
    local Value = require('user_api.check.value')

    local is_nil = Value.is_nil
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl(T) then
        vim.notify('(user_api.util.au.au_pair): Not a table', vim.log.levels.ERROR)
        return
    end
    if empty(T) then
        vim.notify('(user_api.util.au.au_pair): Empty table', vim.log.levels.WARN)
        return
    end

    if not (is_nil(T.event) or is_nil(T.opts)) then
        au(T.event, T.opts)
    elseif not (is_nil(T[1]) or is_nil(T[2])) then
        au(T[1], T[2])
    else
        vim.notify(
            '(user_api.util.au.au_pair): Table given is not of supported type',
            vim.log.levels.ERROR
        )
    end
end

---@param T AuList
function M.au_from_arr(T)
    local Value = require('user_api.check.value')

    local is_nil = Value.is_nil
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl(T) then
        vim.notify('(user_api.util.au.au_from_arr): Not a table', vim.log.levels.ERROR)
        return
    end
    if empty(T) then
        vim.notify('(user_api.util.au.au_from_arr): Empty table', vim.log.levels.WARN)
        return
    end

    for _, v in next, T do
        if not (is_nil(v.event) or is_nil(v.opts)) then
            au(v.event, v.opts)
        elseif not (is_nil(v[1]) or is_nil(v[2])) then
            au(v[1], v[2])
        else
            vim.notify(
                '(user_api.util.au.au_from_arr): Table given is not of supported type',
                vim.log.levels.ERROR
            )
        end
    end
end

---@param T AuDict
function M.au_from_dict(T)
    local Value = require('user_api.check.value')

    local is_nil = Value.is_nil
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl(T) then
        vim.notify('(user_api.util.au.au_from_arr): Not a table', vim.log.levels.ERROR)
        return
    end
    if empty(T) then
        vim.notify('(user_api.util.au.au_from_arr): Empty table', vim.log.levels.WARN)
        return
    end

    for k, v in next, T do
        if is_nil(k) or is_nil(v) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Bad autocmd and/or options table',
                vim.log.levels.ERROR
            )
            goto continue
        end

        au(k, v)

        ::continue::
    end
end

---@param T AuRepeat
function M.au_repeated(T)
    local Value = require('user_api.check.value')

    local is_nil = Value.is_nil
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl(T) then
        vim.notify('(user_api.util.au.au_repeated): Not a table', vim.log.levels.ERROR)
        return
    end
    if empty(T) then
        vim.notify('(user_api.util.au.au_repeated): Empty table', vim.log.levels.WARN)
        return
    end

    for event, t in next, T do
        if is_nil(t) or empty(t) then
            vim.notify('(user_api.util.au.au_repeated): Invalid autocmd')
            goto continue
        end

        for _, opts in next, t do
            au(event, opts)
        end

        ::continue::
    end
end

---@param T AuRepeatEvents
function M.au_repeated_events(T)
    local Value = require('user_api.check.value')

    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl({ T, T.events, T.opts_tbl }, true) then
        vim.notify('(user_api.util.au.au_repeated_events): Not a valid table', vim.log.levels.ERROR)
        return
    end
    if empty(T) or empty(T.events) or empty(T.opts_tbl) then
        vim.notify('(user_api.util.au.au_repeated_events): Empty table(s)', vim.log.levels.WARN)
        return
    end

    for _, opts in next, T.opts_tbl do
        if not is_tbl(opts) then
            vim.notify(
                '(user_api.util.au.au_repeated_events): Options are not a table',
                vim.log.levels.ERROR
            )
            goto continue
        end
        if empty(opts) then
            vim.notify(
                '(user_api.util.au.au_repeated_events): Empty options table',
                vim.log.levels.WARN
            )
            goto continue
        end

        au(T.events, opts)

        ::continue::
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
