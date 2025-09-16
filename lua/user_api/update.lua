local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO

---@class User.Update
local Update = {}

---@param verbose? boolean
---@return string?
function Update.update(verbose)
    local notify = require('user_api.util.notify').notify
    local is_bool = require('user_api.check.value').is_bool

    local curr_win = vim.api.nvim_get_current_win
    local curr_tab = vim.api.nvim_get_current_tabpage
    local cd = vim.api.nvim_set_current_dir

    verbose = is_bool(verbose) and verbose or false

    local og_cwd = vim.fn.getcwd(curr_win(), curr_tab())

    local cmd = {
        'git',
        'pull',
        '--rebase',
        '--recurse-submodules',
    }

    cd(vim.fn.stdpath('config'))

    local res = vim.fn.system(cmd)

    cd(og_cwd)

    local lvl = res:match('error') and WARN or INFO

    if verbose then
        notify(res, lvl, {
            animate = true,
            hide_from_history = false,
            timeout = 2250,
            title = 'User API - Update',
        })
    end

    if vim.v.shell_error ~= 0 then
        error('Failed to update Jnvim, try to do it manually', WARN)
    end

    if res:match('Already up to date') then
        notify('Jnvim is up to date!', INFO, {
            animate = true,
            hide_from_history = true,
            timeout = 1750,
            title = 'User API - Update',
        })
    elseif not res:match('error') then
        notify('You need to restart Nvim!', WARN, {
            animate = true,
            hide_from_history = false,
            timeout = 5000,
            title = 'User API - Update',
        })
    end

    return res
end

function Update.setup_maps()
    local Keymaps = require('user_api.config.keymaps')
    local desc = require('user_api.maps').desc

    Keymaps({
        n = {
            ['<leader>U'] = { group = '+User API' },

            ['<leader>Uu'] = {
                Update.update,
                desc('Update User Config'),
            },
            ['<leader>UU'] = {
                function()
                    Update.update(true)
                end,
                desc('Update User Config (Verbose)'),
            },
        },
    })
end

return Update

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
