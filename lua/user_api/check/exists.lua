local MODSTR = 'user_api.check.exists'
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
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('mod', mod, 'string', false)
    else
        vim.validate({ mod = { mod, 'string' } })
    end
    local type_not_empty = get_value().type_not_empty
    if not type_not_empty('string', mod) then
        error(('`(%s.module)`: Input is not valid'):format(MODSTR), ERROR)
    end

    local res = pcall(require, mod)
    return res
end

---@param expr string[]|string
---@return boolean
function Exists.vim_has(expr)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('expr', expr, { 'string', 'table' }, false, 'string[]|string')
    else
        vim.validate({ expr = { expr, { 'string', 'table' } } })
    end
    local type_not_empty = get_value().type_not_empty
    if type_not_empty('string', expr) then
        return vim.fn.has(expr) == 1
    end
    for _, v in ipairs(expr) do ---@cast expr string[]
        if not Exists.vim_has(v) then
            return false
        end
    end
    return true
end

---@param expr string[]|string
---@return boolean
function Exists.vim_exists(expr)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('expr', expr, { 'string', 'table' }, false, 'string[]|string')
    else
        vim.validate({ expr = { expr, { 'string', 'table' } } })
    end
    local type_not_empty = get_value().type_not_empty
    if type_not_empty('string', expr) then
        return vim.fn.exists(expr) == 1
    end

    local res = false
    for _, v in ipairs(expr) do ---@cast expr string[]
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
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('vars', vars, { 'string', 'table' }, false, 'string[]|string')
        vim.validate('fallback', fallback, 'function', true, 'fun()?')
    else
        vim.validate({
            vars = { vars, { 'string', 'table' } },
            fallback = { fallback, { 'function', 'nil' } },
        })
    end
    fallback = fallback or nil

    local Value = get_value()
    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local environment = vim.fn.environ()
    local res = false
    if is_str(vars) then
        res = vim.fn.has_key(environment, vars) == 1
    elseif is_tbl(vars) then
        for _, v in ipairs(vars) do
            res = Exists.env_vars(v)
            if not res then
                break
            end
        end
    end
    if not res and fallback and vim.is_callable(fallback) then
        fallback()
    end
    return res
end

---@param exe string[]|string
---@return boolean
function Exists.executable(exe)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('exe', exe, { 'string', 'table' }, false, 'string[]|string')
    else
        vim.validate({ exe = { exe, { 'string', 'table' } } })
    end

    local Value = get_value()
    local is_str = Value.is_str
    local is_tbl = Value.is_tbl
    local res = false
    if is_str(exe) then
        res = vim.fn.executable(exe) == 1
    elseif is_tbl(exe) then
        for _, v in ipairs(exe) do ---@cast exe string[]
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
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('path', path, 'string', false)
    else
        vim.validate({ path = { path, 'string' } })
    end
    return get_value().type_not_empty('string', path) and (vim.fn.isdirectory(path) == 1) or false
end

---@type User.Check.Existance
local M = setmetatable(Exists, {
    __index = Exists,
    __newindex = function(_, _, _)
        error('User.Check.Exists table is Read-Only!', ERROR)
    end,
})

return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
