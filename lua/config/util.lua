---@diagnostic disable:missing-fields

---@module 'config._types'
---@module 'plugin._types.lazy'

local User = require('user_api')
local Check = User.check
local Exists = Check.exists
local Value = Check.value

local in_console = Check.in_console
local exists = Exists.module
local executable = Exists.executable
local env_vars = Exists.env_vars
local vim_exists = Exists.vim_exists
local is_bool = Value.is_bool
local is_str = Value.is_str
local type_not_empty = Value.type_not_empty

---@type Config.Util
local CfgUtil = {}

---@param force? boolean
function CfgUtil.set_tgc(force)
    force = is_bool(force) and force or false

    if force then
        vim.opt.termguicolors = true
    end

    vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()
end

---@param name string
---@return fun()
function CfgUtil.flag_installed(name)
    if not type_not_empty('string', name) then
        error('Unable to set `vim.g` var')
    end

    local flag = ''
    if name:sub(1, 10) == 'installed_' then
        flag = name
    else
        flag = 'installed_' .. name
    end

    return function()
        vim.g[flag] = 1
    end
end

-- A `config` function to call your plugin from a `lazy` spec
-- ---
--
-- ## Parameters
--
-- - `mod_str` This parameter must comply with the following format:
--
-- ```lua
-- source('plugin.<plugin_name>[.<...>]')
-- ```
--
-- as all the plugin configs MUST BE IN the repo's `lua/plugins/` directory.
-- **_That being said_**, you can use any module path if you wish to do so.
--
-- ---
--
-- ## Return
--
-- A function that attempts to import the given module from `mod_str`
-- ---
---@param self Config.Util
---@param fields string|table<string, any>
---@param force_tgc? boolean
---@return fun()
function CfgUtil:colorscheme_init(fields, force_tgc)
    force_tgc = is_bool(force_tgc) and force_tgc or false

    return function()
        if force_tgc then
            self.set_tgc(true)
        end

        if is_str(fields) then
            self.flag_installed(fields)()
            return
        end

        if type_not_empty('table', fields) then
            for field, val in next, fields do
                vim.g[field] = val
            end
        end
    end
end

-- A `config` function to call your plugin from a `lazy` spec
-- ---
--
-- ## Parameters
--
-- - `mod_str` This parameter must comply with the following format:
--
-- ```lua
-- source('plugin.<plugin_name>[.<...>]')
-- ```
--
-- as all the plugin configs MUST BE IN the repo's `lua/plugins/` directory.
-- **_That being said_**, you can use any module path if you wish to do so.
-- ---
--
-- ## Return
--
-- A function that attempts to import the given module from `mod_str`
-- ---
---@param mod_str string
---@return fun()
function CfgUtil.source(mod_str)
    return function()
        exists(mod_str, true)
    end
end

-- Returns the string for the `build` field for `Telescope-fzf` depending on certain conditions
-- ---
--
-- ## Return
--
-- ### Unix
--
-- **The return string could be empty** or something akin to
--
-- ```sh
-- $ make
-- ```
--
-- If `nproc` is found in `PATH` or a valid executable then the string could look like
--
-- ```sh
-- $ make -j"$(nproc)"
-- ```
--
-- ### Windows
--
-- If you're on Windows and use _**MSYS2**_, then it will attempt to look for `mingw32-make.exe`
-- If unsuccessful, **it'll return an empty string**
--
-- ---
---@return string
function CfgUtil.tel_fzf_build()
    local cmd = executable('nproc') and 'make -j"$(nproc)"' or 'make'

    if is_windows and executable('mingw32-make') then
        cmd = 'mingw32-' .. cmd
    elseif not executable('make') then
        cmd = ''
    end

    return cmd
end

---@return boolean
function CfgUtil.luarocks_check()
    return executable('luarocks') and env_vars({ 'LUA_PATH', 'LUA_CPATH' })
end

---@param cmd? 'ed'|'tabnew'|'split'|'vsplit'
---@return fun()
function CfgUtil.key_variant(cmd)
    cmd = (is_str(cmd) and vim.tbl_contains({ 'ed', 'tabnew', 'split', 'vsplit' }, cmd)) and cmd
        or 'ed'
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
    ---@diagnostic disable-next-line
    return (not in_console()) and (vim_exists('+termguicolors') and vim.o.termguicolors) or false
end

User:register_plugin('config.util')

return CfgUtil

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
