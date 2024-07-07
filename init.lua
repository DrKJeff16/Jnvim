---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user') --- User API
local Types = User.types ---@see User.types Import docstrings and annotations
local Check = User.check ---@see User.check Checking utilities
local Util = User.util ---@see User.util General utilities
local WK = User.maps.wk ---@see User.Maps.wk `which-key` backend

local is_nil = Check.value.is_nil ---@see User.Check.Value.is_nil
local is_tbl = Check.value.is_tbl ---@see User.Check.Value.is_tbl
local is_str = Check.value.is_str ---@see User.Check.Value.is_str
local is_fun = Check.value.is_fun ---@see User.Check.Value.is_fun
local empty = Check.value.empty ---@see User.Check.Value.empty
local vim_has = Check.exists.vim_has ---@see User.Check.Existance.vim_has
local nop = User.maps.nop ---@see User.Maps.nop
local desc = User.maps.kmap.desc ---@see User.Maps.Keymap.desc
local map_dict = User.maps.map_dict ---@see User.Maps.map_dict
local displace_letter = Util.displace_letter ---@see User.Util.displace_letter

_G.is_windows = vim_has('win32')
vim.g.markdown_minlines = 500

--- WARNING: USE LONG NAMES. I'll try to fix it later
---
--- Vim `:set ...` global options setter
---@see User.Opts.setup
User.opts.setup({ ---@see User.Opts.Spec For more info
    background = 'dark',
    cmdwinheight = 3,
    confirm = true,
    equalalways = true,
    expandtab = true,
    formatoptions = 'bjlopqnw',
    helplang = { 'en' },
    hlsearch = true,
    ignorecase = false,
    incsearch = true,
    matchtime = 30,
    menuitems = 40,
    number = true,
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

vim.g.markdown_minlines = 500

--- Set `<Space>` as Leader Key.
nop('<Space>', { noremap = true, silent = true, nowait = false })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--- Disable `netrw` regardless of whether `nvim_tree` exists or not
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--- Uncomment to use system clipboard
--- vim.o.clipboard = 'unnamedplus'

if is_nil(use_statusline) or not vim.tbl_contains({ 'lualine', 'galaxyline' }, use_statusline) then
    ---@type 'lualine'|'galaxyline'
    _G.use_statusline = 'lualine'
end

--- List of manually-callable plugin.
_G.Pkg = require('config.lazy')

--- Setup keymaps
require('config.keymaps').setup()

if is_tbl(Pkg.colorschemes) and not empty(Pkg.colorschemes) then
    --- A table containing various possible colorschemes.
    local C = Pkg.colorschemes

    local Csc = C.new()

    ---@type KeyMapDict
    local CscKeys = {}

    --- Reorder to your liking.
    local selected = {
        'tokyonight',
        'kanagawa',
        'nightfox',
        'catppuccin',
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
        ['<leader>vc'] = { name = '+Colorschemes' },
    }

    local csc_group = 'a'
    local i = 1
    local found_csc = ''
    for idx, name in next, selected do
        ---@type CscSubMod|ODSubMod|table
        local TColor = Csc[name]

        if not is_nil(TColor.setup) then
            found_csc = found_csc ~= '' and found_csc or name

            NamesCsc['<leader>vc' .. csc_group] = {
                name = '+Group ' .. csc_group,
            }

            if is_tbl(TColor.variants) and not empty(TColor.variants) then
                local v = 'a'
                for _, variant in next, TColor.variants do
                    NamesCsc['<leader>vc' .. csc_group .. tostring(i)] = {
                        name = '+' .. name,
                    }
                    CscKeys['<leader>vc' .. csc_group .. tostring(i) .. v] = {
                        function()
                            TColor.setup(variant)
                        end,
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
require('user.distro.archlinux').setup()

User.commands:setup_commands()

vim.cmd([[
filetype plugin indent on
syntax on
]])

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
