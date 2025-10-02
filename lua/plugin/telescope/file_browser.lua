local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local executable = Check.exists.executable

if not exists('telescope._extensions.file_browser') then
    return nil
end

local Actions = require('telescope._extensions.file_browser.actions')
local Finders = require('telescope._extensions.file_browser.finders')

local FileBrowser = {}

FileBrowser.file_browser = {
    cwd_to_path = true,
    grouped = true,
    files = true,
    add_dirs = true,
    depth = 1,
    auto_depth = true,
    select_buffer = false,
    hidden = { file_browser = false, folder_browser = false },
    respect_gitignore = executable('fd'),
    use_fd = executable('fd'),
    display_stat = { date = true, size = true, mode = true },
    git_status = true,
    quiet = false,
    browse_files = Finders.browse_files,
    browse_folders = Finders.browse_folders,
    follow_symlinks = false,
    hide_parent_dir = false,
    collapse_dirs = false,
    prompt_path = false,
    dir_icon = '',
    dir_icon_hl = 'Default',
    no_ignore = false,
    theme = 'ivy',
    hijack_netrw = false,
    mappings = {
        ['i'] = {
            ['<A-c>'] = Actions.create,
            ['<A-d>'] = Actions.remove,
            ['<A-m>'] = Actions.move,
            ['<A-r>'] = Actions.rename,
            ['<A-t>'] = Actions.change_cwd,
            ['<A-y>'] = Actions.copy,
            ['<BS>'] = Actions.backspace,
            ['<C-e>'] = Actions.goto_home_dir,
            ['<C-f>'] = Actions.toggle_browser,
            ['<C-g>'] = Actions.goto_parent_dir,
            ['<C-h>'] = Actions.toggle_hidden,
            ['<C-o>'] = Actions.open,
            ['<C-s>'] = Actions.toggle_all,
            ['<C-w>'] = Actions.goto_cwd,
            ['<S-CR>'] = Actions.create_from_prompt,
        },
        ['n'] = {
            c = Actions.create,
            d = Actions.remove,
            e = Actions.goto_home_dir,
            f = Actions.toggle_browser,
            g = Actions.goto_parent_dir,
            h = Actions.toggle_hidden,
            m = Actions.move,
            o = Actions.open,
            r = Actions.rename,
            s = Actions.toggle_all,
            t = Actions.change_cwd,
            w = Actions.goto_cwd,
            y = Actions.copy,
        },
    },
}

function FileBrowser.loadkeys()
    local desc = require('user_api.maps').desc
    require('user_api.config').keymaps({
        n = {
            ['<leader>fTeb'] = {
                require('telescope').extensions.file_browser.file_browser,
                desc('File Browser'),
            },
            ['<leader>ff'] = {
                require('telescope').extensions.file_browser.file_browser,
                desc('Telescope File Browser'),
            },
        },
    })
end

return FileBrowser
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
