require('user_api.types.user.highlight')

---@type User.Hl
---@diagnostic disable-next-line:missing-fields
local M = {}

---@param name string
---@param opts vim.api.keyset.highlight
---@param bufnr? integer
function M.hl(name, opts, bufnr)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local is_int = Value.is_int
    local empty = Value.empty

    if not (is_str(name) and is_tbl(opts)) or empty(name) then
        error('(user_api.highlight.hl): A highlight value is not permitted!')
    end

    bufnr = is_int(bufnr) and bufnr or 0

    vim.api.nvim_set_hl(bufnr, name, opts)
end

---@see HlPair
function M.hl_from_arr(A)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local is_int = Value.is_int
    local empty = Value.empty

    if not is_tbl(A) or empty(A) then
        error('(user_api.highlight.hl_from_arr): Unable to parse argument.')
    end

    for _, t in next, A do
        if not (is_str(t.name) and is_tbl(t.opts)) or empty(t.name) then
            error('(user_api.highlight.hl_from_arr): A highlight value is not permitted!')
        end

        M.hl(t.name, t.opts)
    end
end

--- Set hl groups based on a dict input
---
--- Example of a valid table:
--- ```lua
--- local T = { ['HlGroup'] = { fg = '...', ... }, ['HlGroupAlt'] = { ... } }
--- ```
---
--- Which translates into VimScript as:
---
--- ```vim
--- hi HlGroup ctermfg=... ...
--- hi HlGroupAlt ...
--- ```
--- ---
--- See more at `:h nvim_set_hl`
function M.hl_from_dict(D)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local is_int = Value.is_int
    local empty = Value.empty

    if not is_tbl(D) or empty(D) then
        error('(user_api.highlight.hl_from_dict): Unable to parse argument.')
    end

    for k, v in next, D do
        if (is_str(k) and is_tbl(v)) and not empty(k) then
            M.hl(k, v)
        else
            error('(user_api.highlight.hl_from_dict): A highlight value is not permitted!')
        end
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
