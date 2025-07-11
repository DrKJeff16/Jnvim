local Keymaps = require('config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local executable = Check.exists.executable
local desc = User.maps.kmap.desc

if not (executable({ 'git', 'lazygit' }) and exists('lazygit.utils')) then
    return
end

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

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

---@type AllMaps
local Keys = {
    ['<leader>G'] = { group = '+Git' },
    ['<leader>Gl'] = { group = '+LazyGit' },

    ['<leader>GlC'] = {
        function()
            vim.cmd('LazyGitConfig')
        end,
        desc("LazyGit's Config"),
    },
    ['<leader>GlF'] = {
        function()
            vim.cmd('LazyGitFilter')
        end,
        desc('Open Project Commits In Float'),
    },
    ['<leader>Glc'] = {
        function()
            vim.cmd('LazyGitCurrentFile')
        end,
        desc('LazyGit On Current File'),
    },
    ['<leader>Glf'] = {
        function()
            vim.cmd('LazyGitFilterCurrentFile')
        end,
        desc("LazyGit's Config"),
    },
    ['<leader>Glg'] = {
        function()
            vim.cmd('LazyGit')
        end,
        desc('Run LazyGit'),
    },
}

Keymaps({ n = Keys })

local group = augroup('User.LazyGit', { clear = true })

au({ 'BufEnter', 'WinEnter' }, {
    pattern = '*',
    group = group,
    callback = function()
        require('lazygit.utils').project_root_dir()
    end,
})

au('TermClose', {
    pattern = '*',
    group = group,
    callback = function()
        local ft = require('user_api.util').ft_get()

        if ft ~= 'lazygit' and not vim.v.event['status'] then
            vim.fn.execute('bdelete! ' .. vim.fn.expand('<abuf>'), 'silent!')
        end
    end,
})

-- NOTE: Left this in case of emergency
---
-- vim.cmd([[
-- au TermClose * if &filetype != 'lazygit' && !v:event.status | silent! exe 'bdelete! '..expand('<abuf>') | endif
-- ]])

User:register_plugin('plugin.git.lazygit')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
