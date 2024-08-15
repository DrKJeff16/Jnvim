require('user_api.types.user.update')

local wk_available = require('user_api.maps.wk').available
local notify = require('user_api.util.notify').notify
local desc = require('user_api.maps.kmap').desc
local map_dict = require('user_api.maps').map_dict

---@type User.Update
---@diagnostic disable-next-line:missing-fields
local M = {
    ---@return string?
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
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { 'Failed to update Jnvim:\n', 'ErrorMsg' },
                { res, 'WarningMsg' },
                { '\nPress any key to exit...' },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end

        vim.schedule(function() vim.api.nvim_set_current_dir(old_cwd) end)

        return res
    end,
}
function M.setup_maps()
    if wk_available() then
        map_dict({ ['<leader>U'] = { group = '+User API' } }, 'wk.register', false, 'n')
    end
    map_dict(
        { ['<leader>Uu'] = { M.update, desc('Update User Config') } },
        'wk.register',
        false,
        'n'
    )
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
