_G.MYVIMRC = vim.fn.stdpath('config') .. '/init.lua'
_G.inspect = inspect or vim.inspect
_G.newline = string.char(10)

local User = require('user_api') ---@see User User API
local Types = User.types ---@see User.types Import docstrings and annotations
local Check = User.check ---@see User.check Checking utilities
local Util = User.util ---@see User.util General utilities
local Opts = User.opts ---@see User.opts Option setting
local Commands = User.commands ---@see User.commands User command generation (WIP)
local WK = User.maps.wk ---@see User.Maps.wk `which-key` backend

local Keymaps = require('config.keymaps')

local is_nil = Check.value.is_nil ---@see User.Check.Value.is_nil
local is_tbl = Check.value.is_tbl ---@see User.Check.Value.is_tbl
local is_str = Check.value.is_str ---@see User.Check.Value.is_str
local empty = Check.value.empty ---@see User.Check.Value.empty
local desc = User.maps.kmap.desc ---@see User.Maps.Keymap.desc
local map_dict = User.maps.map_dict ---@see User.Maps.map_dict
local displace_letter = Util.displace_letter ---@see User.Util.displace_letter

local curr_win = vim.api.nvim_get_current_win

-- _G.is_windows = Check.exists.vim_has('win32')
_G.is_windows = not is_nil((vim.uv or vim.loop).os_uname().version:match('Windows'))

--- WARNING: USE LONG NAMES. I'll try to fix it later
---
--- Vim `:set ...` global options setter
---@see User.Opts.setup
Opts:setup({ ---@see User.Opts.Spec For more info
    background = 'dark',
    bs = { 'indent', 'eol', 'start' },
    cmdwinheight = 7,
    ci = false,
    confirm = true,
    equalalways = true,
    et = true,
    formatoptions = {
        b = true,
        j = true,
        l = true,
        o = true,
        p = true,
        q = true,
        n = true,
        w = true,
    },
    helplang = { 'en' },
    hls = true,
    ignorecase = false,
    incsearch = true,
    matchtime = 30,
    menuitems = 40,
    number = true,
    preserveindent = false,
    relativenumber = false,
    ruler = true,
    scrolloff = 3,
    sessionoptions = { 'buffers', 'tabpages', 'globals' },
    shiftwidth = 4,
    showmatch = true,
    showmode = false,
    showtabline = 2,
    signcolumn = 'yes',
    softtabstop = 4,
    spell = false,
    splitbelow = true,
    splitright = true,
    tabstop = 4,
    title = true,
    wrap = true,
})

Keymaps:set_leader('<Space>')

vim.g.markdown_minlines = 500

--- Disable `netrw` regardless of whether `nvim_tree` exists or not
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--- Uncomment to use system clipboard
--- vim.o.clipboard = 'unnamedplus'

if is_nil(use_statusline) or not vim.tbl_contains({ 'lualine', 'galaxyline' }, use_statusline) then
    ---@type 'lualine'|'galaxyline'
    _G.use_statusline = 'lualine'
end

--- List of manually-callable plugin
_G.Pkg = require('config.lazy')

--- Setup keymaps
Keymaps:setup({
    n = {
        ['<leader>fii'] = {
            function()
                if not vim.bo.modifiable then
                    return
                end

                local saved_pos = vim.api.nvim_win_get_cursor(curr_win())
                vim.api.nvim_feedkeys('gg=G', 'n', false)

                vim.schedule(function() vim.api.nvim_win_set_cursor(curr_win(), saved_pos) end)
            end,
            desc('Indent Whole File', true, 0),
        },
    },
})

if is_tbl(Pkg.colorschemes) and not empty(Pkg.colorschemes) then
    --- A table containing various possible colorschemes
    local C = Pkg.colorschemes

    local Csc = C.new()

    ---@type KeyMapDict
    local CscKeys = {}

    --- Reorder to your liking
    local selected = {
        'tokyonight',
        'kanagawa',
        'nightfox',
        'catppuccin',
        'vscode',
        'onedark',
        'gruvbox',
        'spacemacs',
        'molokai',
        'oak',
        'spaceduck',
        'dracula',
        'space_vim_dark',
    }

    ---@type RegKeysNamed
    local NamesCsc = {
        ['<leader>vc'] = { group = '+Colorschemes' },
    }

    local csc_group = 'A'
    local i = 1
    local found_csc = ''
    for idx, name in next, selected do
        ---@type CscSubMod|ODSubMod|table
        local TColor = Csc[name]

        if not is_nil(TColor.setup) then
            found_csc = found_csc ~= '' and found_csc or name

            NamesCsc['<leader>vc' .. csc_group] = {
                group = '+Group ' .. csc_group,
            }

            if is_tbl(TColor.variants) and not empty(TColor.variants) then
                local v = 'a'
                for _, variant in next, TColor.variants do
                    NamesCsc['<leader>vc' .. csc_group .. tostring(i)] = {
                        -- TODO: Make a `capitalize()` function for strings
                        group = '+' .. name,
                    }
                    CscKeys['<leader>vc' .. csc_group .. tostring(i) .. v] = {
                        function() TColor.setup(variant) end,
                        desc('Setup Colorscheme `' .. name .. '` (' .. variant .. ')'),
                    }

                    v = displace_letter(v, 'next', false)
                end
            else
                CscKeys['<leader>vc' .. csc_group .. tostring(i)] = {
                    TColor.setup,
                    desc('Setup Colorscheme `' .. name .. '`'),
                }
            end

            if i == 9 then
                i = 1
                csc_group = displace_letter(csc_group, 'next', false)
            elseif i < 9 then
                i = i + 1
            end
        end
    end

    if WK.available() then
        map_dict(NamesCsc, 'wk.register', false, 'n')
    end
    map_dict(CscKeys, 'wk.register', false, 'n')

    if not empty(found_csc) then
        Csc[found_csc].setup()
    end
end

--- Call the user file associations and other autocmds
Util.assoc()

vim.g.markdown_minlines = 500

--- Call runtimepath optimizations for arch linux
require('user_api.distro.archlinux').setup()

Commands:setup_commands()

User.update.setup_maps()

if WK.available() then
    map_dict({
        ['<leader>U'] = { group = '+User API' },
        ['<leader>UP'] = { group = '+Plugins' },
    }, 'wk.register', false, 'n')
end
map_dict({
    ['<leader>UPr'] = {
        function()
            local notify = require('user_api.util.notify').notify
            notify('Reloading...', 'info', {
                hide_from_history = true,
                title = 'User API',
                timeout = 400,
            })
            local res = User:reload_plugins()

            if not is_nil(res) then
                notify((inspect or vim.inspect)(res), 'error', {
                    hide_from_history = false,
                    timeout = 1000,
                    title = 'User API [ERROR]',
                    animate = true,
                })
            else
                notify('Success!', 'info', {
                    hide_from_history = true,
                    timeout = 200,
                    title = 'User API',
                })
            end
        end,
        desc('Reload All Plugins'),
    },
    ['<leader>UPl'] = {
        function() User:print_loaded_plugins() end,
        desc('Print Loaded Plugins'),
    },
}, 'wk.register', false, 'n')

vim.cmd([[
filetype plugin indent on
syntax on
]])

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
