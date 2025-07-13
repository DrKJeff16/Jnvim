---@diagnostic disable:missing-fields

---@module 'user_api.types.check'

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN

local tbl_isempty = vim.tbl_isempty

---@type User.Check.Value
local Value = {}

-- NOTE: We define `is_nil` first as it's used by the other checkers

--- Checks whether a value is `nil`, i.e. non existant or explicitly set as nil
--- ---
--- ## Parameters
---
--- - `var`: Any data type to be checked if it's nil.
--- **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
--- Otherwise it will be flagged as non-existant and the function will return `true`
---
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
--- If set to `true`, every element of the table will be checked.
--- If **any** element doesn't exist or is `nil`, the function automatically returns false
--- ---
--- ## Return
---
--- A boolean value indicating whether the data is `nil` or doesn't exist
--- ---
---@param var any
---@param multiple? boolean
---@return boolean
function Value.is_nil(var, multiple)
    multiple = (multiple ~= nil and type(multiple) == 'boolean') and multiple or false

    if not multiple then
        return var == nil
    end

    --- Treat `var` as a table from here on
    if type(var) ~= 'table' or tbl_isempty(var) then
        return false
    end

    for _, v in next, var do
        if v ~= nil then
            vim.notify(
                '(user_api.check.value.is_nil): Input is not a table (`multiple` is true)',
                WARN
            )
            return false
        end
    end

    return true
end

---@param t Types `'thread'|'userdata'` are not parsed
---@return ValueFunc?
local function type_fun(t)
    local ALLOWED_TYPES = {
        is_bool = 'boolean',
        is_fun = 'function',
        is_num = 'number',
        is_str = 'string',
        is_tbl = 'table',
    }

    local ret = true
    local name = ''

    for k, _type in next, ALLOWED_TYPES do
        if _type == t then
            ret = false
            name = k
            break
        end
    end

    if ret then
        error('(user_api.check.value:type_fun): Invalid function type `' .. t .. '`', ERROR)
    end

    return function(var, multiple)
        multiple = (not Value.is_nil(multiple) and type(multiple) == 'boolean') and multiple
            or false

        if not multiple then
            return not Value.is_nil(var) and type(var) == t
        end

        --- Treat `var` as a table from here on
        if Value.is_nil(var) or type(var) ~= 'table' then
            return false
        end

        for _, v in next, var do
            if Value.is_nil(t) or type(v) ~= t then
                vim.notify(
                    '(user_api.check.value.'
                        .. name
                        .. '): Input is not a table (`multiple` is true)',
                    WARN
                )
                return false
            end
        end

        return true
    end
end

--- Checks whether a value is a string
--- ---
--- ## Parameters
---
--- - `var`: Any data type to be checked if it's a string.
--- **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
--- Otherwise it will be flagged as a non-string and the function will return `false`.
---
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
--- If set to `true`, every element of the table will be checked.
--- If **any** element is not a string, the function automatically returns false.
--- ---
--- ## Return
---
--- A boolean value indicating whether the data is a string or not.
--- ---
Value.is_str = type_fun('string')

--- Checks whether a value is a boolean
--- ---
--- ## Parameters
---
--- - `var`: Any data type to be checked if it's a boolean.
--- **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
--- Otherwise it will be flagged as a non-boolean and the function will return `false`.
---
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
--- If set to `true`, every element of the table will be checked.
--- If **any** element is not a boolean, the function automatically returns false.
--- ---
--- ## Return
---
--- A boolean value indicating whether the data is a boolean or not.
--- ---
Value.is_bool = type_fun('boolean')

--- Checks whether a value is a function
--- ---
--- ## Parameters
---
--- - `var`: Any data type to be checked if it's a function.
--- **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
--- Otherwise it will be flagged as a non-function and the function will return `false`.
---
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
--- If set to `true`, every element of the table will be checked.
--- If **any** element is not a function, the function automatically returns false.
--- ---
--- ## Return
---
--- A boolean value indicating whether the data is a function or not.
--- ---
Value.is_fun = type_fun('function')

--- Checks whether a value is a number
--- ---
--- ## Parameters
---
--- - `var`: Any data type to be checked if it's a number.
--- **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
--- Otherwise it will be flagged as a non-number and the function will return `false`.
---
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
--- If set to `true`, every element of the table will be checked.
--- If **any** element is not a number, the function automatically returns false.
--- ---
--- ## Return
---
--- A boolean value indicating whether the data is a number or not.
--- ---
Value.is_num = type_fun('number')

