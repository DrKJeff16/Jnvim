---@alias Types
---|'string'
---|'number'
---|'function'
---|'boolean'
---|'table'

---@alias EmptyTypes
---|'string'
---|'number'
---|'integer'
---|'table'

local fmt = string.format

local validate = vim.validate
local in_tbl = vim.tbl_contains

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN

local tbl_isempty = vim.tbl_isempty

---@param t Types
---@return fun(var: any, multiple: boolean?): boolean
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
        error(fmt('(user_api.check.value.type_fun): Invalid type `%s`', t), ERROR)
    end

    ---@param var any
    ---@param multiple? boolean
    return function(var, multiple)
        validate('multiple', multiple, 'boolean', true)

        multiple = multiple ~= nil and multiple or false

        if not multiple then
            return var ~= nil and type(var) == t
        end

        -- Treat `var` as a table from here on
        if var == nil or type(var) ~= 'table' then
            return false
        end

        for _, v in next, var do
            if t == nil or type(v) ~= t then
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

---Value checking utilities.
---
---Pretty much reserved for data checking, type checking
---and conditional operations.
--- ---
---@class User.Check.Value
local Value = {}

---Checks whether a value is a string.
--- ---
---## Parameters
---
--- - `var`: Any data type to be checked if it's a string.
---        **Keep in mind that if `multiple` is set to `true`, this _MUST be a non-empty_ table**.
---        Otherwise it will be flagged as a non-string and the function will return `false`
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---             If set to `true`, every element of the table will be checked.
---             If **any** element is not a string, the function automatically returns `false`
--- ---
---## Return
---
---A boolean value indicating whether the data is a string or not.
--- ---
---@type fun(var: any, multiple: boolean?): boolean
Value.is_str = type_fun('string')

---Checks whether a value is a boolean.
--- ---
---## Parameters
---
--- - `var`: Any data type to be checked if it's a boolean.
---        **Keep in mind that if `multiple` is set to `true`, this _MUST be a non-empty_ table**.
---        Otherwise it will be flagged as a non-boolean and the function will return `false`
---
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---             If set to `true`, every element of the table will be checked.
---             If **any** element is not a boolean, the function automatically returns `false`
--- ---
---## Return
---
---A boolean value indicating whether the data is a boolean or not.
--- ---
---@type fun(var: any, multiple: boolean?): boolean
Value.is_bool = type_fun('boolean')

---Checks whether a value is a function.
--- ---
---## Parameters
---
--- - `var`: Any data type to be checked if it's a function.
---        **Keep in mind that if `multiple` is set to `true`, this _MUST be a non-empty_ table**.
---        Otherwise it will be flagged as a non-function and the function will return `false`
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---             If set to `true`, every element of the table will be checked.
---             If **any** element is not a function, the function automatically returns `false`
--- ---
---## Return
---
---A boolean value indicating whether the data is a function or not.
--- ---
---@type fun(var: any, multiple: boolean?): boolean
Value.is_fun = type_fun('function')

---Checks whether a value is a number.
--- ---
---## Parameters
---
--- - `var`: Any data type to be checked if it's a number.
---        **Keep in mind that if `multiple` is set to `true`, this _MUST be a non-empty_ table**.
---        Otherwise it will be flagged as a non-number and the function will return `false`
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---             If set to `true`, every element of the table will be checked.
---             If **any** element is not a number, the function automatically returns `false`
--- ---
---## Return
---
---A boolean value indicating whether the data is a number or not.
--- ---
---@type fun(var: any, multiple: boolean?): boolean
Value.is_num = type_fun('number')

---Checks whether a value is a table.
--- ---
---## Parameters
---
--- - `var`: Any data type to be checked if it's a table.
---        **Keep in mind that if `multiple` is set to `true`, this _MUST be a non-empty_ table**.
---        Otherwise it will be flagged as a non-table and the function will return `false`
--- - `multiple`: Tell the function you're checking for multiple values. (Default: `false`).
---             If set to `true`, every element of the table will be checked.
---             If **any** element is not a table, the function automatically returns `false`
--- ---
---## Return
---
---A boolean value indicating whether the data is a table or not.
--- ---
---@type fun(var: any, multiple: boolean?): boolean
Value.is_tbl = type_fun('table')

