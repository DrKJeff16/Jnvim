require('user_api.types.user.maps')

local Check = require('user_api.check')
local Util = require('user_api.util')

local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_int = Check.value.is_int
local is_bool = Check.value.is_bool
local empty = Check.value.empty

---@type KeyMapOpts
---@diagnostic disable-next-line:missing-fields
local MapOpts = {}

---@param T table<string, any>
function MapOpts:add(T)
    for k, v in next, T do
        if is_str(k) then
            self[T] = v
        end
    end
end

---@param T? User.Maps.Keymap.Opts|table
---@return KeyMapOpts|table
function MapOpts.new(T)
    T = is_tbl(T) and T or {}

    return setmetatable(T, { __index = MapOpts })
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
---@diagnostic disable-next-line:missing-fields
local M = {}

---@param msg? string|'Unnamed Key'
---@param silent? boolean
---@param bufnr? integer|nil
---@param noremap? boolean
---@param nowait? boolean
---@param expr? boolean
function M.desc(msg, silent, bufnr, noremap, nowait, expr)
    ---@type KeyMapOpts
    local res = MapOpts.new({
        desc = (is_str(msg) and not empty(msg)) and msg or 'Unnamed Key',
        silent = is_bool(silent) and silent or true,
        noremap = is_bool(noremap) and noremap or true,
        nowait = is_bool(nowait) and nowait or true,
        expr = is_bool(expr) and expr or false,
    })

    if is_int(bufnr) then
        res.buffer = bufnr
    end

    return res
end

for _, mode in next, { 'n', 'i', 'v', 't', 'o', 'x' } do
    M[mode] = variant(mode)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
