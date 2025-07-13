---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:missing-fields

---@module 'user_api.types.maps'

local Value = require('user_api.check.value')

local is_tbl = Value.is_tbl
local is_fun = Value.is_fun
local is_str = Value.is_str
local is_bool = Value.is_bool
local empty = Value.empty

local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

--- `which_key` API entrypoints
---@type User.Maps.WK
---@diagnostic disable-next-line:missing-fields
local WK = {}

function WK.available()
    return require('user_api.check.exists').module('which-key')
end

function WK.convert(lhs, rhs, opts)
    if not WK.available() then
        error('(user.maps.wk.convert): `which_key` not available')
    end

    opts = is_tbl(opts) and opts or {}

    ---@type RegKey
    local res = { lhs, rhs }

    if is_bool(opts.hidden) and not empty(opts.hidden) then
        res.hidden = opts.hidden
    end

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

    return res
end

function WK.convert_dict(T)
    ---@type RegKeys
    local res = {}

    for lhs, v in next, T do
        v[2] = is_tbl(v[2]) and v[2] or {}

        table.insert(res, WK.convert(lhs, v[1], v[2]))
    end

    return res
end

function WK.register(T, opts)
    if not WK.available() then
        require('user_api.util.notify').notify('(user.maps.wk.register): `which_key` unavailable')
        return false
    end

    local WKEY = require('which-key')

    opts = is_tbl(opts) and opts or {}

    opts.mode = is_str(opts.mode) and vim.tbl_contains(MODES, opts.mode) and opts.mode or 'n'

    ---@type RegKeys
    local filtered = {}

    for _, val in next, T do
        table.insert(filtered, val)
    end

    WKEY.add(filtered)
end

return WK

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
