require('user_api.types.user.update')

---@type User.Update
---@diagnostic disable-next-line:missing-fields
local M = {}

---@return string?
function M.update()
    local curr_win = vim.api.nvim_get_current_win
    local curr_tab = vim.api.nvim_get_current_tabpage
    local notify = require('user_api.util.notify').notify

    local old_cwd = vim.fn.getcwd(curr_win(), curr_tab())

    local cmd = {
        'git',
        'pull',
        '--rebase',
        '--recurse-submodules',
    }

    vim.api.nvim_set_current_dir(vim.fn.stdpath('config'))

    local res = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
        notify('Failed to update Jnvim, try to do it manually...', 'error', {
            animate = false,
            hide_from_history = false,
            timeout = 7500,
            title = 'User API',
        })
    end

    if res:match('Already up to date') then
        notify('Jnvim is up to date!', 'info', {
            animate = true,
            hide_from_history = true,
            timeout = 5000,
            title = 'User API',
        })
    elseif not res:match('error') then
        notify(res, 'debug', {
            animate = true,
            hide_from_history = false,
            timeout = 5000,
            title = 'User API',
        })
        notify('You need to restart Nvim!', 'warn', {
            animate = true,
            hide_from_history = true,
            timeout = 5000,
            title = 'User API',
        })
    end

    vim.schedule(function() vim.api.nvim_set_current_dir(old_cwd) end)

    return res
end

function M:setup_maps()
    local wk_avail = require('user_api.maps.wk').available
    local desc = require('user_api.maps.kmap').desc
    local map_dict = require('user_api.maps').map_dict

    if wk_avail() then
        map_dict({
            n = {
                ['<leader>U'] = { group = '+User API' },
            },
        }, 'wk.register', true)
    end
    map_dict({
        n = {
            ['<leader>Uu'] = {
                self.update,
                desc('Update User Config'),
            },
        },
    }, 'wk.register', true)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