---Checks whether a value is an integer i.e. _greater than or equal to `0` and a **whole number**_.
---
---Returns a boolean value indicating whether the data is an integer or not.
--- ---
---@param var any Any data type to be checked if it's an integer
---@param multiple? boolean Tell the integer you're checking for multiple values. (Default: `false`)
---@return boolean
function Value.is_int(var, multiple)
    validate('multiple', multiple, 'boolean', true)

    local is_tbl = Value.is_tbl
    local is_num = Value.is_num

    local floor = math.floor
    local ceil = math.ceil

    multiple = multiple ~= nil and multiple or false

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

---Returns whether one or more given string/number/table are **empty**.
--- ---
---
---Scenarios included if `multiple` is `false`:
---
--- - Is an empty string (`x == ''`)
--- - Is an integer equal to zero (`x == 0`)
--- - Is an empty table (`{}`)
---
---If `multiple` is `true` apply the above to a table of allowed values.
---
---**THIS FUNCTION IS NOT RECURSIVE**
--- ---
---## Parameters
---
--- - `v`: Must be either a string, number or a table.
---      Otherwise you'll get complaints and the function will return `true`
--- - `multiple`: Tell the integer you're checking for multiple values. (Default: `false`).
---             If set to `true`, every element of the table will be checked.
---             If **any** element is not _empty_, the function automatically returns `false`
--- ---
---## Returns
---
---A boolean indicating whether the input data is _empty_ or not.
--- ---
---@param data (string|table|number|integer)[]|string|table|number|integer
---@param multiple? boolean
---@return boolean
function Value.empty(data, multiple)
    validate('data', data, function(v)
        if v == nil then
            return false
        end

        return in_tbl({ 'string', 'table', 'number' }, type(v))
    end, false, '(string|table|number|integer)[]|string|table|number|integer')
    validate('multiple', multiple, 'boolean', true)

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local is_num = Value.is_num

    multiple = multiple ~= nil and multiple or false

    if is_str(data) then
        return data == ''
    end

    if is_num(data) then
        return data == 0
    end

    if is_tbl(data) and not multiple then
        return tbl_isempty(data)
    end

    if is_tbl(data) and multiple then
        if tbl_isempty(data) then
            vim.notify(
                '(user_api.check.value.empty): No values to check despite `multiple` being `true`',
                WARN
            )
            return true
        end

        for _, val in next, data do
            ---NOTE: NO RECURSIVE CHECKING
            if Value.empty(val, false) then
                return true
            end
        end

        return false
    end

    vim.notify("(user_api.check.value.empty): Value is can't be processed", WARN)
    return true
end

---Checks whether a certain number `num` is within a specified range.
--- ---
---@param num number The number to be checked
---@param low number The low limit
---@param high number The high limit
---@param eq? { low: boolean, high: boolean } A table that defines how equalities will be made
---@return boolean
function Value.num_range(num, low, high, eq)
    local is_num = Value.is_num
    local type_not_empty = Value.type_not_empty

    if not is_num({ num, low, high }, true) then
        error('(user_api.check.value.num_range): One argument is not a number', ERROR)
    end

    eq = type_not_empty('table', eq) and eq or { low = true, high = true }
    eq.high = Value.is_bool(eq.high) and eq.high or true
    eq.low = Value.is_bool(eq.low) and eq.low or true

    if low > high then
        low, high = high, low
    end

    ---@class Comparators
    local Comps = {
        ---@return boolean
        low_no_high = function()
            return num >= low and num < high
        end,

        ---@return boolean
        high_no_low = function()
            return num > low and num <= high
        end,

        ---@return boolean
        high_low = function()
            return num >= low and num <= high
        end,

        ---@return boolean
        none = function()
            return num > low and num < high
        end,
    }

    local func

    if eq.high and eq.low then
        func = Comps.high_low
    elseif eq.high and not eq.low then
        func = Comps.high_no_low
    elseif not eq.high and eq.low then
        func = Comps.low_no_high
    else
        func = Comps.none
    end

    return func()
