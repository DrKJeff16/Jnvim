---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user') --- User API
local Check = User.check ---@see User.Check Checking utilities
local Types = User.types ---@see User.types Import docstrings and annotations
local Maps = User.maps --- Mapping utilities
local Util = User.util --- General utilities
local Kmap = Maps.kmap --- `vim.keymap.set` backend
local WK = Maps.wk --- `which-key` backend
local maps_t = Types.user.maps ---@see UserSubTypes.maps

local is_nil = Check.value.is_nil ---@see User.Check.Value.is_nil
local is_tbl = Check.value.is_tbl ---@see User.Check.Value.is_tbl
local is_str = Check.value.is_str ---@see User.Check.Value.is_str
local is_fun = Check.value.is_fun ---@see User.Check.Value.is_fun
local empty = Check.value.empty ---@see User.Check.Value.empty
local vim_has = Check.exists.vim_has ---@see User.Check.Existance.vim_has
local nop = User.maps.nop ---@see User.Maps.nop
local desc = Kmap.desc ---@see User.Maps.Keymap.desc
local ft_get = Util.ft_get ---@see User.Util.ft_get
local notify = Util.notify.notify ---@see User.Util.Notify.notify
local map_dict = Maps.map_dict ---@see User.Maps.map_dict
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
    wrap = false,
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

--- Avoid executing these keys when attempting `<leader>` sequences.
local NOP = {
    "'",
    '!',
    '"',
    '.',
    '/',
    '?',
    'A',
    'B',
    'C',
    'D',
    'E',
    'G',
    'I',
    'J',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    'a',
    'b',
    'c',
    'd',
    'e',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
}
for _, mode in next, User.maps.modes do
    nop(NOP, {}, mode, '<leader>')
end

