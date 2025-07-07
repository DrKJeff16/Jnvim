---@diagnostic disable:missing-fields

---@module 'user_api.types.colorschemes'
---@module 'user_api.types.lsp'

_G.MYVIMRC = vim.fn.stdpath('config') .. '/init.lua'
_G.newline = string.char(10)
_G.inspect = vim.inspect

local Keymaps = require('config.keymaps') ---@see Config.Keymaps
local User = require('user_api') ---@see UserAPI User API

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

local curr_buf = vim.api.nvim_get_current_buf

function _G.foldr(f, ...)
    if select('#', ...) < 2 then
        return ...
    end
    local function helper(x, ...)
        if select('#', ...) == 0 then
            return x
        end
        return f(x, helper(...))
    end
    return helper(...)
end

-- Thanks to `https://stackoverflow.com/questions/7183998/in-lua-what-is-the-right-way-to-handle-varargs-which-contains-nil`
---@type fun(...)
function _G.print_inspect(...) vim.print(inspect(...)) end

-- Thanks to `https://stackoverflow.com/questions/7183998/in-lua-what-is-the-right-way-to-handle-varargs-which-contains-nil`
---@type fun(...)
function _G.notify_inspect(...)
    require('user_api.util.notify').notify(inspect(...), 'info', {
        title = 'Message',
        hide_from_history = true,
        animate = true,
        timeout = 2500,
    })
end

---@see User.Opts.setup
Opts:setup({ ---@see User.Opts.Spec For more info
    autoread = true,
    backup = false,
    bg = 'dark', -- `background`
    bs = { 'indent', 'eol', 'start' }, -- `backspace`
    cmdwinheight = 15,
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
    hidden = true,
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
    relativenumber = false,
    ruler = true,
    scrolloff = 3,
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

-- Set `<Leader>` key
Keymaps:set_leader('<Space>')

vim.g.markdown_minlines = 500

--- Disable `netrw` regardless of whether `nvim_tree/neo_tree` exist or not
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--- Uncomment to use system clipboard
-- vim.o.clipboard = 'unnamedplus'

--- List of manually-callable plugin
local L = require('config.lazy')

--- Setup keymaps
Keymaps:setup({
    n = {
        ['<leader>fii'] = {
            function()
                local opt_get = vim.api.nvim_get_option_value
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
            function() vim.cmd.messages() end,
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
}, nil, true)

---@type table|CscMod|fun(color?: string, ...)
local Color = L.colorschemes()

Color('tokyonight', 'moon')

local Lsp = L.lsp()
Lsp()

-- Call the User API file associations and other autocmds
Util:assoc()

-- NOTE: See `:h g:markdown_minlines`
vim.g.markdown_minlines = 500

--- Call runtimepath optimizations for Arch Linux (WIP)
Distro:setup()

-- Define any custom commands
Commands:setup()

-- Mappings related specifically to `user_api`
User:setup_keys() -- NOTE: This MUST be called after `Commands:setup()` or it won't work

vim.schedule(function()
    local in_tbl = vim.tbl_contains
    local opt_set = vim.api.nvim_set_option_value
    local ft_get = Util.ft_get
    local bt_get = Util.bt_get

    vim.cmd.noh() -- HACK: Disable highlights when reloading

    local DISABLE_ON = {
        ft = {
            'help',
            'lazy',
            'notify',
            'qf',
            'TelescopePrompt',
            'TelescopeResults',
        },

        bt = {
            'help',
            'prompt',
            'quickfix',
            'terminal',
        },
    }

    local curr_ft = ft_get(curr_buf())
    local curr_bt = bt_get(curr_buf())

    -- HACK: In case we're on specific buffer (file|buf)types
    if not (in_tbl(DISABLE_ON.ft, curr_ft) and in_tbl(DISABLE_ON.bt, curr_bt)) then
        return
    end

    opt_set('number', false, { scope = 'local' })
    opt_set('signcolumn', 'no', { scope = 'local' })
end)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
