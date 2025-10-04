---@module 'lazy'

local executable = require('user_api.check.exists').executable

---@type LazySpec
return {
    'folke/zen-mode.nvim',
    lazy = true,
    version = false,
    cmd = 'ZenMode',
    keys = {
        {
            '<leader>Zo',
            function()
                require('zen-mode').open()
            end,
            desc = 'Open Zen Mode',
            mode = { 'n' },
        },
        {
            '<leader>Zd',
            function()
                require('zen-mode').close()
            end,
            desc = 'Close Zen Mode',
            mode = { 'n' },
        },
        {
            '<leader>Zt',
            function()
                require('zen-mode').toggle()
            end,
            desc = 'Toggle Zen Mode',
            mode = { 'n' },
        },
    },
    enabled = not require('user_api.check').in_console(),
    opts = {
        window = {
            backdrop = 1,
            width = 0.9,
            height = 0.95,
            options = {
                signcolumn = 'no',
                number = false,
                cursorline = true,
                cursorcolumn = false,
                foldcolumn = '0',
                foldmethod = 'manual',
                list = false,
                wrap = true,
            },
        },
        plugins = {
            options = {
                enabled = true,
                ruler = false,
                showcmd = false,
                laststatus = 0,
                showtabline = 0,
            },
            twilight = { enabled = true },
            gitsigns = { enabled = false },
            tmux = { enabled = false },
            todo = { enabled = true },
            ---To make this work, you need to set the following kitty options:
            --- - allow_remote_control socket-only
            --- - listen_on unix:/tmp/kitty
            kitty = { enabled = executable('kitty'), font = '+2' },
            alacritty = { enabled = executable('alacritty') },
            wezterm = { enabled = executable('wezterm'), font = '+4' },
        },
    },
    config = function(_, opts)
        require('zen-mode').setup(opts)
        require('user_api.config').keymaps({
            n = {
                ['<leader>Z'] = { group = '+Zen Mode' },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
