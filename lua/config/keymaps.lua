local User = require('user_api') --- User API
local Check = User.check ---@see User.check Checking utilities

local is_nil = Check.value.is_nil ---@see User.Check.Value.is_nil
local is_tbl = Check.value.is_tbl ---@see User.Check.Value.is_tbl
local is_str = Check.value.is_str ---@see User.Check.Value.is_str
local is_fun = Check.value.is_fun ---@see User.Check.Value.is_fun
local is_bool = Check.value.is_bool ---@see User.Check.Value.is_bool
local empty = Check.value.empty ---@see User.Check.Value.empty
local ft_get = User.util.ft_get ---@see User.Util.ft_get
local nop = User.maps.nop ---@see User.Maps.nop
local desc = User.maps.kmap.desc ---@see User.Maps.Keymap.desc
local wk_avail = User.maps.wk.available ---@see User.maps.wk.available
local map_dict = User.maps.map_dict ---@see User.Maps.map_dict

User.register_plugin('config.keymaps')

local curr_buf = vim.api.nvim_get_current_buf

---@param force? boolean
---@return fun()
local function buf_del(force)
    force = is_bool(force) and force or false

    local cmd = force and 'bdel!' or 'bdel'
    local ft_triggers = {
        'NvimTree',
        'noice',
        'trouble',
    }
    local pre_exceptions = {
        ft = {
            'help',
            'lazy',
            'man',
            'noice',
        },
        bt = {
            'help',
        },
    }

    return function()
        local prev_ft = ft_get(curr_buf())
        local prev_bt = vim.api.nvim_get_option_value('buftype', { buf = curr_buf() })

        vim.cmd(cmd)

        if vim.tbl_contains(pre_exceptions.ft, prev_ft) then
            return
        end
        if vim.tbl_contains(pre_exceptions.bt, prev_bt) then
            return
        end

        local ft = ft_get(curr_buf())

        if vim.tbl_contains(ft_triggers, ft) then
            vim.cmd.bprev()
        end
    end
end

---@class Config.Keymaps
---@field NOP string[] Table of keys to no-op after `<leader>` is pressed
---@field Keys KeyMapModeDict
---@field Names ModeRegKeysNamed
---@field set_leader fun(self: Config.Keymaps, leader: string, local_leader: string?, force: boolean?)
---@field setup fun(self: Config.Keymaps, keys: (ModeRegKeys|KeyMapModeDict)?, names: ModeRegKeysNamed?)

