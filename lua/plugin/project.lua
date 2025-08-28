local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local desc = User.maps.desc

if not exists('project') then
    User.deregister_plugin('plugin.project')
    return
end

local Project = require('project')

Project.setup({
    logging = false,

    manual_mode = false,

    detection_methods = { 'lsp', 'pattern' },

    patterns = {
        '!=' .. vim.fn.environ()['HOME'],
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

    allow_different_owners = false,

    telescope = {
        enabled = false,
        sort = 'newest',
        prefer_file_browser = true,
        show_hidden = false,
    },

    ignore_lsp = {},

    exclude_dirs = {
        '/usr/*',
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

    silent_chdir = true,
    enable_autochdir = false,

    scope_chdir = 'tab',

    datapath = vim.fn.stdpath('data'),
})

---@type AllMaps
local Keys = {
    ['<leader>p'] = { group = '+Project' },

    ['<leader>ph'] = {
        function()
            vim.cmd.checkhealth('project')
        end,
        desc('Attempt to run `:checkhealth project`'),
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
