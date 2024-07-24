local User = require('user_api') --- User API
local Check = User.check ---@see User.Check Checking utilities
local Maps = User.maps --- Mapping utilities
local Kmap = Maps.kmap --- `vim.keymap.set` backend
local WK = Maps.wk --- `which-key` backend
local maps_t = User.types.user.maps ---@see UserSubTypes.maps

local nop = User.maps.nop ---@see User.Maps.nop
local desc = Kmap.desc ---@see User.Maps.Keymap.desc
local map_dict = Maps.map_dict ---@see User.Maps.map_dict
local is_nil = Check.value.is_nil ---@see User.Check.Value.is_nil
local is_tbl = Check.value.is_tbl ---@see User.Check.Value.is_tbl
local is_str = Check.value.is_str ---@see User.Check.Value.is_str
local is_fun = Check.value.is_fun ---@see User.Check.Value.is_fun
local empty = Check.value.empty ---@see User.Check.Value.empty

--- Avoid executing these keys when attempting `<leader>` sequences
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

--- Global keymaps, plugin-agnostic
---@type table<MapModes, KeyMapDict>
local DEFAULT_KEYS = {
    n = {
        ['<Esc><Esc>'] = { vim.cmd.nohls, desc('Remove Highlighted Search'):add({ hidden = true }) },

        ['<leader>bD'] = { '<CMD>bdel!<CR>', desc('Close Buffer Forcefully') },
        ['<leader>bd'] = { '<CMD>bdel<CR>', desc('Close Buffer') },
        ['<leader>bf'] = { '<CMD>bfirst<CR>', desc('Goto First Buffer') },
        ['<leader>bl'] = { '<CMD>blast<CR>', desc('Goto Last Buffer') },
        ['<leader>bn'] = { '<CMD>bNext<CR>', desc('Next Buffer') },
        ['<leader>bp'] = { '<CMD>bprevious<CR>', desc('Previous Buffer') },

        ['<leader>fFc'] = { ':%foldclose<CR>', desc('Close All Folds') },
        ['<leader>fFo'] = { ':%foldopen<CR>', desc('Open All Folds') },
        ['<leader>fN'] = {
            function()
                local ft = require('user_api.util').ft_get(0)
                vim.cmd.wincmd('n')
                vim.cmd.wincmd('o')

                vim.bo.modifiable = true
                vim.api.nvim_set_option_value('ft', ft, { buf = vim.api.nvim_get_current_buf() })
            end,
            desc('New Blank File', true, 0),
        },
        ['<leader>fS'] = { ':w ', desc('Save File (Prompt)', false, 0) },
        ['<leader>fir'] = { ':%retab<CR>', desc('Retab File') },
        ['<leader>fr'] = { ':%s/', desc('Run Search-Replace Prompt For Whole File', false, 0) },
        ['<leader>fs'] = {
            function()
                if vim.bo.modifiable then
                    vim.cmd.write()
                else
                    require('user_api.util.notify').notify('Not writeable.')
                end
            end,
            desc('Save File', false, 0),
        },
        ['<leader>fvL'] = { ':luafile ', desc('Source Lua File (Prompt)', false, 0) },
        ['<leader>fvV'] = { ':so ', desc('Source VimScript File (Prompt)', false, 0) },
        ['<leader>fvl'] = {
            function()
                local ft = require('user_api.util').ft_get()
                local err_msg = 'Filetype `' .. ft .. '` not sourceable by Lua'

                if ft == 'lua' then
                    vim.cmd('luafile %')
                    require('user_api.util.notify').notify(
                        'Sourced current Lua file',
                        'info',
                        { title = 'Lua', timeout = 150, hide_from_history = true }
                    )
                else
                    require('user_api.util.notify').notify(
                        err_msg,
                        'error',
                        { title = 'Lua', timeout = 250, hide_from_history = true }
                    )
                end
            end,
            desc('Source Current File As Lua File', true, 0),
        },
        ['<leader>fvv'] = {
            function()
                local ft = require('user_api.util').ft_get()
                local err_msg = 'Filetype `' .. ft .. '` not sourceable by Vim'

                if ft == 'vim' then
                    vim.cmd('so %')
                    require('user_api.util.notify').notify(
                        'Sourced current Vim file',
                        'info',
                        { title = 'Vim', timeout = 150, hide_from_history = true }
                    )
                else
                    require('user_api.util.notify').notify(
                        err_msg,
                        'error',
                        { title = 'Vim', timeout = 250, hide_from_history = true }
                    )
                end
            end,
            desc('Source Current File As VimScript File', true, 0),
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
                require('user_api.util.notify').notify(
                    'Sourced `init.lua`',
                    'info',
                    { title = 'luafile', timeout = 250, hide_from_history = true }
                )
            end,
            desc('Source $MYVIMRC'),
        },

        ['<leader>HS'] = { '<CMD>horizontal h<CR>', desc('Open Help On Horizontal Split') },
        ['<leader>HT'] = { '<CMD>tab h<CR>', desc('Open Help On New Tab') },
        ['<leader>HV'] = { '<CMD>vertical h<CR>', desc('Open Help On Vertical Split') },
        ['<leader>Hh'] = { ':h ', desc('Prompt For Help', false) },
        ['<leader>Hs'] = { ':horizontal h ', desc('Prompt For Help On Horizontal Split', false) },
        ['<leader>Ht'] = { ':tab h ', desc('Prompt For Help On New Tab', false) },
        ['<leader>Hv'] = { ':vertical h ', desc('Prompt For Help On Vertical Split', false) },

        ['<leader>wN'] = {
            function()
                local ft = require('user_api.util').ft_get()
                vim.cmd.wincmd('n')
                vim.cmd.wincmd('o')

                vim.bo.modifiable = true
                vim.api.nvim_set_option_value('ft', ft, { buf = vim.api.nvim_get_current_buf() })
            end,
            desc('New Blank File', true, 0),
        },
        ['<leader>w='] = {
            function() vim.cmd.wincmd('=') end,
            desc('Resize all windows equally'),
        },
        ['<leader>w<Left>'] = {
            function() vim.cmd.wincmd('h') end,
            desc('Go To Window On The Left'),
        },
        ['<leader>w<Right>'] = {
            function() vim.cmd.wincmd('l') end,
            desc('Go To Window On The Right'),
        },
        ['<leader>w<Up>'] = {
            function() vim.cmd.wincmd('k') end,
            desc('Go To Window Above'),
        },
        ['<leader>w<Down>'] = {
            function() vim.cmd.wincmd('j') end,
            desc('Go To Window Below'),
        },
        ['<leader>wd'] = {
            function() vim.cmd.wincmd('q') end,
            desc('Close Window'),
        },
        ['<leader>wn'] = {
            function() vim.cmd.wincmd('w') end,
            desc('Next Window'),
        },
        ['<leader>wp'] = {
            function() vim.cmd.wincmd('W') end,
            desc('Previous Window'),
        },
        ['<leader>wsS'] = { ':split ', desc('Horizontal Split (Prompt)', false) },
        ['<leader>wsV'] = { ':vsplit ', desc('Vertical Split (Prompt)', false) },
        ['<leader>wss'] = {
            function() vim.cmd.wincmd('s') end,
            desc('Horizontal Split'),
        },
        ['<leader>wsv'] = {
            function() vim.cmd.wincmd('v') end,
            desc('Vertical Split'),
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
        ['<leader>S'] = { ':sort!<CR>', desc('Sort Selection (Reverse)', false, 0) },
        ['<leader>s'] = { ':sort<CR>', desc('Sort Selection', false, 0) },

        ['<leader>fFc'] = { ':foldopen<CR>', desc('Open Fold', false, 0) },
        ['<leader>fFo'] = { ':foldclose<CR>', desc('Close Fold', false, 0) },

        ['<leader>ir'] = { ':retab<CR>', desc('Retab Selection', false, 0) },

        ['<leader>fr'] = { ':s/', desc('Search/Replace Prompt For Selection', false, 0) },
    },
}
--- `which-key` map group prefixes
---@type table<MapModes, RegKeysNamed>
local DEFAULT_NAMES = {
    n = {
        ['<leader>b'] = { group = '+Buffer' }, --- Buffer Handling
        ['<leader>f'] = { group = '+File' }, --- File Handling
        ['<leader>fF'] = { group = '+Folding' }, --- Folding Control
        ['<leader>fi'] = { group = '+Indent' }, --- Indent Control
        ['<leader>fv'] = { group = '+Script Files' }, --- Script File Handling
        ['<leader>H'] = { group = '+Help' }, --- Help
        ['<leader>q'] = { group = '+Quit Nvim' }, --- Exiting
        ['<leader>t'] = { group = '+Tabs' }, --- Tabs Handling
        ['<leader>v'] = { group = '+Vim' }, --- Vim
        ['<leader>ve'] = { group = '+Edit $MYVIMRC' }, --- `init.lua` Editing
        ['<leader>w'] = { group = '+Window' }, --- Window Handling
        ['<leader>ws'] = { group = '+Split' }, --- Window Splitting
    },
    v = {
        ['<leader>f'] = { group = '+File' }, --- File Handling
        ['<leader>fF'] = { group = '+Folding' }, --- Folding
        ['<leader>h'] = { group = '+Help' }, --- Help
        ['<leader>i'] = { group = '+Indent' }, --- Indent Control
        ['<leader>v'] = { group = '+Vim' }, --- Vim
    },
}

Kmap.t('<Esc>', '<C-\\><C-n>', { buffer = 0 })

local M = {}

---@param keys? table|table<MapModes, KeyMapDict>[]
---@param names? table|table<MapModes, RegKeysNamed>[]
function M.setup(keys, names)
    keys = is_tbl(keys) and keys or {}
    names = is_tbl(names) and names or {}

    --- Set the keymaps previously stated
    if WK.available() then
        map_dict(vim.tbl_extend('keep', names, DEFAULT_NAMES), 'wk.register', true)
    end
    map_dict(vim.tbl_extend('keep', keys, DEFAULT_KEYS), 'wk.register', true)

    for _, mode in next, User.maps.modes do
        nop(NOP, {}, mode, '<leader>')
    end
end

---@param leader string
---@param local_leader? string
function M.set_leader(leader, local_leader)
    leader = (is_str(leader) and not empty(leader)) and leader or '<Space>'
    local_leader = (is_str(local_leader) and not empty(local_leader)) and local_leader or leader

    local vim_vars = {
        leader = '',
        localleader = '',
    }

    if leader:lower() == '<space>' then
        vim_vars.leader = ' '
    elseif leader == ' ' then
        leader = '<Space>'
        vim_vars.leader = ' '
    else
        vim_vars.leader = leader
    end

    if local_leader:lower() == '<space>' then
        vim_vars.localleader = ' '
    elseif local_leader == ' ' then
        local_leader = '<Space>'
        vim_vars.localleader = ' '
    else
        vim_vars.localleader = local_leader
    end

    nop(leader, { noremap = true, nowait = false, silent = true })

    vim.g.mapleader = vim_vars.leader
    vim.g.maplocalleader = vim_vars.localleader
end

return M
