---@alias AuOpts vim.api.keyset.create_autocmd
---@alias AuGroupOpts vim.api.keyset.create_augroup

---@class AuPair
---@field event string[]|string
---@field opts AuOpts

---@class AuRepeatEvents
---@field events string[]
---@field opts_tbl AuOpts[]

---@alias AuDict table<string, AuOpts>
---@alias AuRepeat table<string, AuOpts[]>
---@alias AuList AuPair[]

local au = vim.api.nvim_create_autocmd

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN

---@class User.Util.Autocmd
---@field created? table
local M = {}

---@param T AuPair
function M.au_pair(T)
    local type_not_empty = require('user_api.check.value').type_not_empty

    if not type_not_empty('table', T) then
        vim.notify('(user_api.util.au.au_pair): Not a table, or empty table', ERROR)
        return
    end

    if not (type_not_empty('string', T.event) or type_not_empty('table', T.event)) then
        vim.notify('(user_api.util.au.au_pair): Event is neither a string nor a table', ERROR)
        return
    end

    au(T.event, T.opts)
end

---@param T AuList
function M.au_from_arr(T)
    local type_not_empty = require('user_api.check.value').type_not_empty

    if not type_not_empty('table', T) then
        vim.notify('(user_api.util.au.au_from_arr): Not a table', ERROR)
        return
    end

    for _, v in next, T do
        if not (type_not_empty('string', v.event) or type_not_empty('table', v.event)) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Event is neither a string nor a table, skipping',
                ERROR
            )
            goto continue
        end

        if not type_not_empty('table', v.opts) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Options are not in a table, skipping',
                ERROR
            )
            goto continue
        end

        au(v.event, v.opts)

        ::continue::
    end
end

---@param T AuDict
function M.au_from_dict(T)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local type_not_empty = Value.type_not_empty

    if not type_not_empty('table', T) then
        vim.notify('(user_api.util.au.au_from_arr): Not a table', ERROR)
        return
    end

    for k, v in next, T do
        if not is_str(k) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Dictionary key is not a string, skipping',
                ERROR
            )
            goto continue
        end

        if not type_not_empty('table', v) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Dictionary value is not a table, skipping',
                ERROR
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

    local is_str = Value.is_str
    local type_not_empty = Value.type_not_empty

    if not type_not_empty('table', T) then
        vim.notify('(user_api.util.au.au_repeated): Param is not a valid table', ERROR)
        return
    end

    for event, t in next, T do
        if not is_str(event) then
            vim.notify('(user_api.util.au.au_repeated): Event is not a string, skipping', ERROR)
            goto continue
        end

        if not type_not_empty('table', t) then
            vim.notify('(user_api.util.au.au_repeated): Invalid options table, skipping', ERROR)
            goto continue
        end

        for _, opts in next, t do
            if not type_not_empty('table', opts) then
                vim.notify('(user_api.util.au.au_repeated): Option table is empty, skipping', ERROR)
                break
            end

            au(event, opts)
        end

        ::continue::
    end
end

---@param T AuRepeatEvents
function M.au_repeated_events(T)
    local type_not_empty = require('user_api.check.value').type_not_empty

    if not type_not_empty('table', T) then
        vim.notify('(user_api.util.au.au_repeated_events): Not a valid table', ERROR)
        return
    end

    if not (type_not_empty('table', T.events) and type_not_empty('table', T.opts_tbl)) then
        vim.notify('(user_api.util.au.au_repeated_events): Invalid autocmd tables', WARN)
        return
    end

    for _, opts in next, T.opts_tbl do
        if not type_not_empty('table', opts) then
            vim.notify(
                '(user_api.util.au.au_repeated_events): Options are not a vaild table',
                ERROR
            )
            goto continue
        end

        au(T.events, opts)

        ::continue::
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
