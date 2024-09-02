require('user_api.types.user.check')

local Value = require('user_api.check.value')

local is_nil = Value.is_nil
local is_bool = Value.is_bool
local is_str = Value.is_str
local is_tbl = Value.is_tbl
local is_num = Value.is_num
local is_fun = Value.is_fun
local empty = Value.empty

---@type User.Check.Existance
---@diagnostic disable-next-line:missing-fields
local M = {}

---@param mod string
---@param return_mod? boolean
---@return boolean|unknown|nil
function M.module(mod, return_mod)
    if not is_str(mod) then
        error('`(user_api.check.exists.module)`: Input is not a string')
    end
    if mod == '' then
        error("`(user_api.check.exists.module)`: Input can't be an empty string")
    end

    return_mod = is_bool(return_mod) and return_mod or false

    local res

    if return_mod then
        local m

        res, m = pcall(require, mod)
        return (res and not is_nil(m)) and m or nil
    end

    res = pcall(require, mod)
    return res
end

---@param mod string|string[]
---@param need_all? boolean
---@return boolean|table<string, boolean>
function M.modules(mod, need_all)
    local exists = M.module

    if not (is_str(mod) or is_tbl(mod)) or empty(mod) then
        error('`(user_api.check.exists.modules)`: Input is neither a string nor a table')
    end

    need_all = is_bool(need_all) and need_all or false

    ---@type boolean|table<string, boolean>
    local res = false

    if is_str(mod) then
        res = not need_all and exists(mod) or { [mod] = exists(mod) }
    else
        res = {}

        for _, v in next, mod do
            local r = exists(v)

            if need_all then
                res[v] = r
            else
                res = r

                -- Break when a module is not found
                if not r then
                    break
                end
            end
        end
    end

    return res
end

---@param expr string|string[]
---@return boolean
function M.vim_has(expr)
    if is_str(expr) then
        return vim.fn.has(expr) == 1
    end

    if is_tbl(expr) and not empty(expr) then
        local res = false

        for _, v in next, expr do
            if not M.vim_has(v) then
                return false
            end
        end

        return true
    end

    return false
end

---@param expr string|string[]
---@return boolean
function M.vim_exists(expr)
    local exists = vim.fn.exists

    if is_str(expr) then
        return exists(expr) == 1
    end

    if is_tbl(expr) and not empty(expr) then
        local res = false
        for _, v in next, expr do
            res = M.vim_exists(v)

            if not res then
                break
            end
        end

        return res
    end

    return false
end

---@param vars string|string[]
---@param fallback? fun()
---@return boolean
function M.env_vars(vars, fallback)
    local environment = vim.fn.environ()

    if not (is_str(vars) or is_tbl(vars)) then
        vim.notify(
            '(user_api.check.exists.env_vars): Argument type is neither string nor table',
            vim.log.levels.ERROR
        )
        return false
    end

    fallback = is_fun(fallback) and fallback or nil

    local res = false

    if is_str(vars) then
        res = vim.fn.has_key(environment, vars) == 1
    elseif is_tbl(vars) then
        for _, v in next, vars do
            res = M.env_vars(v)

            if not res then
                break
            end
        end
    end

    if not res and is_fun(fallback) then
        fallback()
    end

    return res
end

---@param exe string|string[]
---@param fallback? fun()
---@return boolean
function M.executable(exe, fallback)
    if not (is_str(exe) or is_tbl(exe)) then
        vim.notify(
            '(user_api.check.exists.executable): Argument type is neither string nor table',
            vim.log.levels.ERROR
        )
        return false
    end

    fallback = is_fun(fallback) and fallback or nil

    local res = false

    if is_str(exe) then
        res = vim.fn.executable(exe) == 1
    elseif is_tbl(exe) then
        for _, v in next, exe do
            res = M.executable(v)

            if not res then
                break
            end
        end
    end

    if not res and is_fun(fallback) then
        fallback()
    end

    return res
end

---@param path string
---@return boolean
function M.vim_isdir(path)
    return (is_str(path) and not empty(path)) and (vim.fn.isdirectory(path) == 1) or false
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
