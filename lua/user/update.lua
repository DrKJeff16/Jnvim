---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

require('user.types.user.update')

local notify = require('user.util.notify').notify

---@type User.Update
local M = {
    ---@return string
    update = function()
        local old_cwd = vim.fn.getcwd(0, 0)

        local cmd = {
            'git',
            'pull',
            '--rebase',
            '--recurse-submodules',
        }

        vim.api.nvim_set_current_dir(vim.fn.stdpath('config'))
        local res = vim.fn.system(cmd)

        vim.api.nvim_set_current_dir(old_cwd)

        return res
    end,
}

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
