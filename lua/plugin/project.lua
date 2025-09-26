---@module 'lazy'

---@type LazySpec
return {
    'DrKJeff16/project.nvim',
    event = 'VeryLazy',
    dev = true,
    version = false,
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
        local User = require('user_api')
        local Check = User.check
        local Keymaps = require('user_api.config.keymaps')
        local exists = Check.exists.module
        local desc = User.maps.desc

        if not exists('project') then
            return
        end

        local Project = require('project')

        Project.setup({
            log = {
                enabled = true,
            },
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

            telescope = {
                enabled = false,
                sort = 'newest',
                prefer_file_browser = true,
                show_hidden = false,
            },

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
            ['<leader>pf'] = {
                Project.run_fzf_lua,
                desc('Run Fzf-Lua'),
            },
            ['<leader>pl'] = {
                vim.cmd.ProjectLog,
                desc('Open Project Log Window'),
            },
        }

        Keymaps({ n = Keys })
    end,
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
