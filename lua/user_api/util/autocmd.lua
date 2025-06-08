---@diagnostic disable:missing-fields

---@module 'user_api.types.user.util'

local au = vim.api.nvim_create_autocmd

---@type User.Util.Autocmd
local M = {}

---@param T AuPair
function M.au_pair(T)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
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

    if not (is_str(T.event) or is_tbl(T.event)) then
        vim.notify(
            '(user_api.util.au.au_pair): Event is neither a string nor a table',
            vim.log.levels.ERROR
        )
        return
    end
    if empty(T.event) then
        vim.notify('(user_api.util.au.au_pair): Event is empty', vim.log.levels.ERROR)
        return
    end
    if not is_tbl(T.opts) then
        vim.notify('(user_api.util.au.au_pair): Options are not in a table', vim.log.levels.ERROR)
        return
    end
    if empty(T.opts) then
        vim.notify('(user_api.util.au.au_pair): Options table is empty', vim.log.levels.ERROR)
        return
    end

    au(T.event, T.opts)
end

---@param T AuList
function M.au_from_arr(T)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
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
        if not (is_str(v.event) or is_tbl(v.event)) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Event is neither a string nor a table, skipping',
                vim.log.levels.ERROR
            )
            goto continue
        end
        if empty(v.event) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Event is either an empty string/table, skipping',
                vim.log.levels.ERROR
            )
            goto continue
        end
        if not is_tbl(v.opts) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Options are not in a table, skipping',
                vim.log.levels.ERROR
            )
            goto continue
        end
        if empty(v.opts) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Options are in an empty table, skipping',
                vim.log.levels.ERROR
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

    local is_int = Value.is_int
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
        if is_int(k) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Dictionary key is not a string, skipping',
                vim.log.levels.ERROR
            )
            goto continue
        end
        if not is_tbl(v) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Dictionary value is not a table, skipping',
                vim.log.levels.ERROR
            )
            goto continue
        end
        if empty(v) then
            vim.notify(
                '(user_api.util.au.au_from_arr): Dictionary value is an table empty, skipping',
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

    local is_int = Value.is_int
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
        if is_int(t) then
            vim.notify(
                '(user_api.util.au.au_repeated): Event is not a string, skipping',
                vim.log.levels.ERROR
            )
            goto continue
        end
        if not is_tbl(t) then
            vim.notify(
                '(user_api.util.au.au_repeated): Invalid options table, skipping',
                vim.log.levels.ERROR
            )
            goto continue
        end
        if empty(t) then
            vim.notify(
                '(user_api.util.au.au_repeated): Multi-options table is empty, skipping',
                vim.log.levels.ERROR
            )
            goto continue
        end

        for _, opts in next, t do
            if empty(opts) then
                vim.notify(
                    '(user_api.util.au.au_repeated): Option table is empty, skipping',
                    vim.log.levels.ERROR
                )
                break
            end

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
    if empty({ T, T.events, T.opts_tbl }, true) then
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