--- Checks whether a value is a table
--- ---
--- ## Parameters
---
--- - `var`: Any data type to be checked if it's a table.
--- **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
--- Otherwise it will be flagged as a non-table and the function will return `false`.
---
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
--- If set to `true`, every element of the table will be checked.
--- If **any** element is not a table, the function automatically returns false.
--- ---
--- ## Return
---
--- A boolean value indicating whether the data is a table or not.
--- ---
Value.is_tbl = type_fun('table')

--- Checks whether a value is an integer i.e. _greater than or equal to `0` and a **whole number**_.
--- ---
--- ## Parameters
---
--- * `var`: Any data type to be checked if it's an integer.
--- **Keep in mind that if `multiple` is set to `true`, this _MUST_ be a _non-empty_ table**.
--- Otherwise it will be flagged as a non-integer and the function will return `false`.
---
--- - `multiple`: Tell the integer you're checking for multiple values. (Default: `false`).
--- If set to `true`, every element of the table will be checked.
--- If **any** element is not an integer, the function automatically returns false.
--- ---
--- ## Return
---
--- A boolean value indicating whether the data is an integer or not.
--- ---
function Value.is_int(var, multiple)
    local is_tbl = Value.is_tbl
    local is_bool = Value.is_bool
    local is_num = Value.is_num

    local floor = math.floor
    local ceil = math.ceil

    multiple = is_bool(multiple) and multiple or false

    if not multiple then
        return is_num(var) and var >= 0 and (var == floor(var) or var == ceil(var))
    end

    if not is_tbl(var) then
        vim.notify('(user_api.check.value.is_int): Input is not a table (`multiple` is true)', WARN)
        return false
    end

    for _, v in next, var do
        if not (is_num(v) and v >= 0 and (v == floor(v) or v == ceil(v))) then
            return false
        end
    end

    return true
end

--- Returns whether one or more given string/number/table are **empty**
--- ---
--- - Scenarios included if `multiple` is `false`:
---     - Is an empty string (`x == ''`)
---     - Is an integer equal to zero (`x == 0`)
---     - Is an empty table (`{}`)
---
--- If `multiple` is `true` apply the above to a table of allowed values
--- NOTE: **THE FUNCTION IS NOT RECURSIVE**
--- ---
--- ## Parameters
---
--- - `v`: Must be either a string, number or a table.
--- Otherwise you'll get complaints and the function will return `true`
---
--- - `multiple`: Tell the integer you're checking for multiple values. (Default: `false`).
--- If set to `true`, every element of the table will be checked.
--- If **any** element is not _empty_, the function automatically returns `false`.
--- ---
--- ## Returns
---
--- A boolean indicatin whether input data is empty or not.
--- ---
---@param v string|table|number|integer|(string|table|number|integer)[]
---@param multiple? boolean
---@return boolean
function Value.empty(v, multiple)
    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local is_num = Value.is_num
    local is_bool = Value.is_bool

    multiple = is_bool(multiple) and multiple or false

    -- Empty string
    if is_str(v) then
        return v == ''
    end

    -- Number is 0
    if is_num(v) then
        return v == 0
    end

    -- Empty table
    if is_tbl(v) and not multiple then
        return tbl_isempty(v)
    end

    if is_tbl(v) and multiple then
        if tbl_isempty(v) then
            vim.notify(
                '(user_api.check.value.empty): No values to check despite `multiple` being `true`',
                WARN
            )
            return true
        end

        for _, val in next, v do
            -- NOTE: NO RECURSIVE CHECKING
            if Value.empty(val, false) then
                return true
            end
        end

        return false
    end

    vim.notify('(user_api.check.value.empty): Value is neither a table, string nor a number', WARN)
    return true
end

---@param num number
---@param low number
---@param high number
---@param eq? EqTbl
---@return boolean
function Value.num_range(num, low, high, eq)
    if not Value.is_num({ num, low, high }) then
        error('(user_api.check.value.num_range): One argument is not a number', ERROR)
    end

    if eq == nil or tbl_isempty(eq) then
        eq = { low = true, high = true }
    elseif not Value.is_bool(eq.high) then
        eq.high = true
    elseif not Value.is_bool(eq.low) then
        eq.low = true
    end

    if low > high then
        low, high = high, low
    end

    local COMPS = {
        low_no_high = function()
            return num >= low and num < high
        end,
        high_no_low = function()
            return num > low and num <= high
        end,
        high_low = function()
            return num >= low and num <= high
        end,
        none = function()
            return num > low and num < high
        end,
    }

    ---@type fun(): boolean
    local func

    if eq.high and eq.low then
        func = COMPS.high_low
    elseif eq.high and not eq.low then
        func = COMPS.high_no_low
    elseif not eq.high and eq.low then
        func = COMPS.low_no_high
    else
        func = COMPS.none
    end

    return func()
