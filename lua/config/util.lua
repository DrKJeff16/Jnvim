local MODSTR = 'config.util'
local Exists = require('user_api.check.exists')
local Value = require('user_api.check.value')
local in_console = require('user_api.check').in_console
local exists = Exists.module
local executable = Exists.executable
local env_vars = Exists.env_vars
local vim_exists = Exists.vim_exists
local is_bool = Value.is_bool
local is_str = Value.is_str

local in_list = vim.list_contains
local ERROR = vim.log.levels.ERROR

---@class Config.Util
local CfgUtil = {}

---@param force? boolean
function CfgUtil.set_tgc(force)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('force', force, 'boolean', true)
    else
        vim.validate({ force = { force, { 'boolean', 'nil' } } })
    end
    force = force ~= nil and force or false
    vim.o.tgc = not force and (vim_exists('+termguicolors') and not in_console()) or true
end

---@param name string
---@param callback? fun()
---@return fun()
function CfgUtil.flag_installed(name, callback)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('name', name, 'string', false)
        vim.validate('callback', callback, 'function', true, 'fun()')
    else
        vim.validate({
            name = { name, 'string' },
            callback = { callback, { 'function', 'nil' } },
        })
    end
    if name == '' then
        error(('(%s.flag_installed): Unable to set `vim.g` var'):format(MODSTR), ERROR)
    end

    local flag = (name:sub(1, 10) == 'installed_') and name or ('installed_' .. name)
    return function()
        vim.g[flag] = 1

        if callback then
            callback()
        end
    end
end

---Set the global condition for a later submodule call.
--- ---
---@param fields string|table<string, any>
---@param force_tgc? boolean
---@return fun()
function CfgUtil.colorscheme_init(fields, force_tgc)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('fields', fields, { 'string', 'table' }, false, 'string|table<string, any>')
        vim.validate('force_tgc', force_tgc, 'boolean', true, 'boolean?')
    else
        vim.validate({
            fields = { fields, { 'string', 'table' } },
            force_tgc = { force_tgc, { 'boolean', 'nil' } },
        })
    end
    force_tgc = is_bool(force_tgc) and force_tgc or false
    return function()
        CfgUtil.set_tgc(force_tgc)
        if is_str(fields) then
            CfgUtil.flag_installed(fields)()
            return
        end
        for field, val in pairs(fields) do
            vim.g[field] = val
        end
    end
end

---A `config` function to call your plugin from a `lazy` spec.
--- ---
---@param mod_str string
---@return fun()
function CfgUtil.require(mod_str)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('mod_str', mod_str, 'string', false)
    else
        vim.validate({ mod_str = { mod_str, 'string' } })
    end
    return function()
        if exists(mod_str) then
            require(mod_str)
        end
    end
end

---Returns the string for the `build` field for `Telescope-fzf` depending on certain conditions.
---
---For UNIX systems, it'll be something akin to:
---
---```sh
---make
---```
---
---If `nproc` is found in `PATH` or a valid executable then the string could look like:
---
---```sh
---make -j"$(nproc)"
---```
---
---If you're on Windows and use _**MSYS2**_, then it will attempt to look for `mingw32-make.exe`.
---If unsuccessful, **it'll return `false`**.
--- ---
---@return string|false cmd
function CfgUtil.tel_fzf_build()
    if not executable({ 'make', 'mingw32-make' }) then
        return false
    end

    local cmd = executable({ 'make', 'nproc' }) and 'make -j"$(nproc)"'
        or (executable('make') and 'make' or 'mingw32-make')

    return cmd
end

---@return boolean
function CfgUtil.luarocks_check()
    return executable('luarocks') and env_vars({ 'LUA_PATH', 'LUA_CPATH' })
end

---@param cmd? 'ed'|'tabnew'|'split'|'vsplit'
---@return fun()
function CfgUtil.key_variant(cmd)
    if vim.fn.has('nvim-0.11') == 1 then
        vim.validate('cmd', cmd, 'string', true, "'ed'|'tabnew'|'split'|'vsplit'")
    else
        vim.validate({ cmd = { cmd, { 'string', 'nil' } } })
    end
    cmd = (cmd ~= nil and in_list({ 'ed', 'tabnew', 'split', 'vsplit' }, cmd)) and cmd or 'ed'

    local fpath = vim.fn.stdpath('config') .. '/lua/config/lazy.lua'
    local FUNCS = {
        ed = function()
            vim.cmd.ed(fpath)
        end,
        tabnew = function()
            vim.cmd.tabnew(fpath)
        end,
        split = function()
            vim.cmd.split(fpath)
        end,
        vsplit = function()
            vim.cmd.vsplit(fpath)
        end,
    }
    return FUNCS[cmd]
end

---@return boolean
function CfgUtil.has_tgc()
    if in_console or not exists('+termguicolors') then
        return false
    end
    return vim.o.termguicolors
end

return CfgUtil
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
