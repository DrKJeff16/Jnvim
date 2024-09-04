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
        vim.notify('(user_api.highlight.hl): Bad arguments', vim.log.levels.ERROR)
        return
    end

    bufnr = is_int(bufnr) and bufnr or 0

    vim.api.nvim_set_hl(bufnr, name, opts)
end

---@param A HlPair[]
function M.hl_from_arr(A)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl(A) or empty(A) then
        vim.notify('(user_api.highlight.hl_from_arr): Bad argument', vim.log.levels.ERROR)
        return
    end

    for _, t in next, A do
        if not (is_str(t.name) and is_tbl(t.opts)) or empty(t.name) then
            vim.notify(
                '(user_api.highlight.hl_from_arr): A highlight value is not permitted, skipping',
                vim.log.levels.ERROR
            )
            goto continue
        end

        M.hl(t.name, t.opts)

        ::continue::
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
---@param D HlDict
function M.hl_from_dict(D)
    local Value = require('user_api.check.value')

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local empty = Value.empty

    if not is_tbl(D) or empty(D) then
        vim.notify(
            '(user_api.highlight.hl_from_dict): Unable to parse argument',
            vim.log.levels.ERROR
        )
        return
    end

    for k, v in next, D do
        if not (is_str(k) and is_tbl(v)) or empty(k) then
            vim.notify(
                '(user_api.highlight.hl_from_dict): A highlight value is not permitted, skipping',
                vim.log.levels.ERROR
            )

            goto continue
        end

        M.hl(k, v)

        ::continue::
    end
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
