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

---@type Modes
local MODES = { 'n', 'i', 'v', 't', 'o', 'x' }

---@type fun(mode: string): BufMapFunction
local function variant(mode)
    ---@type BufMapFunction
    return function(b, lhs, rhs, opts)
        local DEFAULTS = { 'noremap', 'nowait', 'silent' }
        opts = is_tbl(opts) and opts or {}
        b = is_int(b) and b or 0

        for _, v in next, DEFAULTS do
            opts[v] = is_bool(opts[v]) and opts[v] or true
        end

        vim.api.nvim_buf_set_keymap(b, mode, lhs, rhs, opts)
    end
end

---@type User.Maps.Buf
local M = {
    desc = function(msg, silent, noremap, nowait, expr)
        ---@type User.Maps.Api.Opts
        return {
            desc = (is_str(msg) and not empty(msg)) and msg or 'Unnamed Key',
            silent = is_bool(silent) and silent or true,
            noremap = is_bool(noremap) and noremap or true,
            nowait = is_bool(nowait) and nowait or true,
            expr = is_bool(expr) and expr or false,
        }
    end,
}

for _, mode in next, { 'n', 'i', 'v', 't', 'o', 'x' } do
    M[mode] = variant(mode)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
