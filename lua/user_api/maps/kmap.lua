---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:missing-fields

require('user_api.types.user.maps')

local Check = require('user_api.check')
local Util = require('user_api.util')

local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_int = Check.value.is_int
local is_bool = Check.value.is_bool
local empty = Check.value.empty

---@class KeyMapOpts: vim.keymap.set.Opts
---@field new fun(T: (table|table<string, any>)?): KeyMapOpts
---@field add fun(self: KeyMapOpts, T: User.Maps.Keymap.Opts|table<string, any>): KeyMapOpts

---@type KeyMapOpts
local MapOpts = {}

---@return KeyMapOpts
function MapOpts.new()
    local self = setmetatable({}, { __index = MapOpts })

    return self
end

---@param T table<string, any>
---@return KeyMapOpts
function MapOpts:add(T)
    if not is_tbl(T) or empty(T) then
        return self
    end

    for k, v in next, T do
        if is_str(k) then
            self[T] = v
        end
    end

    return self
end

---@type Modes
local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

---@param mode string
---@return KeyMapFunction
local function variant(mode)
    ---@type KeyMapFunction
    return function(lhs, rhs, opts)
        local DEFAULTS = { 'noremap', 'nowait', 'silent' }
        opts = is_tbl(opts) and opts or {}

        for _, v in next, DEFAULTS do
            opts[v] = is_bool(opts[v]) and opts[v] or true
        end

        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

---@type User.Maps.Keymap
local M = {
    desc = function(msg, silent, bufnr, noremap, nowait, expr)
        ---@type KeyMapOpts
        local res = MapOpts.new()

        res:add({
            desc = (is_str(msg) and not empty(msg)) and msg or 'Unnamed Key',
            silent = is_bool(silent) and silent or true,
            noremap = is_bool(noremap) and noremap or true,
            nowait = is_bool(nowait) and nowait or true,
            expr = is_bool(expr) and expr or false,
        })

        if is_int(bufnr) then
            res:add({ buffer = bufnr })
        end

        return res
    end,
}

for _, mode in next, { 'n', 'i', 'v', 't', 'o', 'x' } do
    M[mode] = variant(mode)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
