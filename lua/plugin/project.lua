---@diagnostic disable:missing-fields

local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local type_not_empty = Check.value.type_not_empty
local is_str = Check.value.is_str
local desc = User.maps.kmap.desc

if not exists('project_nvim') then
    return
end

local Project = require('project_nvim')

Project.setup({
    -- Manual mode doesn't automatically change your root directory, so you have
    -- the option to manually do so using `:ProjectRoot` command
    manual_mode = false,

    -- Methods of detecting the root directory. **"lsp"** uses the native neovim
    -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
    -- order matters: if one is not detected, the other is used as fallback. You
    -- can also delete or rearrange the detection methods
    detection_methods = { 'lsp', 'pattern' },

    -- All the patterns used to detect root dir, when **"pattern"** is in
    -- detection_methods
    patterns = {
        '.git',
        '.github',
        '_darcs',
        '.hg',
        '.bzr',
        '.svn',
        '.pre-commit-config.yaml',
        '.pre-commit-config.yml',
        'Pipfile',
    },

    -- Don't calculate root dir on specific directories
    -- Ex: { "~/.cargo/*", ... }
    exclude_dirs = {
        '~/.build/*',
        '~/.cargo/*',
        '~/.conda/*',
        '~/.local/*',
        '~/.luarocks/*',
        '~/Desktop/*',
        '~/Public/*',
        '~/Templates/*',
    },

    -- Show hidden files in telescope
    show_hidden = true,

    -- When set to false, you will get a message when project.nvim changes your
    -- directory
    silent_chdir = true,

    -- What scope to change the directory, valid options are
    -- * global (default)
    -- * tab
    -- * win
    scope_chdir = 'tab',

    allow_different_owners = true,

    telescope = {
        enabled = false,

        sort = 'newest',
    },

    -- Path where project.nvim will store the project history for use in
    -- telescope
    datapath = vim.fn.stdpath('data'),
})

---@type AllMaps
local Keys = {
    ['<leader>p'] = { group = '+Project' },

    ['<leader>pC'] = {
        function()
            local notify = require('user_api.util.notify').notify

            local cfg = require('project_nvim').get_config()
            local msg = ''

            if type_not_empty('table', cfg) then
                for k, v in next, cfg do
                    k = is_str(k) and k or tostring(k)
                    v = is_str(v) and v or inspect(v)

                    msg = string.format('%s %s = %s\n', msg, k, v)
                end
                notify(string.format('{\n%s\n}', msg), 'info', {
                    title = 'Project | Config',
                    animate = true,
                    timeout = 3000,
                    hide_from_history = false,
                })

                return
            end

            notify('{}', 'error', {
                title = 'Project | NO CONFIG',
                animate = true,
                timeout = 2000,
                hide_from_history = false,
            })
        end,
        desc('Print Project Config'),
    },
    ['<leader>pr'] = {
        function()
            local notify = require('user_api.util.notify').notify

            local recent_proj = require('project_nvim').get_recent_projects()

            recent_proj = Util.reverse_tbl(vim.deepcopy(recent_proj))

            local len = #recent_proj
            local msg = ''

            if type_not_empty('table', recent_proj) then
                for k, v in next, recent_proj do
                    msg = string.format('%s %s. "%s"', msg, tostring(k), v)

                    if k < len then
                        msg = string.format('%s\n', msg)
                    end
                end
                notify(msg, 'info', {
                    title = 'Project | Recent Projects',
                    animate = true,
                    timeout = 3000,
                    hide_from_history = false,
                })

                return
            end

            notify('{}', 'error', {
                title = 'Recent Projects | NO PROJECTS',
                animate = true,
                timeout = 2000,
                hide_from_history = false,
            })
        end,
        desc('Print Recent Projects'),
    },
    ['<leader>ph'] = {
        function()
            vim.cmd.checkhealth('project_nvim')
        end,
        desc('Attempt to run `:checkhealth project_nvim`'),
    },
}

Keymaps({ n = Keys })

User.register_plugin('plugin.project')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
