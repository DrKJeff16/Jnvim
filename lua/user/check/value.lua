---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:need-check-nil
---@diagnostic disable:missing-fields

require('user.types.user.check')

---@type ValueCheck
local M = {
    -- NOTE: We define `is_nil` first as it's used by the other checkers.

    --- Check whether a value is `nil`, i.e. non existant or explicitly set as nil.
    --- ---
    --- ## Parameters
    ---
    --- * `var`: Any data type to be checked if it's nil.
    ---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
    ---          Otherwise it will be flagged as non-existant and function will return `true`.
    ---
    --- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
    ---               If set to `true`, every element of the table will be checked.
    ---               If **any** element doesn't exist or is `nil`, automatically returns false
    --- ---
    --- ## Return
    --- A boolean value indicating whether in data is `nil` or doesn't exist.
    --- ---
    is_nil = function(var, multiple)
        multiple = (multiple ~= nil and type(multiple) == 'boolean') and multiple or false

        if not multiple then
            return var == nil
        end

        --- Treat `var` as a table from here on
        if type(var) ~= 'table' or vim.tbl_isempty(var) then
            return false
        end

        for _, v in next, var do
            if v ~= nil then
                return false
            end
        end

        return true
    end,
}

local type_funcs = {
    ['is_str'] = 'string',
    ['is_bool'] = 'boolean',
    ['is_fun'] = 'function',
    ['is_num'] = 'number',
    ['is_tbl'] = 'table',
}

---@type fun(t: Types): ValueFunc
local function type_fun(t)
    return function(var, multiple)
        local is_nil = M.is_nil

        multiple = (not is_nil(multiple) and type(multiple) == 'boolean') and multiple or false

        if not multiple then
            return not is_nil(var) and type(var) == t
        end

        --- Treat `var` as a table from here on
        if is_nil(var) or type(var) ~= 'table' then
            return false
        end

        for _, v in next, var do
            if is_nil(t) or type(v) ~= t then
                return false
            end
        end

        return true
    end
end

--- Create the rest of `is_*` functions, save for `is_int`
for k, v in next, type_funcs do
    M[k] = type_fun(v)
end

function M.is_int(var, multiple)
    local is_nil = M.is_nil
    local is_tbl = M.is_tbl
    local is_bool = M.is_bool
    local is_num = M.is_num

    multiple = is_bool(multiple) and multiple or false

    if not multiple then
        return is_num(var) and var >= 0 and var == math.floor(var)
    end

    if not is_tbl(var) then
        return false
    end

    for _, v in next, var do
        if not (is_num(v) and v >= 0 and v == math.floor(v)) then
            return false
        end
    end

    return true
end

--- Returns whether a data value is "empty", including these scenarios:
--- * Is an empty string (`x == ''`)
--- * Is an integer equal to zero (`x == 0`)
--- * Is an empty table
--- ---
--- ## Parameters
--- * `v`: Must be either a string, number or a table.
---        Otherwise you'll get complaints and the function will return `true`
--- ---
function M.empty(v)
    local is_str = M.is_str
    local is_tbl = M.is_tbl
    local is_num = M.is_num
    local notify = require('user.util.notify').notify

    if is_str(v) then
        return v == ''
    end

    if is_num(v) then
        return v == 0
    end

    if is_tbl(v) then
        return vim.tbl_isempty(v)
    end

    notify("(user.check.value.empty): Value isn't a table, string nor a number", 'warn', { title = 'user.value.empty' })
    return true
end

function M.fields(fields, T)
    local is_nil = M.is_nil
    local is_tbl = M.is_tbl
    local is_str = M.is_str
    local is_num = M.is_num
    local empty = M.empty

    if not is_tbl(T) then
        error('(user.check.value.fields): Cannot look up a field in the following type: ' .. type(T))
    end

    if not (is_str(fields) or is_num(fields) or is_tbl(fields)) or empty(fields) then
        error('(user.check.value.fields): Field type `' .. type(T) .. '` not parseable')
    end

    if not is_tbl(fields) then
        return not is_nil(T[fields])
    end

    for _, v in next, fields do
        if not M.fields(v, T) then
            return false
        end
    end

    return true
end

function M.tbl_values(values, T, return_keys)
    local is_tbl = M.is_tbl
    local is_str = M.is_str
    local is_int = M.is_int
    local is_bool = M.is_bool
    local empty = M.empty

    if not is_tbl(values) or empty(values) then
        error('(user.check.value.tbl_values): Value argument is either not a table or an empty one')
    end

    if not is_tbl(T) or empty(T) then
        error('(user.check.value.tbl_values): Table to check is either not a table or an empty one')
    end

    return_keys = is_bool(return_keys) and return_keys or false

    ---@type boolean|string|integer|(string|integer)[]
    local res = return_keys and {} or false

    for _, val in next, values do
        for k, v in next, T do
            if return_keys and v == val then
                table.insert(res, k)
            elseif not return_keys and v == val then
                res = true
                break
            end
        end

        --- If not returning key, and no value found after previous sweep, break
        if not (return_keys or res) then
            break
        end
    end

    if return_keys then
        if #res == 1 then
            res = res[1]
        elseif empty(res) then
            res = false
        end
    end

    return res
end

function M.single_type_tbl(type_str, T)
    local is_str = M.is_str
    local is_tbl = M.is_tbl
    local empty = M.empty

    local ALLOWED_TYPES = {
        'boolean',
        'function',
        'nil',
        'number',
        'string',
        'table',
        'thread',
        'userdata',
    }

    if not is_str(type_str) then
        error('(user.check.value.single_type_tbl): You need to define a type as a string')
    end

    if not vim.tbl_contains(ALLOWED_TYPES, type_str) then
        error('(user.check.value.single_type_tbl): `' .. type_str .. '` is not an allowed type')
    end

    if not is_tbl(T) or empty(T) then
        error('(user.check.value.single_type_tbl): Expected a NON-EMPTY TABLE')
    end

    for _, v in next, T do
        if type(v) ~= type_str then
            return false
        end
    end

    return true
end

return M
