local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check
local Util = User.util
local Commands = User.commands

local exists = Check.exists.module
local type_not_empty = Check.value.type_not_empty
local is_str = Check.value.is_str
local desc = User.maps.kmap.desc

local fmt = string.format

if not exists('project_nvim') then
    return
end

local Project = require('project_nvim')

Project.setup({
    ---If `true` your root directory won't be changed automatically,
    ---so you have the option to manually do so using `:ProjectRoot` command.
    --- ---
    ---Default: `false`
    --- ---
    ---@type boolean
    manual_mode = false,

    ---Methods of detecting the root directory. `'lsp'` uses the native neovim
    ---LSP, while `'pattern'` uses vim-rooter like glob pattern matching. Here
    ---order matters: if one is not detected, the other is used as fallback. You
    ---can also delete or rearrange the detection methods.
    ---
    ---The detection methods get filtered and rid of duplicates during runtime.
    --- ---
    ---Default: `{ 'lsp' , 'pattern' }`
    --- ---
    ---@type ("lsp"|"pattern")[]
    detection_methods = { 'lsp', 'pattern' },

    ---All the patterns used to detect root dir, when **'pattern'** is in
    ---detection_methods.
    ---
    ---See `:h project.nvim-pattern-matching`
    --- ---
    ---Default: `{ '.git', '.github', '_darcs', '.hg', '.bzr', '.svn', 'Pipfile' }`
    --- ---
    ---@type string[]
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

    ---Determines whether a project will be added if its project root is owned by a different user.
    ---
    ---If `false`, it won't add a project if its root is not owned by the
    ---current nvim `UID` **(UNIX only)**.
    --- ---
    ---Default: `true`
    --- ---
    ---@type boolean
    allow_different_owners = false,

    ---Table of options used for the telescope picker.
    --- ---
    ---@class Project.Config.Options.Telescope
    telescope = {
        ---Determines whether the `telescope` picker should be called.
        ---
        ---If telescope is not installed, this doesn't make a difference.
        ---
        ---Note that even if set to `false`, you can still load the extension manually.
        --- ---
        ---Default: `true`
        --- ---
        ---@type boolean
        enabled = false,

        ---Determines whether the newest projects come first in the
        ---telescope picker (`'newest'`), or the oldest (`'oldest'`).
        --- ---
        ---Default: `'newest'`
        --- ---
        ---@type 'oldest'|'newest'
        sort = 'newest',
    },

    ---Table of lsp clients to ignore by name,
    ---e.g. `{ 'efm', ... }`.
    ---
    ---If you have `nvim-lspconfig` installed **see** `:h lspconfig-all`
    ---for a list of servers.
    --- ---
    ---Default: `{}`
    --- ---
    ---@type string[]|table
    ignore_lsp = {},

    ---Don't calculate root dir on specific directories,
    ---e.g. `{ '~/.cargo/*', ... }`.
    ---
    ---See the `Pattern Matching` section in the `README.md` for more info.
    --- ---
    ---Default: `{}`
    --- ---
    ---@type string[]|table
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

    ---Make hidden files visible when using the `telescope` picker.
    --- ---
    ---Default: `false`
    --- ---
    ---@type boolean
    show_hidden = false,

    ---If `false`, you'll get a _notification_ every time
    ---`project.nvim` changes directory.
    --- ---
    ---Default: `true`
    --- ---
    ---@type boolean
    silent_chdir = true,

    ---Determines the scope for changing the directory.
    ---
    ---Valid options are:
    --- - `'global'`
    --- - `'tab'`
    --- - `'win'`
    --- ---
    ---Default: `'global'`
    --- ---
    ---@type 'global'|'tab'|'win'
    scope_chdir = 'tab',

    ---Path where `project.nvim` will store the project history.
    ---
    ---For more info, run `:lua vim.print(require('project_nvim').get_history_paths())`
    --- ---
    ---Default: `vim.fn.stdpath('data')`
    --- ---
    ---@type string
    datapath = vim.fn.stdpath('data'),
})

---@type AllMaps
local Keys = {
    ['<leader>p'] = { group = '+Project' },

    ['<leader>ph'] = {
        function()
            vim.cmd.checkhealth('project_nvim')
        end,
        desc('Attempt to run `:checkhealth project_nvim`'),
    },
}

Keymaps({ n = Keys })

Commands.setup({
    ProjectRecent = {
        function()
            local curr, method = Project.current_project()

            vim.notify(fmt('Current: `%s`\nMethod: `%s`', curr, method))
        end,
        {},
        mappings = {
            n = {
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
            },
        },
    },

    ProjectConfig = {
        function()
            notify_inspect(Project.get_config())
        end,
        {},
        mappings = {
            n = {
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
            },
        },
    },
})

User.register_plugin('plugin.project')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
