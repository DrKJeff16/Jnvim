---@diagnostic disable:missing-fields

local ERROR = vim.log.levels.ERROR

---@return User.Check.Value
local function get_value()
    return require('user_api.check.value')
end

-- Exitstance checks.
--
-- This contains many checkers for environment, modules, namespaces, etc.
-- Also, simplified Vim functions can be found here.
-- ---
---@class User.Check.Existance
local Exists = {}

---@param mod string
---@return boolean
function Exists.module(mod)
    local Value = get_value()

    local type_not_empty = Value.type_not_empty

    if not type_not_empty('string', mod) then
        error('`(user_api.check.exists.module)`: Input is not valid', ERROR)
    end

    local res, _ = pcall(require, mod)

    return res
end

---@param mod string[]|string
---@param need_all? boolean
---@return boolean|table<string, boolean>
function Exists.modules(mod, need_all)
    local Value = get_value()
    local exists = Exists.module

    local is_str = Value.is_str
    local is_bool = Value.is_bool
    local type_not_empty = Value.type_not_empty

    if not (type_not_empty('string', mod) or type_not_empty('table', mod)) then
        error(
            '`(user_api.check.exists.modules)`: Arg neither a string nor a table, or is empty',
            ERROR
        )
    end

    need_all = is_bool(need_all) and need_all or false

    if is_str(mod) then
        return not need_all and exists(mod) or { [mod] = exists(mod) }
    end

    ---@type boolean|table<string, boolean>
    local res = {}

    for _, v in next, mod do
        local r = exists(v)

        if need_all then
            res[v] = r
        else
            -- Break when a module is not found
            if not r then
                break
            end

            res = r
        end
    end

    return res
end

---@param expr string[]|string
---@return boolean
function Exists.vim_has(expr)
    local Value = get_value()

    local type_not_empty = Value.type_not_empty

    if not (type_not_empty('string', expr) or type_not_empty('table', expr)) then
        return false
    end

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
    local Value = get_value()

    local type_not_empty = Value.type_not_empty
    local exists = vim.fn.exists

    if not (type_not_empty('string', expr) or type_not_empty('table', expr)) then
        return false
    end

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

    local environment = vim.fn.environ()

    if not (is_str(vars) or is_tbl(vars)) then
        vim.notify(
            '(user_api.check.exists.env_vars): Argument type is neither string nor table',
            ERROR
        )
        return false
    end

    fallback = is_fun(fallback) and fallback or nil

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

    if not (is_str(exe) or is_tbl(exe)) then
        vim.notify(
            '(user_api.check.exists.executable): Argument type is neither string nor table',
            ERROR
        )
        return false
    end

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

    return type_not_empty('string', path) and (vim.fn.isdirectory(path) == 1) or false
end

return Exists

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
