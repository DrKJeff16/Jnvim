local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local executable = Check.exists.executable
local desc = User.maps.kmap.desc

if not exists('zen-mode') then
    return
end

local ZM = require('zen-mode')

ZM.setup({
    window = {
        backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal

        -- height and width can be:
        -- * an absolute number of cells when > 1
        -- * a percentage of the width / height of the editor when <= 1
        -- * a function that returns the width or the height
        width = 0.9, -- width of the Zen window
        height = 0.95, -- height of the Zen window

        -- by default, no options are changed for the Zen window
        -- uncomment any of the options below, or add other vim.wo options you want to apply
        options = {
            signcolumn = 'no', -- disable signcolumn
            number = false, -- disable number column
            cursorline = true, -- disable cursorline
            cursorcolumn = false, -- disable cursor column
            foldcolumn = '0', -- disable fold column
            foldmethod = 'manual',
            list = false, -- disable whitespace characters
            wrap = true,
        },
    },

    plugins = {
        -- disable some global vim options (vim.o...)
        -- comment the lines to not apply the options
        options = {
            enabled = true,
            ruler = false, -- disables the ruler text in the cmd line area
            showcmd = false, -- disables the command in the last line of the screen

            -- you may turn on/off statusline in zen mode by setting 'laststatus'
            -- statusline will be shown only if 'laststatus' == 3
            laststatus = 0, -- turn off the statusline in zen mode
            showtabline = 0, -- turn off the statusline in zen mode
        },
        twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = false },
        tmux = { enabled = false }, -- disables the tmux statusline
        todo = { enabled = true }, -- disables todo comments
        -- this will change the font size on kitty when in zen mode
        -- to make this work, you need to set the following kitty options:
        -- - allow_remote_control socket-only
        -- - listen_on unix:/tmp/kitty
        kitty = {
            enabled = executable('kitty'),
            font = '+2', -- font size increment
        },
        -- this will change the font size on alacritty when in zen mode
        -- requires  Alacritty Version 0.10.0 or higher
        -- uses `alacritty msg` subcommand to change font size
        alacritty = {
            enabled = executable('alacritty'),
        },
        -- this will change the font size on wezterm when in zen mode
        -- See alse also the Plugins/Wezterm section in this projects README
        wezterm = {
            enabled = executable('wezterm'),
            -- can be either an absolute font size or the number of incremental steps
            font = '+4', -- (10% increase per step)
        },
    },
    -- callback where you can add custom code when the Zen window opens
    -- on_open = function(win) end,

    -- callback where you can add custom code when the Zen window closes
    -- on_close = function() end,
})

Keymaps({
    n = {
        ['<leader>Z'] = { group = '+Zen Mode' },

        ['<leader>Zo'] = { ZM.open, desc('Open Zen Mode') },
        ['<leader>Zd'] = { ZM.close, desc('Close Zen Mode') },
        ['<leader>Zt'] = { ZM.toggle, desc('Toggle Zen Mode') },
    },
})

User.register_plugin('plugin.zen_mode')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
