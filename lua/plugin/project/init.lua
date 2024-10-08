local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local desc = User.maps.kmap.desc
local wk_avail = User.maps.wk.available
local map_dict = User.maps.map_dict

if not exists('project_nvim') then
    return
end

User:register_plugin('plugin.project')

local Project = require('project_nvim')

local recent_proj = Project.get_recent_projects

Project.setup({
    -- Manual mode doesn't automatically change your root directory, so you have
    -- the option to manually do so using `:ProjectRoot` command
    manual_mode = false,

    -- Methods of detecting the root directory. **"lsp"** uses the native neovim
    -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
    -- order matters: if one is not detected, the other is used as fallback. You
    -- can also delete or rearangne the detection methods
    detection_methods = { 'lsp', 'pattern' },

    -- All the patterns used to detect root dir, when **"pattern"** is in
    -- detection_methods
    patterns = {
        '.git',
        '!.git/worktrees',
        '.github',
        '_darcs',
        '.hg',
        '.bzr',
        '.svn',
        'Makefile',
        'package.json',
        'package.lock',
        'pyproject.toml',
        '.neoconf.json',
        'neoconf.json',
        'Pipfile',
        'Pipfile.lock',
        'requirements.txt',
        'tox.ini',
        'stylua.toml',
        '.stylua.toml',
        '.pre-commit-config.yaml',
        '.pre-commit-config.yml',
        '.clangd',
    },

    -- Don't calculate root dir on specific directories
    -- Ex: { "~/.cargo/*", ... }
    exclude_dirs = {
        '~/Templates/*',
        '~/.local/*',
        '~/.cargo/*',
        '~/.luarocks/*',
        '~/.conda/*',
        '~/Public/*',
        '~/Desktop/*',
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

    -- Path where project.nvim will store the project history for use in
    -- telescope
    datapath = vim.fn.stdpath('state') .. '/projects/',
})

---@type KeyMapDict
local Keys = {
    ['<leader>pr'] = {
        function()
            local notify = require('user_api.util.notify').notify
            local msg = ''

            for _, v in next, recent_proj() do
                msg = msg .. '- ' .. v .. newline or string.char(10)
            end
            notify(msg, 'info', {
                title = 'Recent Projects',
                animate = false,
                timeout = 1750,
                hide_from_history = false,
            })
        end,
        desc('Print Recent Projects'),
    },
}

---@type RegKeysNamed
local Names = {
    ['<leader>p'] = { group = '+Project' },
}

if wk_avail() then
    map_dict(Names, 'wk.register', false, 'n', 0)
end
map_dict(Keys, 'wk.register', false, 'n', 0)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
