local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local desc = User.maps.kmap.desc

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

        prefer_file_browser = true,
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
        '~/.cache/*',
        '~/.cargo/*',
        '~/.conda/*',
        '~/.local/*',
        '~/.luarocks/*',
        '~/.tmux/*',
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

    enable_autochdir = false,
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
    ['<leader>pC'] = {
        vim.cmd.ProjectConfig,
        desc('Print Project Config'),
    },
    ['<leader>pr'] = {
        vim.cmd.ProjectRecents,
        desc('Print Recent Projects'),
    },
}

Keymaps({ n = Keys })

User.register_plugin('plugin.project')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
