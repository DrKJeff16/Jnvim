---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:need-check-nil
---@diagnostic disable:missing-fields

require('user.types.user.check')

--- Checking Utilities
---@type User.Check
local M = {
    value = require('user.check.value'),
    exists = require('user.check.exists'),

    --- Check whether Nvim is running in a Linux Console rather than a `pty`.
    --- ---
    --- ## Description
    --- This function can be useful for (un)loading certain elements that conflict with the Linux console, for example.
    --- ---
    --- ## Return
    --- A boolean that confirms whether the environment is a Linux Console.
    --- ---
    in_console = function()
        local env = vim.fn.environ()

        if not require('user.check.value').fields('DISPLAY', env) then
            return false
        end

        --- TODO: This is not a good enough check. Must find a better solution.
        return vim.tbl_contains({ 'linux' }, env['TERM'])
    end,
}

function M.new()
    local self = setmetatable({}, { __index = M })

    self.value = require('user.check.value')
    self.exists = require('user.check.exists')

    return self
end

return M
