---@diagnostic disable:missing-fields

---@alias HlOpts vim.api.keyset.highlight

---@class HlPair
---@field name string
---@field opts HlOpts

---@alias HlDict table<string, HlOpts>

---@alias HlPairs HlPair[]
---@alias HlDicts HlDict[]

local ERROR = vim.log.levels.ERROR

---@class User.Hl
local Hl = {}

---@param name string
---@param opts vim.api.keyset.highlight
---@param bufnr? integer
function Hl.hl(name, opts, bufnr)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local is_int = Value.is_int
    local empty = Value.empty
    local notify = require('user_api.util.notify').notify

    if not (is_str(name) and is_tbl(opts)) or empty(name) then
        notify('Bad arguments', ERROR, {
            title = '(user_api.highlight.hl)',
        })
        return
    end

    bufnr = is_int(bufnr) and bufnr or 0

    vim.api.nvim_set_hl(bufnr, name, opts)
end

---@param A HlPair[]
function Hl.hl_from_arr(A)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local empty = Value.empty
    local notify = require('user_api.util.notify').notify

    if not is_tbl(A) or empty(A) then
        notify('Bad argument', 'error', {
            title = '(user_api.highlight.hl_from_arr)',
            animate = true,
            timeout = 2500,
            hide_from_history = false,
        })
        return
    end

    for _, t in next, A do
        if not (is_str(t.name) and is_tbl(t.opts)) or empty(t.name) then
            notify('A highlight value is not permitted, skipping', ERROR, {
                title = '(user_api.highlight.hl_from_arr)',
                animate = true,
                timeout = 2500,
                hide_from_history = false,
            })

            goto continue
        end

        Hl.hl(t.name, t.opts)

        ::continue::
    end
end

--- Set hl groups based on a dict input.
---
--- Example of a valid table:
--- ```lua
--- --- Lua
--- local T = { ['HlGroup'] = { fg = '...', ... }, ['HlGroupAlt'] = { ... } }
--- ```
---
--- See more at `:h nvim_set_hl`.
--- ---
---@param D HlDict
function Hl.hl_from_dict(D)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local empty = Value.empty
    local notify = require('user_api.util.notify').notify

    if not is_tbl(D) or empty(D) then
        notify('Unable to parse argument', ERROR, {
            title = '(user_api.highlight.hl_from_dict)',
        })
        return
    end

    for k, v in next, D do
        if not (is_str(k) and is_tbl(v)) or empty(k) then
            notify('A highlight value is not permitted, skipping', ERROR, {
                title = '(user_api.highlight.hl_from_dict)',
            })

            goto continue
        end

        Hl.hl(k, v)

        ::continue::
    end
end

return Hl

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
