---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:missing-fields

require('user.types.user.maps')

local Check = require('user.check')
local Util = require('user.util')

local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local empty = Check.value.empty

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

--- `which_key` API entrypoints
---@type User.Maps.WK
M = {
    available = function()
        return Check.exists.module('which-key')
    end,
}

function M.convert(rhs, opts)
    if not M.available() then
        error('(user.maps.wk.convert): `which_key` not available')
    end

    if not ((is_str(rhs) and not empty(rhs)) or is_fun(rhs)) then
        error('(user.maps.wk.convert): Incorrect argument types')
    end

    local DEFAULT_OPTS = { 'noremap', 'nowait', 'silent' }

    opts = is_tbl(opts) and opts or {}

    for _, o in next, DEFAULT_OPTS do
        opts[o] = is_bool(opts[o]) and opts[o] or true
    end

    if is_str(rhs) and rhs == 'which_key_ignore' then
        return rhs
    end

    ---@type RegKey
    local res = { rhs }

    if is_str(opts.desc) and not empty(opts.desc) then
        table.insert(res, opts.desc)
    end

    for _, o in next, DEFAULT_OPTS do
        res[o] = opts[o]
    end

    return res
end

function M.convert_dict(T)
    if not is_tbl(T) then
        error('(user.maps.wk.convert_dict): Argument of type `' .. type(T) .. '` is not a table')
    end
    if empty(T) then
        error('(user.maps.wk.convert_dict): Argument is an empty table')
    end

    ---@type RegKeys|RegKeysNamed
    local res = {}

    for lhs, v in next, T do
        if Check.value.fields({ 'name', 'noremap', 'silent', 'nowait' }, v) or not is_tbl(v[2]) then
            res[lhs] = v
        else
            v[2] = is_tbl(v[2]) and v[2] or {}

            res[lhs] = M.convert(v[1], v[2])
        end
    end

    return res
end

function M.register(T, opts)
    if not M.available() then
        Util.notify.notify('(user.maps.wk.register): `which_key` unavailable')
        return false
    end

    if not (is_tbl(T) or is_str(T)) or empty(T) then
        error('(user.maps.wk.register): Parameter is not a table')
    end

    local WK = require('which-key')
    local DEFAULT_OPTS = { 'noremap', 'nowait', 'silent' }

    opts = is_tbl(opts) and opts or {}

    opts.mode = is_str(opts.mode) and vim.tbl_contains(MODES, opts.mode) and opts.mode or 'n'

    for _, o in next, DEFAULT_OPTS do
        if not is_bool(opts[o]) then
            opts[o] = (o ~= 'nowait') and true or false
        end
    end

    ---@type RegKeys|RegKeysNamed
    local filtered = {}

    for lhs, v in next, T do
        local tbl = vim.deepcopy(v)

        for _, o in next, DEFAULT_OPTS do
            tbl[o] = is_bool(tbl[o]) and tbl[o] or opts[o]
        end

        filtered[lhs] = tbl
    end

    WK.register(filtered, opts)
end

return M
