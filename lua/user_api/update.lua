require('user_api.types.user.update')

---@type User.Update
---@diagnostic disable-next-line:missing-fields
local M = {}

---@return string?
function M.update()
    local curr_win = vim.api.nvim_get_current_win
    local curr_tab = vim.api.nvim_get_current_tabpage
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
        vim.api.nvim_echo({
            { 'Failed to update Jnvim:\n', 'ErrorMsg' },
            { '\nPress any key to exit...', 'WarningMsg' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end

    if not res:match('Already up to date') then
        vim.api.nvim_echo({
            { res },
        }, false, {})

        require('user_api.util.notify').notify(
            'Need to restart Nvim. Press any key to exit',
            'warn',
            {
                title = 'User API',
                animate = false,
                timeout = 35000,
            }
        )
        vim.fn.getchar()
        os.exit(0)
    end

    vim.schedule(function() vim.api.nvim_set_current_dir(old_cwd) end)

    return res
end

function M:setup_maps()
    local wk_available = require('user_api.maps.wk').available
    local desc = require('user_api.maps.kmap').desc
    local map_dict = require('user_api.maps').map_dict

    if wk_available() then
        map_dict({ ['<leader>U'] = { group = '+User API' } }, 'wk.register', false, 'n')
    end
    map_dict({
        ['<leader>Uu'] = {
            self.update,
            desc('Update User Config'),
        },
    }, 'wk.register', false, 'n')
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
