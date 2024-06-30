---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.lazy

local exists = Check.exists.module
local executable = Check.exists.executable
local env_vars = Check.exists.env_vars
local vim_exists = Check.exists.vim_exists
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local in_console = Check.in_console

---@type PluginUtils
local M = {
    --- Set the global condition for a later submodule call.
    ---
    --- ## Parameters
    --- * `field`: Either a `string` that will be the name of a vim `g:...` variable, or
    --- a `dictionary` with the keys as the vim `g:...` variable names, and the value
    --- as whatever said variables are set to respectively.
    ---
    --- ## Return
    --- A `function` that sets the pre-loading for the colorscheme and initializes the `g:field` variable(s).
    ---@param fields string|table<string, any>
    ---@return fun()
    colorscheme_init = function(fields)
        if not (is_str(fields) or is_tbl(fields)) or empty(fields) then
            error('(plugins:colorscheme_init): Unable to initialize colorscheme.')
        end

        return function()
            vim.opt.termguicolors = vim_exists('+termguicolors') and not in_console()

            if is_str(fields) then
                vim.g[fields] = 1
            else
                for field, val in next, fields do
                    vim.g[field] = val
                end
            end
        end
    end,

    --- A `config` function to call your plugin.
    ---
    --- ## Parameters
    --- * `mod_str` This parameter must comply with the following format:
    ---```lua
    --- source('plugin.<plugin_name>[.<...>]')
    --- ```
    --- as all the plugin configs MUST BE IN the repo's `lua/plugins/` directory.
    --- **_That being said_**, you can use any module path if you wish to do so.
    ---
    --- ## Return
    --- A function that attempts to `require` the given `mod_str`.
    ---@param mod_str string
    ---@return fun()
    source = function(mod_str)
        return function()
            require('user.check.exists').module(mod_str, true)
        end
    end,
    --- Returns the string for the `build` field for `Telescope-fzf` depending on certain conditions.
    ---
    --- ## Return
    ---
    --- ### Unix
    --- **The return string could be empty** or something akin to
    --- ```sh
    --- $ make
    --- ```
    --- If `nproc` is found in `PATH` or a valid executable then the string could look like
    --- ```sh
    --- $ make -j"$(nproc)"
    --- ```
    --- ### Windows
    --- If you're on Windows and use _**MSYS2**_, then it will attempt to look for `mingw32-make.exe`.
    --- If unsuccessful, **it'll return an empty string**.
    ---@return string
    tel_fzf_build = function()
        local cmd = executable('nproc') and 'make -j"$(nproc)"' or 'make'

        if is_windows and executable('mingw32-make') then
            cmd = 'mingw32-' .. cmd
        elseif not executable('make') then
            cmd = ''
        end

        return cmd
    end,

    --- Returns the string for the `build` field for `LuaSnip` depending on certain conditions.
    ---
    --- ## Return
    ---
    --- ### Unix
    --- **The return string could be empty** or something akin to
    --- ```sh
    --- $ make install_jsregexp
    --- ```
    --- If `nproc` is found in `PATH` or a valid executable then the string could look like
    --- ```sh
    --- $ make -j"$(nproc)" install_jsregexp
    --- ```
    --- ### Windows
    --- If you're on Windows and use _**MSYS2**_, then it will attempt to look for `mingw32-make.exe`.
    ---@return string
    luasnip_build = function()
        local cmd = executable('nproc') and 'make -j"$(nproc)" install_jsregexp' or 'make install_jsregexp'

        if is_windows and executable('mingw32-make') then
            cmd = 'mingw32-' .. cmd
        elseif is_windows and not executable('make') then
            cmd = ''
        end

        return cmd
    end,

    ---@return boolean
    luarocks_set = function()
        return executable('luarocks') and env_vars({ 'LUA_PATH', 'LUA_CPATH' })
    end,
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
