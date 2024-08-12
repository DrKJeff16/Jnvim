require('user_api.types.user.util')

local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

---@param T AuPair
local function au_pair(T)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl(T) then
        error('(user.util.autocmd.au_pair): Not a table')
    end
    if empty(T) then
        error('(user.util.autocmd.au_pair): Empty table')
    end

    if
        (is_str(T.event) or is_tbl(T.event))
        and is_tbl(T.opts)
        and not (empty(T.opts) or empty(T.event))
    then
        au(T.event, T.opts)
    elseif (is_str(T[1]) or is_tbl(T[1])) and is_tbl(T[2]) and not (empty(T[2]) or empty(T[1])) then
        au(T[1], T[2])
    else
        error('(user.util.autocmd.au_pair): Table given is not of supported type')
    end
end

---@param T AuList
local function au_from_arr(T)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_fun = Value.is_fun
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl(T) then
        error('(user.util.autocmd.au_from_arr): Not a table')
    end
    if empty(T) then
        error('(user.util.autocmd.au_from_arr): Empty table')
    end

    for _, v in next, T do
        if
            (is_str(v.event) or is_tbl(v.event))
            and is_tbl(v.opts)
            and not (empty(v.opts) or empty(v.event))
        then
            if not is_fun(v.opts.callback) then
                error('(user.util.autocmd.au_from_arr): Missing `callback` field')
            end

            au(v.event, v.opts)
        elseif
            (is_str(v[1]) or is_tbl(v[1]))
            and is_tbl(v[2])
            and not (empty(v[2]) or empty(v[1]))
        then
            au(v[1], v[2])
        else
            error('(user.util.autocmd.au_from_arr): Table given is not of supported type')
        end
    end
end

---@param T AuDict
local function au_from_dict(T)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_fun = Value.is_fun
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl(T) then
        error('(user.util.autocmd.au_from_arr): Not a table')
    end
    if empty(T) then
        error('(user.util.autocmd.au_from_arr): Empty table')
    end

    for k, v in next, T do
        if is_str(k) and is_tbl(v) and not (empty(v) or empty(k)) then
            if not is_fun(v.callback) then
                error('(user.util.autocmd.au_from_arr): Missing `callback` field')
            end

            au(k, v)
        else
            error('(user.util.autocmd.au_from_arr): Table given is not of supported type')
        end
    end
end

---@param T AuRepeat
local function au_repeated(T)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_fun = Value.is_fun
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl(T) then
        error('(user.util.autocmd.au_repeated): Not a table')
    end
    if empty(T) then
        error('(user.util.autocmd.au_repeated): Empty table')
    end

    for event, t in next, T do
        if not is_str(event) or empty(event) then
            error('(user.util.autocmd.au_repeated): Invalid autocmd name')
        end
        for _, opts in next, t do
            if not is_fun(opts.callback) then
                error('(user.util.autocmd.au_repeated): Missing `callback` field')
            end

            au(event, opts)
        end
    end
end

---@param T AuRepeatEvents
local function au_repeated_events(T)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_fun = Value.is_fun
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl({ T, T.events, T.opts_tbl }, true) then
        error('(user.util.autocmd.au_repeated_events): Not a table')
    end
    if empty(T) or empty(T.events) or empty(T.opts_tbl) then
        error('(user.util.autocmd.au_repeated_events): Empty table')
    end
    if empty(T.events) or not Value.single_type_tbl('string', T.events) then
        error('(user.util.autocmd.au_repeated_events): Invalid autocommand name(s)')
    end

    for _, opts in next, T.opts_tbl do
        if not is_tbl(opts) then
            error('(user.util.autocmd.au_repeated_events): Options are not a table')
        end
        if empty(opts) then
            error('(user.util.autocmd.au_repeated_events): Options are an empty table')
        end
        if not is_fun(opts.callback) then
            error('(user.util.autocmd.au_repeated_events): Missing `callback` field')
        end

        au(T.events, opts)
    end
end

---@type User.Util.Autocmd
local M = {
    au_pair = au_pair,
    au_from_arr = au_from_arr,
    au_repeated = au_repeated,
    au_repeated_events = au_repeated_events,
    au_from_dict = au_from_dict,
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
