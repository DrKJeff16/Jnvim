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
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end

    if res:match('Already up to date') then
        vim.api.nvim_echo({
            { res, 'WarningMsg' },
        }, true, { verbose = true })

        vim.fn.getchar()
    end

    vim.schedule(function() vim.api.nvim_set_current_dir(old_cwd) end)

    return res
end

function M.setup_maps()
    local wk_available = require('user_api.maps.wk').available
    local desc = require('user_api.maps.kmap').desc
    local map_dict = require('user_api.maps').map_dict

    if wk_available() then
        map_dict({ ['<leader>U'] = { group = '+User API' } }, 'wk.register', false, 'n')
    end
    map_dict({
        ['<leader>Uu'] = {
            M.update,
            desc('Update User Config'),
        },
    }, 'wk.register', false, 'n')
end

function M.setup_autocmd()
    local au_dict = require('user_api.util.autocmd').au_from_dict
    local augroup = vim.api.nvim_create_augroup

    ---@type AuDict
    local T = {
        ['VimEnter'] = {
            group = augroup('UserUpdateLoop', { clear = false }),
            callback = function()
                vim.fn.timer_start(900000, function()
                    local curr_win = vim.api.nvim_get_current_win
                    local curr_tab = vim.api.nvim_get_current_tabpage
                    local old_cwd = vim.fn.getcwd(curr_win(), curr_tab())

                    local cmd = { 'git', 'fetch' }

                    vim.api.nvim_set_current_dir(vim.fn.stdpath('config'))

                    local res = vim.fn.system(cmd)

                    if vim.v.shell_error ~= 0 then
                        vim.schedule(function() vim.api.nvim_set_current_dir(old_cwd) end)
                        return
                    end

                    vim.schedule(function() vim.api.nvim_set_current_dir(old_cwd) end)

                    if not res:match('Already up to date') then
                        vim.schedule(
                            function()
                                require('user_api.util.notify').notify(
                                    'New update(s) available!',
                                    'info',
                                    {
                                        hide_from_history = false,
                                        title = 'User API',
                                        timeout = 1000,
                                    }
                                )
                            end
                        )
                    end

                    return res
                end, {
                    ['repeat'] = -1,
                })
            end,
        },
    }

    au_dict(T)
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