--- Global keymaps, plugin-agnostic
---@type table<MapModes, KeyMapDict>
local Keys = {
    n = {
        ['<Esc><Esc>'] = { vim.cmd.nohls, desc('Remove Highlighted Search') },

        ['<leader>bD'] = { '<CMD>bdel!<CR>', desc('Close Buffer Forcefully', true, nil, false) },
        ['<leader>bd'] = { '<CMD>bdel<CR>', desc('Close Buffer', true, nil, false) },
        ['<leader>bf'] = { '<CMD>bfirst<CR>', desc('Goto First Buffer', true, nil, false) },
        ['<leader>bl'] = { '<CMD>blast<CR>', desc('Goto Last Buffer', true, nil, false) },
        ['<leader>bn'] = { '<CMD>bNext<CR>', desc('Next Buffer', true, nil, false) },
        ['<leader>bp'] = { '<CMD>bprevious<CR>', desc('Previous Buffer', true, nil, false) },

        ['<leader>fFc'] = { ':%foldclose<CR>', desc('Close All Folds') },
        ['<leader>fFo'] = { ':%foldopen<CR>', desc('Open All Folds') },
        ['<leader>fN'] = {
            function()
                local ft = Util.ft_get(0)
                vim.cmd.wincmd('n')
                vim.cmd.wincmd('o')

                vim.bo.modifiable = true
                vim.api.nvim_set_option_value('ft', ft, { buf = 0 })
            end,
            desc('New Blank File', true, 0),
        },
        ['<leader>fS'] = { ':w ', desc('Save File (Prompt)', false, 0) },
        ['<leader>fir'] = { ':%retab<CR>', desc('Retab File', true, 0) },
        ['<leader>fr'] = { ':%s/', desc('Run Search-Replace Prompt For Whole File', false, 0) },
        ['<leader>fs'] = { ':w<CR>', desc('Save File', false, 0) },
        ['<leader>fvL'] = { ':luafile ', desc('Source Lua File (Prompt)', false, 0) },
        ['<leader>fvV'] = { ':so ', desc('Source VimScript File (Prompt)', false, 0) },
        ['<leader>fvl'] = {
            function()
                local ft = Util.ft_get()
                local err_msg = 'Filetype `' .. ft .. '` not sourceable by Lua'

                if ft == 'lua' then
                    vim.cmd('luafile %')
                    notify(
                        'Sourced current Lua file',
                        'info',
                        { title = 'Lua', timeout = 150, hide_from_history = true }
                    )
                else
                    notify(err_msg, 'error', { title = 'Lua', timeout = 250, hide_from_history = true })
                end
            end,
            desc('Source Current File As Lua File'),
        },
        ['<leader>fvv'] = {
            function()
                local ft = Util.ft_get()
                local err_msg = 'Filetype `' .. ft .. '` not sourceable by Vim'

                if ft == 'vim' then
                    vim.cmd('so %')
                    notify(
                        'Sourced current Vim file',
                        'info',
                        { title = 'Vim', timeout = 150, hide_from_history = true }
                    )
                else
                    notify(err_msg, 'error', { title = 'Vim', timeout = 250, hide_from_history = true })
                end
            end,
            desc('Source Current File As VimScript File'),
        },

        ['<leader>vH'] = { ':checkhealth ', desc('Prompt For Checkhealth', false) },
        ['<leader>vee'] = { '<CMD>ed $MYVIMRC<CR>', desc('Open In Current Window') },
        ['<leader>ves'] = { '<CMD>split $MYVIMRC<CR>', desc('Open In Horizontal Split') },
        ['<leader>vet'] = { '<CMD>tabnew $MYVIMRC<CR>', desc('Open In New Tab') },
        ['<leader>vev'] = { '<CMD>vsplit $MYVIMRC<CR>', desc('Open In Vertical Split') },
        ['<leader>vh'] = { '<CMD>checkhealth<CR>', desc('Run Checkhealth') },
        ['<leader>vs'] = {
            function()
                vim.cmd('luafile $MYVIMRC')
                notify('Sourced `init.lua`', 'info', { title = 'luafile', timeout = 250, hide_from_history = true })
            end,
            desc('Source $MYVIMRC'),
        },

        ['<leader>?S'] = { ':horizontal h<CR>', desc('Open Help On Horizontal Split') },
        ['<leader>?T'] = { ':tab h<CR>', desc('Open Help On New Tab') },
        ['<leader>?V'] = { ':vertical h<CR>', desc('Open Help On Vertical Split') },
        ['<leader>?h'] = { ':h ', desc('Prompt For Help', false) },
        ['<leader>?s'] = { ':horizontal h ', desc('Prompt For Help On Horizontal Split', false) },
        ['<leader>?t'] = { ':tab h ', desc('Prompt For Help On New Tab', false) },
        ['<leader>?v'] = { ':vertical h ', desc('Prompt For Help On Vertical Split', false) },

        ['<leader>wN'] = {
            function()
                local ft = Util.ft_get(0)
                vim.cmd.wincmd('n')
                vim.cmd.wincmd('o')

                vim.bo.modifiable = true
                vim.api.nvim_set_option_value('ft', ft, { buf = 0 })
            end,
            desc('New Blank File', true, 0),
        },
        ['<leader>w='] = {
            function()
                vim.cmd.wincmd('=')
            end,
            desc('Resize all windows equally', true, 0),
        },
        ['<leader>w<Left>'] = {
            function()
                vim.cmd.wincmd('h')
            end,
            desc('Go To Window On The Left', true, 0),
        },
        ['<leader>w<Right>'] = {
            function()
                vim.cmd.wincmd('l')
            end,
            desc('Go To Window On The Right', true, 0),
        },
        ['<leader>w<Up>'] = {
            function()
                vim.cmd.wincmd('k')
            end,
            desc('Go To Window Above', true, 0),
        },
        ['<leader>w<Down>'] = {
            function()
                vim.cmd.wincmd('j')
            end,
            desc('Go To Window Below', true, 0),
        },
        ['<leader>wd'] = {
            function()
                vim.cmd.wincmd('q')
            end,
            desc('Close Window', true, 0),
        },
        ['<leader>wn'] = {
            function()
                vim.cmd.wincmd('w')
            end,
            desc('Next Window', true, 0),
        },
        ['<leader>wp'] = {
            function()
                vim.cmd.wincmd('W')
            end,
            desc('Previous Window', true, 0),
        },
        ['<leader>wsS'] = { ':split ', desc('Horizontal Split (Prompt)', false) },
        ['<leader>wsV'] = { ':vsplit ', desc('Vertical Split (Prompt)', false) },
        ['<leader>wss'] = {
            function()
                vim.cmd.wincmd('s')
            end,
            desc('Horizontal Split', true, 0),
        },
        ['<leader>wsv'] = {
            function()
                vim.cmd.wincmd('v')
            end,
            desc('Vertical Split', true, 0),
        },

        ['<leader>qQ'] = { '<CMD>qa!<CR>', desc('Quit Nvim Forcefully') },
        ['<leader>qq'] = { '<CMD>qa<CR>', desc('Quit Nvim') },

        ['<leader>tA'] = { '<CMD>tabnew<CR>', desc('New Tab') },
        ['<leader>tD'] = { '<CMD>tabc!<CR>', desc('Close Tab Forcefully') },
        ['<leader>ta'] = { ':tabnew ', desc('New Tab (Prompt)', false) },
        ['<leader>td'] = { '<CMD>tabc<CR>', desc('Close Tab') },
        ['<leader>tf'] = { '<CMD>tabfirst<CR>', desc('Goto First Tab') },
        ['<leader>tl'] = { '<CMD>tablast<CR>', desc('Goto Last Tab') },
        ['<leader>tn'] = { '<CMD>tabN<CR>', desc('Next Tab') },
        ['<leader>tp'] = { '<CMD>tabp<CR>', desc('Previous Tab') },
    },
    v = {
        ['<leader>S'] = { ':sort!<CR>', desc('Sort Selection (Reverse)', false) },
        ['<leader>s'] = { ':sort<CR>', desc('Sort Selection', false) },

        ['<leader>fFc'] = { ':foldopen<CR>', desc('Open Fold', false) },
        ['<leader>fFo'] = { ':foldclose<CR>', desc('Close Fold', false) },

        ['<leader>ir'] = { ':retab<CR>', desc('Retab Selection', false) },

        ['<leader>fr'] = { ':s/', desc('Search/Replace Prompt For Selection', false) },
    },
}
--- `which-key` map group prefixes
---@type table<MapModes, RegKeysNamed>
local Names = {
    n = {
        ['<leader>b'] = { name = '+Buffer', noremap = false }, --- Buffer Handling
        ['<leader>f'] = { name = '+File' }, --- File Handling
        ['<leader>fF'] = { name = '+Folding' }, --- Folding Control
        ['<leader>fi'] = { name = '+Indent' }, --- Indent Control
        ['<leader>fv'] = { name = '+Script Files' }, --- Script File Handling
        ['<leader>?'] = { name = '+Help' }, --- Help
        ['<leader>q'] = { name = '+Quit Nvim' }, --- Exiting
        ['<leader>t'] = { name = '+Tabs' }, --- Tabs Handling
        ['<leader>v'] = { name = '+Vim' }, --- Vim
        ['<leader>ve'] = { name = '+Edit $MYVIMRC' }, --- `init.lua` Editing
        ['<leader>w'] = { name = '+Window' }, --- Window Handling
        ['<leader>ws'] = { name = '+Split' }, --- Window Splitting
    },
    v = {
        ['<leader>f'] = { name = '+File' }, --- File Handling
        ['<leader>fF'] = { name = '+Folding' }, --- Folding
        ['<leader>h'] = { name = '+Help' }, --- Help
        ['<leader>i'] = { name = '+Indent' }, --- Indent Control
        ['<leader>v'] = { name = '+Vim' }, --- Vim
    },
}

