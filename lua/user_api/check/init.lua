require('user_api.types.user.check')

--- Checking Utilities
---@type User.Check
---@diagnostic disable-next-line:missing-fields
local M = {}

--- Value checking utilities
---
--- ## Description
--- Pretty much reserved for data checking, type checking and conditional operations
---@type User.Check.Value
M.value = require('user_api.check.value')

--- Exitstance checks
---
--- ## Description
--- This contains many environment, module, namespace, etc. checkers.
--- Also, simplified Vim functions can be found here
---@type User.Check.Existance
M.exists = require('user_api.check.exists')

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
function M.in_console()
    ---@type table<string, any>
    local env = vim.fn.environ()

    --- FIXME: This is not a good enough check. Must find a better solution
    return vim.tbl_contains({ 'linux' }, env['TERM']) and not M.value.fields('DISPLAY', env)
end

---@return boolean
function M.is_root()
    ---@type table<string, any>
    local env = vim.fn.environ()

    return env['USER'] == 'root'
end

_G.in_console = M.in_console()
_G.is_root = M.is_root()

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
