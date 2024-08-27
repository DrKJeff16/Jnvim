local User = require('user_api')
local Check = User.check
local WK = User.maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not (executable({ 'git', 'lazygit' }) and exists('lazygit.utils')) then
    return
end

User:register_plugin('plugin.git.lazygit')

local au = vim.api.nvim_create_autocmd

local LG_Utils = require('lazygit.utils')
local LG_Win = require('lazygit.window')

local g_vars = {
    floating_window_winblend = 0,
    floating_window_scaling_factor = 1.0,
    floating_window_border_chars = {
        '╭',
        '─',
        '╮',
        '│',
        '╯',
        '─',
        '╰',
        '│',
    },
    floating_window_use_plenary = exists('plenary') and 1 or 0,

    use_neovim_remote = 0,

    use_custom_config_file_path = 0,
}

for k, v in next, g_vars do
    vim.g['lazygit_' .. k] = v
end

---@type KeyMapDict
local Keys = {
    ['<leader>GlC'] = {
        function() vim.cmd('LazyGitConfig') end,
        desc("LazyGit's Config"),
    },
    ['<leader>GlF'] = {
        function() vim.cmd('LazyGitFilter') end,
        desc('Open Project Commits In Float'),
    },
    ['<leader>Glc'] = {
        function() vim.cmd('LazyGitCurrentFile') end,
        desc('LazyGit On Current File'),
    },
    ['<leader>Glf'] = {
        function() vim.cmd('LazyGitFilterCurrentFile') end,
        desc("LazyGit's Config"),
    },
    ['<leader>Glg'] = {
        function() vim.cmd('LazyGit') end,
        desc('Run LazyGit'),
    },
}

---@type RegKeysNamed
local Names = {
    ['<leader>G'] = { group = '+Git' },
    ['<leader>Gl'] = { group = '+LazyGit' },
}

if WK.available() then
    map_dict(Names, 'wk.register', false, 'n', 0)
end
map_dict(Keys, 'wk.register', false, 'n', 0)

au({ 'BufEnter', 'WinEnter' }, {
    pattern = '*',
    callback = function() require('lazygit.utils').project_root_dir() end,
})
--[[ au('TermClose', {
    pattern = '*',
    function()
        if require('user_api.util').ft_get() ~= 'lazygit' and not vim.v.event['status'] then
            vim.fn.execute('bdelete! ' .. vim.fn.expand('<abuf>'), 'silent!')
        end
    end,
}) ]]

vim.cmd([[
" NOTE: added lazygit check to avoid lua error
" NOTE: added "silent!" to avoid error when FZF terminal window is closed
autocmd TermClose * if &filetype != 'lazygit' && !v:event.status | silent! exe 'bdelete! '..expand('<abuf>') | endif
]])

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
