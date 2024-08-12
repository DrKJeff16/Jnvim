---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check
local Maps = User.maps
local kmap = Maps.kmap
local WK = Maps.wk

local exists = Check.exists.module
local executable = Check.exists.executable
local desc = kmap.desc
local map_dict = Maps.map_dict

if not (exists('lazygit.utils') and executable({ 'git', 'lazygit' })) then
    return
end

local au = vim.api.nvim_create_autocmd

local LG_Utils = require('lazygit.utils')
local LG_Win = require('lazygit.window')

local Opts = {
    floating_window_winblend = 0,
    floating_window_scaling_factor = 1.0,
    floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    floating_window_use_plenary = 1,

    use_neovim_remote = 0,

    use_custom_config_file_path = 0,
}

for k, v in next, Opts do
    vim.g['lazygit_' .. k] = v
end

---@type table<MapModes, KeyMapDict>
local Keys = {
    n = {
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
    },
    v = {
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
    },
}

---@type table<MapModes, RegKeysNamed>
local Names = {
    n = {
        ['<leader>G'] = { group = '+Git' },
        ['<leader>Gl'] = { group = '+LazyGit' },
    },
    v = {
        ['<leader>G'] = { group = '+Git' },
        ['<leader>Gl'] = { group = '+LazyGit' },
    },
}

if WK.available() then
    map_dict(Names, 'wk.register', true, nil, 0)
end
map_dict(Keys, 'wk.register', true, nil, 0)

au('BufEnter', {
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
