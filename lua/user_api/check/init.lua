---@diagnostic disable:missing-fields

---@module 'user_api.types.check'

--- Checking Utilities
--- ---
---@type User.Check
local Check = {}

--- Value checking utilities
--- ---
--- ## Description
---
--- Pretty much reserved for data checking, type checking and conditional operations
--- ---
---@type User.Check.Value
Check.value = require('user_api.check.value')

--- Exitstance checks
--- ---
--- ## Description
---
--- This contains many checkers for environment, modules, namespaces, etc.
--- Also, simplified Vim functions can be found here
---@type User.Check.Existance
Check.exists = require('user_api.check.exists')

--- Check whether Nvim is running in a Linux Console rather than a `pty`
--- ---
--- ## Description
---
--- This function can be useful for (un)loading certain elements that conflict with the Linux console, for example
--- ---
--- ## Return
---
--- A boolean that confirms whether the environment is a Linux Console
--- ---
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
