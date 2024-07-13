---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:missing-fields

require('user_api.types.user.maps')

local Check = require('user_api.check')
local Util = require('user_api.util')

local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local empty = Check.value.empty

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

--- `which_key` API entrypoints
---@type User.Maps.WK
M = {
    available = function() return Check.exists.module('which-key') end,
}

function M.convert(lhs, rhs, opts)
    if not M.available() then
        error('(user.maps.wk.convert): `which_key` not available')
    end

    opts = is_tbl(opts) and opts or {}

    ---@type RegKey
    local res = { lhs, rhs }

    if is_str(opts.group) and not empty(opts.group) then
        res.group = opts.group
        return res
    elseif is_str(opts.name) and not empty(opts.name) then
        res.group = opts.name
        return res
    end

    if is_str(opts.desc) and not empty(opts.desc) then
        res.desc = opts.desc
    end
    if is_str(opts.hidden) and not empty(opts.hidden) then
        res.hidden = opts.hidden
    end

    return res
end

function M.convert_dict(T)
    ---@type RegKeys
    local res = {}

    for lhs, v in next, T do
        v[2] = is_tbl(v[2]) and v[2] or {}

        table.insert(res, M.convert(lhs, v[1], v[2]))
    end

    return res
end

function M.register(T, opts)
    if not M.available() then
        Util.notify.notify('(user.maps.wk.register): `which_key` unavailable')
        return false
    end

    local WK = require('which-key')

    opts = is_tbl(opts) and opts or {}

    opts.mode = is_str(opts.mode) and vim.tbl_contains(MODES, opts.mode) and opts.mode or 'n'

    ---@type RegKeys
    local filtered = {}

    for _, val in next, T do
        table.insert(filtered, t)
    end

    WK.add(filtered)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
