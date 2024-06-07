---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local Util = User.util
local maps_t = User.types.user.maps
local kmap = User.maps.kmap
local WK = User.maps.wk
local UNotify = Util.notify

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local desc = kmap.desc

if not exists('project_nvim') then
    return
end

local Project = require('project_nvim')
local Config = require('project_nvim.config')

local recent_proj = Project.get_recent_projects

local Opts = {
    -- Manual mode doesn't automatically change your root directory, so you have
    -- the option to manually do so using `:ProjectRoot` command.
    manual_mode = false,

    -- Methods of detecting the root directory. **"lsp"** uses the native neovim
    -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
    -- order matters: if one is not detected, the other is used as fallback. You
    -- can also delete or rearangne the detection methods.
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
        'Makefile',
        'package.json',
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
    },

    -- Don't calculate root dir on specific directories
    -- Ex: { "~/.cargo/*", ... }
    exclude_dirs = {
        '~/Templates/^',
    },

    -- Show hidden files in telescope
    show_hidden = true,

    -- When set to false, you will get a message when project.nvim changes your
    -- directory.
    silent_chdir = false,

    -- What scope to change the directory, valid options are
    -- * global (default)
    -- * tab
    -- * win
    scope_chdir = 'tab',

    -- Path where project.nvim will store the project history for use in
    -- telescope
    datapath = vim.fn.stdpath('data'),
}

Project.setup(Opts)

---@type table<MapModes,KeyMapDict>
local Keys = {
    n = {
        ['<leader>pr'] = {
            function()
                local msg = ''

                for _, v in next, recent_proj() do
                    msg = msg .. '\n- ' .. v
                end
                UNotify.notify(msg, 'info', { title = 'Recent Projects' })
            end,
            desc('Print Recent Projects'),
        },
    },
    v = {
        ['<leader>pr'] = {
            function()
                local msg = ''

                for _, v in next, recent_proj() do
                    msg = msg .. '\n- ' .. v
                end
                UNotify.notify(msg, 'info', { title = 'Recent Projects' })
            end,
            desc('Print Recent Projects'),
        },
    },
}

---@type table<MapModes, RegKeysNamed>
local Names = {
    n = { ['<leader>p'] = { name = '+Project' } },
    v = { ['<leader>p'] = { name = '+Project' } },
}

for mode, t in next, Keys do
    if WK.available() then
        if is_tbl(Names[mode]) and not empty(Names[mode]) then
            WK.register(Names[mode], { mode = mode })
        end

        WK.register(WK.convert_dict(t), { mode = mode })
    else
        for lhs, v in next, t do
            v[2] = is_tbl(v[2]) and v[2] or {}
            kmap[mode](lhs, v[1], v[2] or {})
        end
    end
end
