---@diagnostic disable:missing-fields

---@class User.Check
---@field exists User.Check.Existance
---@field value User.Check.Value
--- Check whether Nvim is running in a Linux Console rather than a `pty`
--- ---
--- ## Description
---
--- This function can be useful for (un)loading certain elements that conflict with the Linux console, for example
--- ---
--- ## Return
---
--- A boolean that confirms whether the environment is a Linux Console
---@field in_console fun(): boolean
--- Check whether Nvim is running in a Linux Console rather than a `pty`
--- ---
--- ## Description
---
--- This function can be useful for (un)loading certain elements that conflict with the Linux console, for example
--- ---
--- ## Return
---
--- A boolean that confirms whether the environment is a Linux Console
---@field is_root fun(): boolean

--- Checking Utilities
--- ---
---@type User.Check
local Check = {}

Check.value = require('user_api.check.value')

Check.exists = require('user_api.check.exists')

---@return boolean
function Check.in_console()
    local fields = Check.value.fields
    ---@type table<string, any>
    local env = vim.fn.environ()

    --- FIXME: This is not a good enough check. Must find a better solution
    return (vim.tbl_contains({ 'linux' }, env['TERM']) and not fields('DISPLAY', env))
end

---@return boolean
function Check.is_root()
    return (vim.uv or vim.loop).getuid() == 0
end

_G.in_console = Check.in_console()
_G.is_root = Check.is_root()

return Check

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
