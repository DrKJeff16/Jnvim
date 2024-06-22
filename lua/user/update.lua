---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

require('user.types.user.update')

local notify = require('user.util.notify').notify

---@type User.Update
---@diagnostic disable-next-line:missing-fields
local M = {
    update = function(...)
        local args = { ... }

        local old_cwd = vim.fn.getcwd()

        local cmd = {
            'git',
            'pull',
            '--rebase',
            '--recurse-submodules',
        }

        vim.system(cmd, { cwd = vim.fn.stdpath('config') })
    end,
}

function M.new()
    local self = setmetatable({}, { __index = M, __call = M.update })

    self.update = M.update

    return self
end

return M.new()
