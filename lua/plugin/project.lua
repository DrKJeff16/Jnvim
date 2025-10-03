---@module 'lazy'

---@type LazySpec
return {
    'DrKJeff16/project.nvim',
    event = 'VeryLazy',
    dev = true,
    version = false,
    cmd = {
        'Project',
        'ProjectAdd',
        'ProjectConfig',
        'ProjectDelete',
        'ProjectHistory',
        'ProjectRecents',
        'ProjectRoot',
        'ProjectSession',
    },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    ---@type Project.Config.Options
    opts = {
        -- manual_mode = true,
        log = {
            enabled = true,
            logpath = vim.fn.stdpath('state'),
        },
        patterns = {
            '!^/usr',
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
        telescope = {
            enabled = false,
            sort = 'newest',
            prefer_file_browser = true,
        },
        show_hidden = true,
        fzf_lua = { enabled = true },
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
        integrations = {
            persistence = {
                enabled = true,
                auto_open = true,
                auto_save = true,
            },
        },
        scope_chdir = 'tab',
    },
    config = function(_, opts) ---@param opts Project.Config.Options
        local Keymaps = require('user_api.config.keymaps')
        local desc = require('user_api.maps').desc
        require('project').setup(opts)
        Keymaps({
            n = {
                ['<leader>p'] = { group = '+Project' },

                ['<leader>pp'] = {
                    vim.cmd.Project,
                    desc('Open Project UI'),
                },
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
                ['<leader>pf'] = {
                    require('project').run_fzf_lua,
                    desc('Run Fzf-Lua'),
                },
                ['<leader>pl'] = {
                    vim.cmd.ProjectLog,
                    desc('Open Project Log Window'),
                },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
