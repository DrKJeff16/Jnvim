---@diagnostic disable:missing-fields

_G.MYVIMRC = vim.fn.stdpath('config') .. '/init.lua'
_G.newline = string.char(10)
_G.inspect = vim.inspect

local User = require('user_api') ---@see UserAPI User API
local Keymaps = require('config.keymaps') ---@see Config.Keymaps

local Check = User.check ---@see User.Check Checking utilities
local Util = User.util ---@see User.Util General utilities
local Opts = User.opts ---@see User.Opts Option setting
local Commands = User.commands ---@see User.Commands User command generation (**WIP**)
local Distro = User.distro ---@see User.Distro Platform-specific optimizations (**WIP**)

local in_console = Check.in_console ---@see User.Check.in_console
local is_nil = Check.value.is_nil ---@see User.Check.Value.is_nil
local desc = User.maps.kmap.desc ---@see User.Maps.Keymap.desc

_G.is_windows = not is_nil((vim.uv or vim.loop).os_uname().version:match('Windows'))
_G.in_console = require('user_api.check').in_console

---@type fun(...)
---@diagnostic disable-next-line:unused-vararg
function _G.print_inspect(...)
    local msg = ''
    local insp = inspect or vim.inspect

    for _, v in next, arg do
        msg = msg .. string.format('%s\n', insp(v))
    end

    vim.print(msg)
end

---@type fun(...)
---@diagnostic disable-next-line:unused-vararg
function _G.notify_inspect(...)
    local msg = ''
    local insp = inspect or vim.inspect

    for _, v in next, arg do
        msg = msg .. string.format('%s\n', insp(v))
    end

    require('user_api.util.notify').notify(msg, 'info', {
        title = 'Message',
        hide_from_history = true,
        animate = true,
        timeout = 2500,
    })
end

---@see User.Opts.setup
Opts:setup({ ---@see User.Opts.Spec For more info
    backup = false,
    bg = 'dark', -- `background`
    bs = { 'indent', 'eol', 'start' }, -- `backspace`
    cmdwinheight = 10,
    ci = false, -- `copyindent`
    completeopt = { 'menu', 'menuone', 'noinsert', 'noselect', 'preview' },
    confirm = true,
    equalalways = true,
    et = true, -- `expandtab`
    fo = { -- `formatoptions`
        b = true,
        c = false,
        j = true,
        l = true,
        n = true,
        o = true,
        p = true,
        q = true,
        w = true,
    },
    hlg = {
        'en',
    }, -- `helplang`
    hls = true, -- `hlsearch`
    ignorecase = false,
    incsearch = true,
    matchtime = 30,
    menuitems = 50,
    mouse = { a = false },
    nu = true, -- `number`
    pi = false, -- `preserveindent`
    rnu = false, -- `relativenumber`
    ru = true, -- `ruler`
    so = 3, -- `scrolloff`
    sessionoptions = { 'buffers', 'tabpages', 'globals' },
    sw = 4, -- `shiftwidth`
    showmatch = true,
    showmode = false,
    spell = false,
    splitbelow = true,
    splitright = true,
    stal = 2, -- `showtabline`
    signcolumn = 'yes',
    sts = 4, -- `softtabstop`
    ts = 4, -- `tabstop`
    title = true,
    termguicolors = not in_console(),
    wrap = Distro.termux:validate(),
})

Keymaps:set_leader('<Space>')

vim.g.markdown_minlines = 500

--- Disable `netrw` regardless of whether `nvim_tree/neo_tree` exist or not
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--- Uncomment to use system clipboard
--- vim.o.clipboard = 'unnamedplus'

--- List of manually-callable plugin
require('config.lazy')

---@type CscMod
local Color = require('plugin.colorschemes')

Color('tokyonight', 'moon')

--- Setup keymaps
Keymaps:setup({
    n = {
        ['<leader>fii'] = {
            function()
                local opt_get = vim.api.nvim_get_option_value
                local curr_buf = vim.api.nvim_get_current_buf
                local cursor_set = vim.api.nvim_win_set_cursor
                local cursor_get = vim.api.nvim_win_get_cursor

                assert(
                    opt_get('modifiable', { buf = curr_buf() }),
                    'Unable to indent. File is unmodifiable!'
                )

                local win = vim.api.nvim_get_current_win()
                local saved_pos = cursor_get(win)

                vim.api.nvim_feedkeys('gg=G', 'n', false)

                -- HACK: Wait for `feedkeys` to end, then reset to position
                vim.schedule(function() cursor_set(win, saved_pos) end)
            end,
            desc('Indent Whole File'),
        },
        ['<leader>vM'] = {
            function() vim.cmd('messages') end,
            desc('Run `:messages`'),
        },
        ['<leader>vN'] = {
            function()
                ---@diagnostic disable-next-line
                pcall(vim.cmd, 'Notifications')
            end,
            desc('Run `:Notifications`'),
        },
    },
    v = {
        ['<leader>S'] = { ':sort!<CR>', desc('Sort Selection (Reverse)') },
        ['<leader>s'] = { ':sort<CR>', desc('Sort Selection') },
    },
})

-- Call the User API file associations and other autocmds
Util:assoc()

-- NOTE: See `:h g:markdown_minlines`
vim.g.markdown_minlines = 500

--- Call runtimepath optimizations for Arch Linux (WIP)
Distro:setup()

-- Define any custom commands
Commands:setup()

-- Mappings related specifically to `user_api`
User:setup_keys()
Commands:setup_keys() -- NOTE: This MUST be called after `Commands:setup()` or it won't work
Opts:setup_keys()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
