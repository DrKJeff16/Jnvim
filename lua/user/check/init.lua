---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:need-check-nil
---@diagnostic disable:missing-fields

require('user.types.user.check')

--- Checking Utilities
---@type User.Check
local M = {
    --- Value checking utilities.
    --- Pretty much reserved for data checking, type checking and conditional operations
    ---@see User.Check.Value
    ---@type User.Check.Value
    value = require('user.check.value'),

    --- Exitstance checks.
    --- This contains many environment, module, namespace, etc. checkers.
    --- Also, simplified Vim functions can be found here
    ---@see User.Check.Existance
    ---@type User.Check.Existance
    exists = require('user.check.exists'),

    --- Check whether Nvim is running in a Linux Console rather than a `pty`.
    ---
    --- ## Description
    --- This function can be useful for (un)loading certain elements that conflict with the Linux console, for example.
    ---
    --- ## Return
    --- A boolean that confirms whether the environment is a Linux Console.
    --- ---
    ---@return boolean
    in_console = function()
        local env = vim.fn.environ()

        --- TODO: This is not a good enough check. Must find a better solution.
        return vim.tbl_contains({ 'linux' }, env['TERM']) and not require('user.check.value').fields('DISPLAY', env)
    end,
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
