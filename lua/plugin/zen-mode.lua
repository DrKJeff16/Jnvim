---@module 'lazy'

local executable = require('user_api.check.exists').executable

---@type LazySpec
return {
    'folke/zen-mode.nvim',
    version = false,
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
        local ZM = require('zen-mode')
        local desc = require('user_api.maps').desc
        ZM.setup(opts)
        require('user_api.config').keymaps({
            n = {
                ['<leader>Z'] = { group = '+Zen Mode' },
                ['<leader>Zo'] = { ZM.open, desc('Open Zen Mode') },
                ['<leader>Zd'] = { ZM.close, desc('Close Zen Mode') },
                ['<leader>Zt'] = { ZM.toggle, desc('Toggle Zen Mode') },
            },
        })
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
