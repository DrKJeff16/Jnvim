---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

require('user.types.user.highlight')

local Check = require('user.check')

local is_nil = Check.value.is_nil
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local is_int = Check.value.is_int
local empty = Check.value.empty

---@type User.Hl
local M = {
    hl = function(name, opts, bufnr)
        if not (is_str(name) and is_tbl(opts)) or empty(name) then
            error('(user.highlight.hl): A highlight value is not permitted!')
        end

        bufnr = is_int(bufnr) and bufnr or 0

        vim.api.nvim_set_hl(bufnr, name, opts)
    end,
}

function M.hl_from_arr(arr)
    if not is_tbl(arr) or empty(arr) then
        error('(user.highlight.hl_from_arr): Unable to parse argument.')
    end

    for _, T in next, arr do
        if not (is_str(T.name) and is_tbl(T.opts)) or empty(T.name) then
            error('(user.highlight.hl_from_arr): A highlight value is not permitted!')
        end

        M.hl(T.name, T.opts)
    end
end

--- Set hl groups based on a dict input.
--- ---
--- Example of a valid table:
--- ```lua
--- local T = {
---		['HlGroup'] = { fg = '...', ... },
---		['HlGroupAlt'] = { ... },
--- }
--- ```
--- Which equals to:
--- ```vim
---	hi HlGroup ctermfg=... ...
---	hi HlGroupAlt ...
--- ```
---
--- See more at `:h nvim_set_hl`
function M.hl_from_dict(dict)
    if not is_tbl(dict) or empty(dict) then
        error('(user.highlight.hl_from_dict): Unable to parse argument.')
    end

    for k, v in next, dict do
        if (is_str(k) and is_tbl(v)) and not empty(k) then
            M.hl(k, v)
        else
            error('(user.highlight.hl_from_dict): A highlight value is not permitted!')
        end
    end
end

return M
