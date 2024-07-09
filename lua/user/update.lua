---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

require('user.types.user.update')

local wk_available = require('user.maps.wk').available
local notify = require('user.util.notify').notify
local desc = require('user.maps.kmap').desc
local map_dict = require('user.maps').map_dict

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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