Kmap.t('<Esc>', '<C-\\><C-n>', { buffer = 0 })

if is_nil(use_statusline) or not vim.tbl_contains({ 'lualine', 'galaxyline' }, use_statusline) then
    ---@type 'lualine'|'galaxyline'
    _G.use_statusline = 'galaxyline'
end

--- List of manually-callable plugin.
_G.Pkg = require('config.lazy')

--- Set the keymaps previously stated
if WK.available() then
    map_dict(Names, 'wk.register', true)
end
map_dict(Keys, 'wk.register', true)

if is_tbl(Pkg.colorschemes) and not empty(Pkg.colorschemes) then
    --- A table containing various possible colorschemes.
    local C = Pkg.colorschemes

    local Csc = C.new()

    ---@type table<MapModes, KeyMapDict>
    local CscKeys = {}
    CscKeys.n = {}
    CscKeys.v = {}

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

    ---@type table<MapModes, RegKeysNamed>
    local NamesCsc = {
        n = { ['<leader>vc'] = { name = '+Colorschemes' } },
        v = { ['<leader>vc'] = { name = '+Colorschemes' } },
    }

    local csc_group = 'a'
    local i = 1
    local found_csc = ''
    for idx, name in next, selected do
        if is_nil(Csc[name] == nil) then
            goto continue
        end

        if not is_nil(Csc[name].setup) then
            ---@type CscSubMod|ODSubMod
            if found_csc == '' then
                found_csc = name
                Csc[name].setup()
            end

            NamesCsc.n['<leader>vc' .. csc_group] = {
                name = '+Group ' .. csc_group,
            }
            NamesCsc.v['<leader>vc' .. csc_group] = {
                name = '+Group ' .. csc_group,
            }

            for mode, _ in next, CscKeys do
                CscKeys[mode]['<leader>vc' .. csc_group .. tostring(i)] = {
                    Csc[name].setup,
                    desc('Setup Colorscheme `' .. name .. '`'),
                }
            end

            if i == 9 then
                i = 0
                csc_group = displace_letter(csc_group, 'next', true)
            elseif i < 9 then
                i = i + 1
            end
        end

        ::continue::
    end

    if WK.available() then
        map_dict(NamesCsc, 'wk.register', true)
    end
    map_dict(CscKeys, 'wk.register', true)

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
