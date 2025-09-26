---@alias Types 'string'|'number'|'function'|'boolean'|'table'
---@alias EmptyTypes 'string'|'number'|'integer'|'table'

local MODSTR = 'user_api.check.value'
local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN
local tbl_isempty = vim.tbl_isempty
local in_list = vim.list_contains
local floor = math.floor
local ceil = math.ceil

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
    for k, _type in pairs(ALLOWED_TYPES) do
        if _type == t then
            ret = false
            name = k
            break
        end
    end
    if ret then
        error(('(%s.type_fun): Invalid type `%s`'):format(MODSTR, t), ERROR)
    end

    ---@param var any
    ---@param multiple? boolean
    return function(var, multiple)
        if vim.fn.has('nvim-0.11') == 1 then
            vim.validate('multiple', multiple, 'boolean', true)
        else
            vim.validate({ multiple = { multiple, { 'boolean', 'nil' } } })
        end
        multiple = multiple ~= nil and multiple or false
        if not multiple then
            return var ~= nil and type(var) == t
        end

        if var == nil or type(var) ~= 'table' then
            return false
        end

        for _, v in ipairs(var) do
            if t == nil or type(v) ~= t then
                vim.notify(
                    ('(%s.%s): Input is not a table (`multiple` is true)'):format(MODSTR, name),
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
Value.is_str = type_fun('string')

---Checks whether a value is a boolean.
--- ---
Value.is_bool = type_fun('boolean')

---Checks whether a value is a function.
--- ---
Value.is_fun = type_fun('function')

---Checks whether a value is a number.
--- ---
Value.is_num = type_fun('number')

---Checks whether a value is a table.
--- ---
Value.is_tbl = type_fun('table')

---Checks whether a value is an integer,
---i.e. _greater than or equal to `0` and a **whole number**_.
--- ---
---@param var any Any data type to be checked if it's an integer
---@param multiple? boolean Tell the integer you're checking for multiple values. (Default: `false`)
---@return boolean
function Value.is_int(var, multiple)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('multiple', multiple, 'boolean', true)
    else
        vim.validate({ multiple = { multiple, { 'boolean', 'nil' } } })
    end
    multiple = multiple ~= nil and multiple or false

    local is_tbl = Value.is_tbl
    local is_num = Value.is_num
    if not multiple then
        return is_num(var) and var >= 0 and (var == floor(var) or var == ceil(var))
    end
    if not is_tbl(var) then
        vim.notify(('(%s.is_int): Input is not a table (`multiple` is true)'):format(MODSTR), WARN)
        return false
    end

    for _, v in ipairs(var) do
        if not (is_num(v) and v >= 0 and (v == floor(v) or v == ceil(v))) then
            return false
        end
    end
    return true
end

---Returns whether one or more given string/number/table are **empty**.
---
---Scenarios included if `multiple` is `false`:
---
--- - Is an empty string (`x == ''`)
--- - Is an integer equal to zero (`x == 0`)
--- - Is an empty table (`{}`)
---
---If `multiple` is `true` apply the above to a table of allowed values.
---
---**THIS FUNCTION IS NOT RECURSIVE!**
--- ---
---@param data (string|number)[]|string|number|table
---@param multiple? boolean
---@return boolean
function Value.empty(data, multiple)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('data', data, { 'string', 'table', 'number' }, false)
        vim.validate('multiple', multiple, 'boolean', true, 'boolean?')
    else
        vim.validate({
            data = { data, { 'string', 'table', 'number' } },
            multiple = { multiple, { 'boolean', 'nil' } },
        })
    end
    multiple = multiple ~= nil and multiple or false

    local is_str = Value.is_str
    local is_num = Value.is_num
    if is_str(data) then
        return data == ''
    end
    if is_num(data) then
        return data == 0
    end
    if not multiple then
        return tbl_isempty(data)
    end
    if tbl_isempty(data) then
        vim.notify(('(%s.empty): No values to check!'):format(MODSTR), WARN)
        return true
    end

    for _, val in ipairs(data) do
        ---NOTE: NO RECURSIVE CHECKING
        if Value.empty(val, false) then
            return true
        end
    end
    return false
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
        error(('(%s.num_range): One argument is not a number'):format(MODSTR), ERROR)
    end

    eq = type_not_empty('table', eq) and eq or { low = true, high = true }
    eq.high = Value.is_bool(eq.high) and eq.high or true
    eq.low = Value.is_bool(eq.low) and eq.low or true
    if low > high then
        low, high = high, low
    end

    local Comps = {
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
    vim.validate('field', field, { 'string', 'number', 'table' }, true)
    vim.validate('T', T, 'table', false)
    if not is_tbl(field) then
        return T[field] ~= nil
    end
    for _, v in ipairs(field) do
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
    vim.validate('values', values, 'table', false, 'any[]|table<string, any>')
    vim.validate('T', T, 'table', false)
    vim.validate('return_keys', return_keys, 'boolean', true)
    return_keys = return_keys ~= nil and return_keys or false

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
        elseif Value.empty(res) then
            res = false
        end
    end
    return res
end

---@param type_str Types
---@param T table
---@return boolean
function Value.single_type_tbl(type_str, T)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate(
            'type_str',
            type_str,
            'string',
            false,
            "'boolean'|'function'|'number'|'string'|'table'"
        )
        vim.validate('T', T, 'table', false)
    else
        vim.validate({
            type_str = { type_str, 'string' },
            T = { T, 'table' },
        })
    end
    if not in_list({ 'boolean', 'function', 'number', 'string', 'table' }, type_str) then
        error(('(%s.single_type_tbl): Wrong type `%s`.'):format(MODSTR, type_str))
    end
    if vim.tbl_isempty(T) then
        vim.notify(('(%s.single_type_tbl): Expected a non-empty table!'):format(MODSTR), ERROR)
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
--- ---
---@param type_str EmptyTypes
---@param data any
---@return boolean
function Value.type_not_empty(type_str, data)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('type_str', type_str, 'string', false, 'EmptyTypes')
    else
        vim.validate({ type_str = { type_str, 'string' } })
    end
    if not in_list({ 'integer', 'number', 'string', 'table' }, type_str) then
        error(('(%s.type_not_empty): Invalid type `%s`!'):format(MODSTR, type_str))
    end
    if data == nil then
        return false
    end

    local valid_types = {
        string = Value.is_str,
        integer = Value.is_int,
        number = Value.is_num,
        table = Value.is_tbl,
    }
    if not in_list(vim.tbl_keys(valid_types), type_str) then
        return false
    end

    local checker = valid_types[type_str]
    return checker(data) and not Value.empty(data)
end

---Checks whether a certain `num` does not exceed table index range
---_i.e._ `num >= 1 and num <= #T`.
---
---If the table is empty, then it'll return `false`.
--- ---
---@param index integer
---@param T table
---@return boolean
function Value.in_tbl_range(index, T)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('index', index, 'number', false, 'integer')
        vim.validate('T', T, 'table', false)
    else
        vim.validate({
            index = { index, 'number' },
            T = { T, 'table' },
        })
    end
    if vim.tbl_isempty(T) then
        return false
    end
    return index >= 1 and index <= #T
end

---@type User.Check.Value
local M = setmetatable(Value, {
    __index = Value,
    __newindex = function(_, _, _)
        error('User.Check.Value table is Read-Only!', ERROR)
    end,
})

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