---@type Config.Keymaps
---@diagnostic disable-next-line:missing-fields
local M = {
    NOP = {
        "'",
        '!',
        '"',
        '#',
        '$',
        '%',
        '&',
        '(',
        ')',
        '*',
        '+',
        ',',
        '-',
        '.',
        '/',
        '=',
        '?',
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
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
        '[',
        ']',
        '^',
        '_',
        '`',
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
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
        '{',
        '}',
        '~',
    },

    --- Global keymaps, plugin-agnostic
    Keys = {
        n = {
            ['<Esc><Esc>'] = {
                vim.cmd.nohls,
                desc('Remove Highlighted Search'),
            },

            ['<leader>bD'] = {
                buf_del(true),
                desc('Close Buffer Forcefully'),
            },
            ['<leader>bd'] = {
                buf_del(false),
                desc('Close Buffer'),
            },
            ['<leader>bf'] = { ':bfirst<CR>', desc('Goto First Buffer') },
            ['<leader>bl'] = { ':blast<CR>', desc('Goto Last Buffer') },
            ['<leader>bn'] = { ':bNext<CR>', desc('Next Buffer') },
            ['<leader>bp'] = { ':bprevious<CR>', desc('Previous Buffer') },

            ['<leader>fFc'] = { ':%foldclose<CR>', desc('Close All Folds') },
            ['<leader>fFo'] = { ':%foldopen<CR>', desc('Open All Folds') },
            ['<leader>fN'] = {
                function()
                    local ft = require('user_api.util').ft_get(0)
                    vim.cmd.wincmd('n')
                    vim.cmd.wincmd('o')

                    vim.bo.modifiable = true
                    vim.api.nvim_set_option_value('ft', ft, { buf = curr_buf() })
                end,
                desc('New Blank File', true),
            },
            ['<leader>fS'] = { ':w ', desc('Save File (Prompt)', false) },
            ['<leader>fir'] = { ':%retab<CR>', desc('Retab File', true) },
            ['<leader>fr'] = { ':%s/', desc('Run Search-Replace Prompt For Whole File', false) },
            ['<leader>fs'] = {
                function()
                    if vim.bo.modifiable then
                        vim.cmd.write()
                    else
                        require('user_api.util.notify').notify('Not writeable')
                    end
                end,
                desc('Save File', false),
            },
            ['<leader>fvL'] = { ':luafile ', desc('Source Lua File (Prompt)', false) },
            ['<leader>fvV'] = { ':so ', desc('Source VimScript File (Prompt)', false) },
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
                desc('Source Current File As Lua File', true),
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
                desc('Source Current File As VimScript File', true),
            },

            ['<leader>vH'] = { ':checkhealth ', desc('Prompt For Checkhealth', false) },
            ['<leader>vee'] = { '<CMD>ed ' .. MYVIMRC .. '<CR>', desc('Open In Current Window') },
            ['<leader>ves'] = {
                '<CMD>split ' .. MYVIMRC .. '<CR>',
                desc('Open In Horizontal Split'),
            },
            ['<leader>vet'] = { '<CMD>tabnew ' .. MYVIMRC .. '<CR>', desc('Open In New Tab') },
            ['<leader>vev'] = {
                '<CMD>vsplit ' .. MYVIMRC .. '<CR>',
                desc('Open In Vertical Split'),
            },
            ['<leader>vh'] = { '<CMD>checkhealth<CR>', desc('Run Checkhealth') },
            ['<leader>vs'] = {
                function()
                    vim.cmd('luafile ' .. MYVIMRC)
                    require('user_api.util.notify').notify(
                        'Sourced `init.lua`',
                        'info',
                        { title = 'luafile', timeout = 250, hide_from_history = true }
                    )
                end,
                desc('Source $MYVIMRC'),
            },

            ['<leader>HT'] = { '<CMD>tab h<CR>', desc('Open Help On New Tab') },
            ['<leader>HV'] = { '<CMD>vertical h<CR>', desc('Open Help On Vertical Split') },
            ['<leader>HX'] = { '<CMD>horizontal h<CR>', desc('Open Help On Horizontal Split') },
            ['<leader>Hh'] = { ':h ', desc('Prompt For Help') },
            ['<leader>Ht'] = { ':tab h ', desc('Prompt For Help On New Tab') },
            ['<leader>Hv'] = { ':vertical h ', desc('Prompt For Help On Vertical Split') },
            ['<leader>Hx'] = { ':horizontal h ', desc('Prompt For Help On Horizontal Split') },

            ['<leader>HMM'] = { ':Man ', desc('Prompt For Man') },
            ['<leader>HMT'] = { ':tab Man ', desc('Prompt For Arbitrary Man Page (Tab)') },
            ['<leader>HMV'] = { ':vert Man ', desc('Prompt For Arbitrary Man Page (Vertical)') },
            ['<leader>HMX'] = {
                ':horizontal Man ',
                desc('Prompt For Arbitrary Man Page (Horizontal)'),
            },
            ['<leader>HMm'] = { '<CMD>Man<CR>', desc('Open Manpage For Word Under Cursor') },
            ['<leader>HMt'] = { '<CMD>tab Man<CR>', desc('Open Arbitrary Man Page (Tab)') },
            ['<leader>HMv'] = { '<CMD>vert Man<CR>', desc('Open Arbitrary Man Page (Vertical)') },
            ['<leader>HMx'] = {
                '<CMD>horizontal Man<CR>',
                desc('Open Arbitrary Man Page (Horizontal)'),
            },

            ['<leader>wN'] = {
                function()
                    local ft = require('user_api.util').ft_get()
                    vim.cmd.wincmd('n')
                    vim.cmd.wincmd('o')

                    vim.bo.modifiable = true
                    vim.api.nvim_set_option_value('ft', ft, { buf = curr_buf() })
                end,
                desc('New Blank File', true),
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
            ['<leader>fFc'] = { ':foldopen<CR>', desc('Open Fold', false) },
            ['<leader>fFo'] = { ':foldclose<CR>', desc('Close Fold', false) },
            ['<leader>fr'] = { ':s/', desc('Search/Replace Prompt For Selection', false) },
            ['<leader>fs'] = {
                function()
                    if vim.bo.modifiable then
                        vim.cmd.write()
                    else
                        require('user_api.util.notify').notify('Not writeable.')
                    end
                end,
                desc('Save File', false),
            },

            ['<leader>ir'] = { ':retab<CR>', desc('Retab Selection', false) },

            ['<leader>qQ'] = { '<CMD>qa!<CR>', desc('Quit Nvim Forcefully') },
            ['<leader>qq'] = { '<CMD>qa<CR>', desc('Quit Nvim') },

            ['<leader>S'] = { ':sort!<CR>', desc('Sort Selection (Reverse)', false) },
            ['<leader>s'] = { ':sort<CR>', desc('Sort Selection', false) },
        },
        t = {
            ['<Esc>'] = { '<C-\\><C-n>', { buffer = 0 } },
        },
    },
    --- `which-key` map group prefixes
    Names = {
        n = {
            ['<leader>H'] = { group = '+Help' }, --- Help
            ['<leader>HM'] = { group = '+Man Pages' }, --- Help
            ['<leader>b'] = { group = '+Buffer' }, --- Buffer Handling
            ['<leader>f'] = { group = '+File' }, --- File Handling
            ['<leader>fF'] = { group = '+Folding' }, --- Folding Control
            ['<leader>fi'] = { group = '+Indent' }, --- Indent Control
            ['<leader>fv'] = { group = '+Script Files' }, --- Script File Handling
            ['<leader>q'] = { group = '+Quit Nvim' }, --- Exiting
            ['<leader>t'] = { group = '+Tabs' }, --- Tabs Handling
            ['<leader>v'] = { group = '+Vim' }, --- Vim
            ['<leader>ve'] = { group = '+Edit Nvim Config File' }, --- `init.lua` Editing
            ['<leader>w'] = { group = '+Window' }, --- Window Handling
            ['<leader>ws'] = { group = '+Split' }, --- Window Splitting
        },
        v = {
            ['<leader>f'] = { group = '+File' }, --- File Handling
            ['<leader>fF'] = { group = '+Folding' }, --- Folding
            ['<leader>h'] = { group = '+Help' }, --- Help
            ['<leader>i'] = { group = '+Indent' }, --- Indent Control
            ['<leader>q'] = { group = '+Quit Nvim' }, --- Exiting
            ['<leader>v'] = { group = '+Vim' }, --- Vim
        },
    },
}