end

---@param field string|integer|(string|integer)[]
---@param T table<string|integer, any>
---@return boolean
function Value.fields(field, T)
    local is_tbl = Value.is_tbl
    local is_str = Value.is_str
    local is_num = Value.is_num
    local empty = Value.empty

    if not is_tbl(T) then
        local t_t = type(T)

        vim.notify(
            '(user_api.check.value.fields): Cannot look up a field on type: `' .. t_t .. '`',
            ERROR
        )
        return false
    end

    if not (is_str(field) or is_num(field) or is_tbl(field)) or empty(field) then
        vim.notify(
            '(user_api.check.value.fields): Field type `' .. type(T) .. '` is not parseable',
            ERROR
        )
        return false
    end

    if not is_tbl(field) then
        return not Value.is_nil(T[field])
    end

    for _, v in next, field do
        if not Value.fields(v, T) then
            return false
        end
    end

    return true
end

---@param values any[]|table<string, any>
---@param T table
---@param return_keys boolean
---@return boolean|string|integer|(string|integer)[] res
function Value.tbl_values(values, T, return_keys)
    local is_tbl = Value.is_tbl
    local is_str = Value.is_str
    local is_int = Value.is_int
    local is_bool = Value.is_bool
    local empty = Value.empty

    if not is_tbl(values) or empty(values) then
        vim.notify(
            '(user_api.check.value.tbl_values): Value argument is either not a table or an empty one',
            ERROR
        )
        return false
    end

    if not is_tbl(T) or empty(T) then
        vim.notify(
            '(user_api.check.value.tbl_values): Table to check is either not a table or an empty one',
            ERROR
        )
        return false
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

---@param type_str Types
---@param T table
---@return boolean
function Value.single_type_tbl(type_str, T)
    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local empty = Value.empty

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
        vim.notify(
            '(user_api.check.value.single_type_tbl): You need to define a type as a string',
            ERROR
        )
        return false
    end

    if not vim.tbl_contains(ALLOWED_TYPES, type_str) then
        vim.notify(
            '(user_api.check.value.single_type_tbl): `' .. type_str .. '` is not an allowed type',
            ERROR
        )
        return false
    end

    if not is_tbl(T) or empty(T) then
        vim.notify('(user_api.check.value.single_type_tbl): Expected a NON-EMPTY TABLE', ERROR)
        return false
    end

    for _, v in next, T do
        if type_str == 'nil' and not Value.is_nil(v) then
            return false
        end
        if type(v) ~= type_str then
            return false
        end
    end

    return true
end

--- Check if given data is a string/table/integer/number and whether it's empty or not
--- ---
--- ## Description
---
--- Specify what data type should the given value be
--- and this function will check both if it's that type
--- and if so, whether it's empty (for numbers this means a value of `0`)
--- ---
--- ## Parameters
---
---
---@param type_str EmptyTypes
---@param data string|number|table
---@return boolean
function Value.type_not_empty(type_str, data)
    local is_nil = Value.is_nil
    local empty = Value.empty

    if is_nil(data) then
        return false
    end

    ---@type table<EmptyTypes, ValueFunc>
    local valid_types = {
        ['string'] = Value.is_str,
        ['integer'] = Value.is_int,
        ['number'] = Value.is_num,
        ['table'] = Value.is_tbl,
    }

    if not vim.tbl_contains(vim.tbl_keys(valid_types), type_str) then
        return false
    end

    local checker = valid_types[type_str]

    return checker(data) and not empty(data)
end

--- Checks whether a certain `num` does not exceed table index range
--- i.e. `num >= 1 and num <= #T`
---@param num integer
---@param T table
---@return boolean
function Value.in_tbl_range(num, T)
    local is_int = Value.is_int
    local is_tbl = Value.is_tbl

    if not (is_int(num) and is_tbl(T)) then
        return false
    end

    local len = #T

    return not len == 0 and (num >= 1 and num <= len) or false
end

return Value

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
