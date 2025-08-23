---@diagnostic disable:missing-fields

local validate = vim.validate
local in_tbl = vim.tbl_contains

local ERROR = vim.log.levels.ERROR

---@return User.Check.Value
local function get_value()
    return require('user_api.check.value')
end

---Exitstance checks.
---
---This contains many checkers for environment, modules, namespaces, etc.
---Also, simplified Vim functions can be found here.
--- ---
---@class User.Check.Existance
local Exists = {}

---@param mod string
---@return boolean
function Exists.module(mod)
    validate('mod', mod, 'string', false)

    local Value = get_value()

    local type_not_empty = Value.type_not_empty

    if not type_not_empty('string', mod) then
        error('`(user_api.check.exists.module)`: Input is not valid', ERROR)
    end

    local res = pcall(require, mod)

    return res
end

---@param expr string[]|string
---@return boolean
function Exists.vim_has(expr)
    local type_not_empty = get_value().type_not_empty

    validate('expr', expr, function(v)
        if not in_tbl({ 'string', 'table' }, type(v)) then
            return false
        end

        return type_not_empty('string', v) or type_not_empty('table', v)
    end, false, 'string[]|string')

    if type_not_empty('string', expr) then
        return vim.fn.has(expr) == 1
    end

    for _, v in next, expr do
        if not Exists.vim_has(v) then
            return false
        end
    end

    return true
end

---@param expr string[]|string
---@return boolean
function Exists.vim_exists(expr)
    local type_not_empty = get_value().type_not_empty

    validate('expr', expr, function(v)
        if not in_tbl({ 'string', 'table' }, type(v)) then
            return false
        end

        return type_not_empty('string', v) or type_not_empty('table', v)
    end, false, 'string[]|string')

    local exists = vim.fn.exists

    if type_not_empty('string', expr) then
        return exists(expr) == 1
    end

    local res = false

    for _, v in next, expr do
        res = Exists.vim_exists(v)

        if not res then
            break
        end
    end

    return res
end

---@param vars string[]|string
---@param fallback? fun()
---@return boolean
function Exists.env_vars(vars, fallback)
    local Value = get_value()

    local is_str = Value.is_str
    local is_fun = Value.is_fun
    local is_tbl = Value.is_tbl
    local type_not_empty = Value.type_not_empty

    validate('vars', vars, function(v)
        if not in_tbl({ 'string', 'table' }, type(v)) then
            return false
        end

        return type_not_empty('string', v) or type_not_empty('table', v)
    end, false, 'string[]|string')

    validate('fallback', fallback, 'function', true, 'fun()?')

    fallback = fallback or nil

    local environment = vim.fn.environ()
    local res = false

    if is_str(vars) then
        res = vim.fn.has_key(environment, vars) == 1
    elseif is_tbl(vars) then
        for _, v in next, vars do
            res = Exists.env_vars(v)

            if not res then
                break
            end
        end
    end

    if not res and is_fun(fallback) then
        pcall(fallback)
    end

    return res
end

---@param exe string[]|string
---@return boolean
function Exists.executable(exe)
    local Value = get_value()

    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local type_not_empty = Value.type_not_empty

    validate('exe', exe, function(v)
        if not in_tbl({ 'string', 'table' }, type(v)) then
            return false
        end

        return type_not_empty('string', v) or type_not_empty('table', v)
    end, false, 'string[]|string')

    local res = false

    if is_str(exe) then
        res = vim.fn.executable(exe) == 1
    elseif is_tbl(exe) then
        for _, v in next, exe do
            res = Exists.executable(v)

            if not res then
                break
            end
        end
    end

    return res
end

---@param path string
---@return boolean
function Exists.vim_isdir(path)
    local type_not_empty = get_value().type_not_empty
    validate('path', path, 'string', false)

    return type_not_empty('string', path) and (vim.fn.isdirectory(path) == 1) or false
end

return setmetatable(Exists, {
    __index = Exists,

    __newindex = function(_, _, _)
        error('User.Check.Exists table is Read-Only!', ERROR)
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
