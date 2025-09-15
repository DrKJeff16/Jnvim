local ERROR = vim.log.levels.ERROR

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
    return (vim.list_contains({ 'linux' }, env['TERM']) and not fields('DISPLAY', env))
end

---Check whether Nvim is running as root (`PID == 0`).
--- ---
---@return boolean
function Check.is_root()
    return (vim.uv or vim.loop).getuid() == 0
end

_G.in_console = Check.in_console()
_G.is_root = Check.is_root()

return setmetatable(Check, {
    __index = Check,

    __newindex = function(_, _, _)
        error('User.Check is read-only!', ERROR)
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