end

---@param field (string|integer)[]|string|integer
---@param T table<string|integer, any>
---@return boolean
function Value.fields(field, T)
    local is_tbl = Value.is_tbl
    local is_int = Value.is_int
    local type_not_empty = Value.type_not_empty

    validate('field', field, function(v)
        return type_not_empty('string', v) or type_not_empty('table', v) or is_int(v)
    end, true, '(string|integer)[]|string|integer')

    validate('T', T, function(v)
        return type_not_empty('table', v)
    end, false, 'table<string|integer, any>')

    if not is_tbl(field) then
        return T[field] ~= nil
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
---@param return_keys? boolean
---@return boolean|string|integer|(string|integer)[] res
function Value.tbl_values(values, T, return_keys)
    local type_not_empty = Value.type_not_empty
    validate('values', values, function(v)
        return type_not_empty('table', v)
    end, false, 'any[]|table<string, any>')
    validate('T', T, function(v)
        return type_not_empty('table', v)
    end, false, 'table')
    validate('return_keys', return_keys, 'boolean', true)

    local is_bool = Value.is_bool
    local empty = Value.empty

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

        -- If not returning key, and no value found after previous sweep, break
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
    validate('type_str', type_str, function(v)
        if v == nil or type(v) ~= 'string' then
            return false
        end

        return in_tbl({ 'boolean', 'function', 'number', 'string', 'table' }, v)
    end, false, "'boolean'|'function'|'number'|'string'|'table'")
    validate('T', T, 'table', false)

    local type_not_empty = Value.type_not_empty

    if not type_not_empty('table', T) then
        vim.notify('(user_api.check.value.single_type_tbl): Expected a NON-EMPTY TABLE', ERROR)
        return false
    end

    for _, v in next, T do
        if (type_str == 'nil' and v ~= nil) or type(v) ~= type_str then
            return false
        end
    end

    return true
end

---Check if given data is a string/table/integer/number and whether it's empty or not.
---
---Specifies what data type should the given value be
---and this function will check both if it's that type
---and if so, whether it's empty (for numbers this means a value of `0`).
---
--- ---
---## Parameters
---
--- - `type_str`: The type string (only `'integer'`, `'number'`, `'string'` or `'table'`)
--- - `data`: The input data
--- ---
---@param type_str EmptyTypes
---@param data any
---@return boolean
function Value.type_not_empty(type_str, data)
    validate('type_str', type_str, function(v)
        if v == nil or type(v) ~= 'string' then
            return false
        end

        return in_tbl({ 'integer', 'number', 'string', 'table' }, v)
    end, false, 'EmptyTypes')

    local empty = Value.empty

    if data == nil then
        return false
    end

    ---@class ValidTypes
    local valid_types = {
        string = Value.is_str,
        integer = Value.is_int,
        number = Value.is_num,
        table = Value.is_tbl,
    }

    if not in_tbl(vim.tbl_keys(valid_types), type_str) then
        return false
    end

    local checker = valid_types[type_str]

    return checker(data) and not empty(data)
end

---Checks whether a certain `num` does not exceed table index range
---_i.e._ `num >= 1 and num <= #T`.
---
---If the table is empty, then it'll return `false`.
--- ---
---@param num integer
---@param T table
---@return boolean
function Value.in_tbl_range(num, T)
    validate('num', num, Value.is_int, false, 'integer')
    validate('T', T, 'table', false)

    local len = #T

    if len == 0 then
        return false
    end

    return num >= 1 and num <= len
end

return setmetatable(Value, {
    __index = Value,

    __newindex = function(_, _, _)
        error('User.Check.Value table is Read-Only!', ERROR)
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
