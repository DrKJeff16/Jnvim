local ERROR = vim.log.levels.ERROR
local in_list = vim.list_contains

---Checking Utilities.
--- ---
---@class User.Check
local Check = {}

Check.value = require('user_api.check.value')
Check.exists = require('user_api.check.exists')

---Check whether Nvim is running in a Linux Console rather than a `pty`.
---
---This function can be useful for (un)loading certain elements
---that conflict with the Linux console, for example.
--- ---
---@return boolean
function Check.in_console()
    local fields = Check.value.fields

    ---@type table<string, string>
    local env = vim.fn.environ()

    --- FIXME: This is not a good enough check. Must find a better solution
    return in_list({ 'linux' }, env['TERM']) and not fields('DISPLAY', env)
end

---Check whether Nvim is running as root (`PID == 0`).
--- ---
---@return boolean
function Check.is_root()
    return (vim.uv or vim.loop).getuid() == 0
end

_G.is_root = Check.is_root()

---@type User.Check
local M = setmetatable(Check, {
    __index = Check,

    __newindex = function(_, _, _)
        error('User.Check is read-only!', ERROR)
    end,
})
return M
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
