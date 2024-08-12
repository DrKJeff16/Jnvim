---@diagnostic disable:missing-fields

require('user_api.types.user.check')

--- Checks whether a value is `nil`, i.e. non existant or explicitly set as nil
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's nil.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as non-existant and the function will return `true`
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element doesn't exist or is `nil`, the function automatically returns false
---
--- ## Return
--- A boolean value indicating whether the data is `nil` or doesn't exist
--- ---
local is_nil = function(var, multiple)
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
end

---@type User.Check.Value
local M = {
    -- NOTE: We define `is_nil` first as it's used by the other checkers.

    --- Checks whether a value is `nil`, i.e. non existant or explicitly set as nil.
    --- ## Parameters
    ---
    --- * `var`: Any data type to be checked if it's nil.
    ---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
    ---          Otherwise it will be flagged as non-existant and the function will return `true`.
    ---
    --- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
    ---               If set to `true`, every element of the table will be checked.
    ---               If **any** element doesn't exist or is `nil`, the function automatically returns false.
    ---
    --- ## Return
    --- A boolean value indicating whether the data is `nil` or doesn't exist.
    --- ---
    is_nil = is_nil,
}

---@type fun(t: Types): ValueFunc
local function type_fun(t)
    return function(var, multiple)
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

--- Checks whether a value is a string.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's a string.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-string and the function will return `false`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not a string, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is a string or not.
--- ---
M.is_str = type_fun('string')
--- Checks whether a value is a boolean.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's a boolean.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-boolean and the function will return `false`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not a boolean, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is a boolean or not.
--- ---
M.is_bool = type_fun('boolean')
--- Checks whether a value is a function.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's a function.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-function and the function will return `false`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not a function, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is a function or not.
--- ---
M.is_fun = type_fun('function')
--- Checks whether a value is a number.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's a number.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-number and the function will return `false`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not a number, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is a number or not.
--- ---
M.is_num = type_fun('number')
--- Checks whether a value is a table.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's a table.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-table and the function will return `false`.
---
--- * `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not a table, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is a table or not.
--- ---
M.is_tbl = type_fun('table')

--- Create the rest of `is_*` functions, save for `is_int`

--- Checks whether a value is an integer i.e. _greater than or equal to `0` and a **whole number**_.
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's an integer.
---          **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
---          Otherwise it will be flagged as a non-integer and the function will return `false`.
---
--- * `multiple`: Tell the integer you're checking for multiple values. (Default: `false`).
---               If set to `true`, every element of the table will be checked.
---               If **any** element is not an integer, the function automatically returns false.
---
--- ## Return
--- A boolean value indicating whether the data is an integer or not.
--- ---
function M.is_int(var, multiple)
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

--- Returns whether a given string/number/table is "empty", including these scenarios:
--- * Is an empty string (`x == ''`)
--- * Is an integer equal to zero (`x == 0`)
--- * Is an empty table
---
--- ## Parameters
--- * `v`: Must be either a string, number or a table.
---        Otherwise you'll get complaints and the function will return `true`
---
--- ## Returns
--- A boolean indicatin whether input data is empty or not.
--- ---
function M.empty(v)
    local is_str = M.is_str
    local is_tbl = M.is_tbl
    local is_num = M.is_num
    local notify = require('user_api.util.notify').notify

    if is_str(v) then
        return v == ''
    end

    if is_num(v) then
        return v == 0
    end

    if is_tbl(v) then
        return vim.tbl_isempty(v)
    end

    notify(
        "(user.check.value.empty): Value isn't a table, string nor a number",
        'warn',
        { title = 'user_api.value.empty', hide_from_history = true, timeout = 200 }
    )
    return true
end

local function fields(field, T)
    local is_tbl = M.is_tbl
    local is_str = M.is_str
    local is_num = M.is_num
    local empty = M.empty

    if not is_tbl(T) then
        error(
            '(user.check.value.fields): Cannot look up a field in the following type: ' .. type(T)
        )
    end

    if not (is_str(field) or is_num(field) or is_tbl(field)) or empty(field) then
        error('(user.check.value.fields): Field type `' .. type(T) .. '` not parseable')
    end

    if not is_tbl(field) then
        return not is_nil(T[field])
    end

    for _, v in next, field do
        if not fields(v, T) then
            return false
        end
    end

    return true
end
M.fields = fields

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
        'user_apidata',
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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