---@param self Config.Keymaps
---@param keys? KeyMapModeDict|ModeRegKeys
---@param names? ModeRegKeysNamed
function M:setup(keys, names)
    local MODES = require('user_api.maps').modes
    local notify = require('user_api.util.notify').notify

    if not leader_set then
        notify([[Leader hasn't been set through `config.keymaps.set_leader()`.]], 'warn', {
            hide_from_history = false,
            timeout = 850,
            title = '[WARNING] (config.keymaps.setup)',
        })
    end

    keys = is_tbl(keys) and keys or {}
    names = is_tbl(names) and names or {}

    local checker_tbl = { keys, names }

    for i, T in next, checker_tbl do
        if empty(T) then
            goto continue
        end

        for k, v in next, T do
            if not vim.tbl_contains(MODES, k) then
                vim.notify(
                    "Your input tables aren't using Vim modes as dictionary keys, ignoring",
                    'warn',
                    {
                        title = '(config.keymaps)',
                        hide_from_history = false,
                        timeout = 200,
                    }
                )

                keys = {}
                names = {}
                break
            end
        end

        ::continue::
    end

    --- Set keymap groups
    if wk_avail() then
        map_dict(vim.tbl_deep_extend('keep', names, self.Names), 'wk.register', true)
    end
    --- Set keymaps
    map_dict(vim.tbl_deep_extend('keep', keys, self.Keys), 'wk.register', true)

    --- Noop keys after `<leader>` to avoid accidents
    for _, mode in next, User.maps.modes do
        nop(self.NOP, { noremap = false, silent = true }, mode, '<leader>')
    end
end

--- Set the `<leader>` key and, if desired, the `<localleader>` aswell
--- ---
--- ## Description
--- Setup a key as `<leader>` and `<localleader>`, but you can also set `<localleader>` to
--- a different key if you want.
---
--- If `<localleader>` is not explicitly set, then it'll be set as `<leader>`
---@param self Config.Keymaps
---@param leader? string _`<leader>`_ key string (defaults to `<Space>`)
---@param local_leader? string _`<localleader>`_ string (defaults to `<Space>`)
---@param force? boolean Force leader switch (defaults to `false`)
function M:set_leader(leader, local_leader, force)
    leader = (is_str(leader) and not empty(leader)) and leader or '<Space>'
    local_leader = (is_str(local_leader) and not empty(local_leader)) and local_leader or leader
    force = is_bool(force) and force or false

    if leader_set and not force then
        return
    end

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

    --- No-op the target `<leader>` key
    nop(leader, { noremap = true, silent = true })

    --- If target `<leader>` and `<localleader>` keys aren't the same
    --- then noop `local_leader` aswell
    if leader ~= local_leader then
        nop(local_leader, { noremap = true, silent = true })
    end

    vim.g.mapleader = vim_vars.leader
    vim.g.maplocalleader = vim_vars.localleader

    _G.leader_set = true
end

return M
