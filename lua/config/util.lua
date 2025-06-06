---@diagnostic disable:missing-fields

---@module 'user_apitypes.lazy'

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local executable = Check.exists.executable
local env_vars = Check.exists.env_vars
local vim_exists = Check.exists.vim_exists
local is_nil = Check.value.is_nil
local is_bool = Check.value.is_bool
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local in_console = Check.in_console

User:register_plugin('config.util')

---@type PluginUtils
local M = {}

---@param force? boolean
function M.set_tgc(force)
    force = is_bool(force) and force or false

    if force then
        vim.opt.termguicolors = true
    end

    vim.opt.termguicolors = (not vim_exists('+termguicolors') or in_console())
end

---@param name string
---@return fun()?
function M.flag_installed(name)
    if not is_str(name) or name == '' then
        error('Unable to set `vim.g` var')
    end

    local flag = ''
    if name:sub(1, 10) == 'installed_' then
        flag = name
    else
        flag = 'installed_' .. name
    end

    if not is_nil(vim.g[flag]) then
        vim.notify('`g:' .. flag .. '` is being overwritten', vim.log.levels.WARN)
    end

    return function() vim.g[flag] = 1 end
end

--- Set the global condition for a later submodule call
--- ---
---
--- ## Parameters
--- - `field`: Either a `string` that will be the name of a vim `g:...` variable, or
---            a `dictionary` with the keys as the vim `g:...` variable names, and the value
---            as whatever said variables are set to respectively.
---
--- ## Return
---
--- A function that sets the pre-loading for the colorscheme
--- and initializes the `vim.g.<field>` variable(s)
---@param fields string|table<string, any>
---@return fun()
function M.colorscheme_init(fields)
    return function()
        M.set_tgc()

        if is_str(fields) then
            M.flag_installed(fields)()
        elseif is_tbl(fields) and not empty(fields) then
            for field, val in next, fields do
                vim.g[field] = val
            end
        end
    end
end

--- A `config` function to call your plugin from a `lazy` spec
--- ---
--- ## Parameters
---
--- - `mod_str` This parameter must comply with the following format:
---
--- ```lua
--- source('plugin.<plugin_name>[.<...>]')
--- ```
---
--- as all the plugin configs MUST BE IN the repo's `lua/plugins/` directory.
--- **_That being said_**, you can use any module path if you wish to do so.
---
--- ## Return
--- A function that attempts to import the given module from `mod_str`
---@param mod_str string
---@return fun()
function M.source(mod_str)
    return function() exists(mod_str, true) end
end

--- Returns the string for the `build` field for `Telescope-fzf` depending on certain conditions
--- ---
--- ## Return
---
--- ### Unix
--- **The return string could be empty** or something akin to
---
--- ```sh
--- $ make
--- ```
---
--- If `nproc` is found in `PATH` or a valid executable then the string could look like
---
--- ```sh
--- $ make -j"$(nproc)"
--- ```
---
--- ### Windows
--- If you're on Windows and use _**MSYS2**_, then it will attempt to look for `mingw32-make.exe`
--- If unsuccessful, **it'll return an empty string**
---@return string
function M.tel_fzf_build()
    local cmd = executable('nproc') and 'make -j"$(nproc)"' or 'make'

    if is_windows and executable('mingw32-make') then
        cmd = 'mingw32-' .. cmd
    elseif not executable('make') then
        cmd = ''
    end

    return cmd
end

---@return boolean
function M.luarocks_check() return executable('luarocks') and env_vars({ 'LUA_PATH', 'LUA_CPATH' }) end

---@param cmd? 'ed'|'tabnew'|'split'|'vsplit'
---@return fun()
function M.key_variant(cmd)
    cmd = (is_str(cmd) and vim.tbl_contains({ 'ed', 'tabnew', 'split', 'vsplit' }, cmd)) and cmd
        or 'ed'
    local fpath = vim.fn.stdpath('config') .. '/lua/config/lazy.lua'

    local FUNCS = {
        ed = function() vim.cmd.ed(fpath) end,
        tabnew = function() vim.cmd.tabnew(fpath) end,
        split = function() vim.cmd.split(fpath) end,
        vsplit = function() vim.cmd.vsplit(fpath) end,
    }

    return FUNCS[cmd]
end

---@return boolean
function M.has_tgc()
    ---@diagnostic disable-next-line
    return vim_exists('+termguicolors') and vim.opt.termguicolors:get()
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
