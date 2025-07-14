local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('persisted') then
    return
end

local ERROR = vim.log.levels.ERROR

local Pstd = require('persisted')

Pstd.setup({
    save_dir = vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/'), -- directory where session files are saved
    silent = true, -- silent nvim message when sourcing session file
    use_git_branch = true, -- create session files based on the branch of a git enabled repository
    default_branch = 'main', -- the branch to load if a session file is not found for the current branch
    autosave = true, -- automatically save session files when exiting Neovim
    should_autosave = function()
        local excluded = {
            'lazy',
            'NvimTree',
            'alpha',
            'help',
            'qf',
            'TelescopePrompt',
            'sudoers',
            'toggleterm',
        }

        if vim.tbl_contains(excluded, vim.bo.filetype) then
            return false
        end

        return true
    end, -- function to determine if a session should be autosaved

    autoload = false, -- automatically load the session for the cwd on Neovim startup

    on_autoload_no_session = function()
        vim.notify('(persisted): No session found', ERROR)
    end, -- function to run when `autoload = true` but there is no session to load

    follow_cwd = true, -- change session file name to match current working directory if it changes
    allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
    ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
    ignored_branches = nil, -- table of branch patterns that are ignored for auto-saving and auto-loading
    telescope = {
        reset_prompt = true, -- Reset the Telescope prompt after an action?
        mappings = { -- table of mappings for the Telescope extension
            change_branch = '<C-b>',
            copy_session = '<C-c>',
            delete_session = '<C-d>',
        },
        icons = { -- icons displayed in the picker, set to nil to disable entirely
            branch = ' ',
            dir = ' ',
            selected = ' ',
        },
    },
})

User:register_plugin('plugin.persisted')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
