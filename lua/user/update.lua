---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

require('user.types.user.update')
local Util = require('user.util')
local Notify = require('user.util.notify')

local notify = Notify.notify

---@type User.Update
---@diagnostic disable-next-line:missing-fields
local M = {}

function M.update(...)
    local args = { ... }

    local old_cwd = vim.fn.getcwd()

    vim.cmd('cd ' .. vim.fn.stdpath('config'))

    local cmd = {
        'git',
        'pull',
        '--rebase',
        '--recurse-submodules',
    }

    vim.fn.system(cmd)

    vim.cmd('cd ' .. old_cwd)
end

function M.new()
    local self = setmetatable({}, { __index = M, __call = M.update })

    self.update = M.update
    self.new = M.new

    return self
end

return M.new()
