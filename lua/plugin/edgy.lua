local User = require('user_api')
local Check = User.check
local Opts = User.opts
local Commands = User.commands

local exists = Check.exists.module

if not exists('edgy') then
    User.deregister_plugin('plugin.edgy')
    return
end

Opts({
    ls = 3,
    splitkeep = 'screen',
})

local Edgy = require('edgy')

Edgy.setup({
    ---@type (Edgy.View.Opts|string)[]
    left = {
        {
            ft = 'NvimTree',
            size = { height = 0.5 },
        },
    },

    ---@type (Edgy.View.Opts|string)[]
    bottom = {
        {
            ft = 'toggleterm',
            size = { height = 0.4 },
            filter = function(buf, win)
                ---@cast win integer
                return vim.api.nvim_win_get_config(win).relative == ''
            end,
        },

        'trouble',

        {
            ft = 'help',
            size = { height = 20 },

            -- only show help buffers
            filter = function(buf)
                ---@cast buf integer
                return vim.bo[buf].buftype == 'help'
            end,
        },
    },

    ---@type (Edgy.View.Opts|string)[]
    right = {},

    ---@type (Edgy.View.Opts|string)[]
    top = {},

    ---@type table<Edgy.Pos, { size: (integer|fun(): integer), wo?: vim.wo }>
    options = {
        left = { size = 30 },
        bottom = { size = 10 },
        right = { size = 30 },
        top = { size = 10 },
    },

    -- edgebar animations
    animate = {
        enabled = true,
        fps = 144, -- frames per second
        cps = 120, -- cells per second

        on_begin = function()
            vim.g.minianimate_disable = true
        end,

        on_end = function()
            vim.g.minianimate_disable = false
        end,

        -- Spinner for pinned views that are loading.
        -- if you have noice.nvim installed, you can use any spinner from it, like:
        -- spinner = require("noice.util.spinners").spinners.circleFull,
        spinner = {
            frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
            interval = 80,
        },
    },

    -- enable this to exit Neovim when only edgy windows are left
    exit_when_last = false,

    -- close edgy when all windows are hidden instead of opening one of them
    -- disable to always keep at least one edgy split visible in each open section
    close_when_all_hidden = true,

    -- global window options for edgebar windows
    ---@type vim.wo
    wo = {
        -- Setting to `true`, will add an edgy winbar.
        -- Setting to `false`, won't set any winbar.
        -- Setting to a string, will set the winbar to that string.
        winbar = true,
        winfixwidth = true,
        winfixheight = false,
        winhighlight = 'WinBar:EdgyWinBar,Normal:EdgyNormal',
        spell = false,
        signcolumn = 'no',
    },

    -- buffer-local keymaps to be added to edgebar buffers.
    -- Existing buffer-local keymaps will never be overridden.
    -- Set to false to disable a builtin.
    ---@type table<string, false|fun(win: Edgy.Window)>
    keys = {
        -- close window
        ['q'] = function(win)
            win:close()
        end,
        -- hide window
        ['<C-q>'] = function(win)
            win:hide()
        end,
        -- close sidebar
        ['Q'] = function(win)
            win.view.edgebar:close()
        end,
        -- next open window
        [']w'] = function(win)
            win:next({ visible = true, focus = true })
        end,
        -- previous open window
        ['[w'] = function(win)
            win:prev({ visible = true, focus = true })
        end,
        -- next loaded window
        [']W'] = function(win)
            win:next({ pinned = false, focus = true })
        end,
        -- prev loaded window
        ['[W'] = function(win)
            win:prev({ pinned = false, focus = true })
        end,
        -- increase width
        ['<C-w>>'] = function(win)
            win:resize('width', 2)
        end,
        -- decrease width
        ['<C-w><lt>'] = function(win)
            win:resize('width', -2)
        end,
        -- increase height
        ['<C-w>+'] = function(win)
            win:resize('height', 2)
        end,
        -- decrease height
        ['<C-w>-'] = function(win)
            win:resize('height', -2)
        end,
        -- reset all custom sizing
        ['<C-w>='] = function(win)
            win.view.edgebar:equalize()
        end,
    },

    icons = {
        closed = ' ',
        open = ' ',
    },

    -- enable this on Neovim <= 0.10.0 to properly fold edgebar windows.
    -- Not needed on a nightly build >= June 5, 2023.
    fix_win_height = vim.fn.has('nvim-0.10') == 0,
})

Commands.setup({
    EdgyOpen = { Edgy.open, {} },
    EdgyClose = { Edgy.close, {} },
    EdgyToggle = { Edgy.toggle, {} },
})

User.register_plugin('plugin.edgy')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
