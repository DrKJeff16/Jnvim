---@diagnostic disable:missing-fields

---@module 'user_api.types.keymaps'

local Value = require('user_api.check.value') ---@see User.Check.Value Checking utilities
local Maps = require('user_api.maps') ---@see User.Maps Mapping Utilities
local Kmap = require('user_api.maps.kmap') ---@see User.Maps.Keymap Mapping Utilities (`vim.keymap` version)
local Util = require('user_api.util') ---@see User.Util Utilities

local is_nil = Value.is_nil ---@see User.Check.Value.is_nil
local is_tbl = Value.is_tbl ---@see User.Check.Value.is_tbl
local is_int = Value.is_int ---@see User.Check.Value.is_int
local is_bool = Value.is_bool ---@see User.Check.Value.is_bool
local type_not_empty = Value.type_not_empty ---@see User.Check.Value.type_not_empty
local ft_get = Util.ft_get ---@see User.Util.ft_get
local bt_get = Util.bt_get ---@see User.Util.bt_get
local nop = Maps.nop ---@see User.Maps.nop
local map_dict = Maps.map_dict ---@see User.Maps.map_dict
local desc = Kmap.desc ---@see User.Maps.Keymap.desc

local curr_buf = vim.api.nvim_get_current_buf
local in_tbl = vim.tbl_contains

---@param vertical? boolean
---@return fun()
local function gen_fun_blank(vertical)
    vertical = is_bool(vertical) and vertical or false

    return function()
        local optset = vim.api.nvim_set_option_value

        local buf = vim.api.nvim_create_buf(true, false)
        local win = vim.api.nvim_open_win(buf, true, { vertical = vertical })

        ---@type vim.api.keyset.option
        local set_opts = { buf = buf }

        vim.api.nvim_set_current_win(win)

        optset('ft', '', set_opts)
        optset('buftype', '', set_opts)
        optset('modifiable', true, set_opts)
        optset('modified', false, set_opts)
    end
end

---@param force? boolean
---@return fun()
local function buf_del(force)
    force = is_bool(force) and force or false

    local ft_triggers = {
        'NvimTree',
        'noice',
        'trouble',
    }

    ---@type Keymaps.PreExec
    local pre_exc = {}
    pre_exc.ft = {
        'help',
        'lazy',
        'man',
        'noice',
    }
    pre_exc.bt = {
        'help',
    }

    return function()
        local prev_ft = ft_get(curr_buf())
        local prev_bt = bt_get(curr_buf())

        -- # HACK: Special workaround for `terminal` buffers
        if prev_bt == 'terminal' then
            vim.cmd.bdelete({ bang = true })
        else
            vim.cmd.bdelete()
        end

        if in_tbl(pre_exc.ft, prev_ft) or in_tbl(pre_exc.bt, prev_bt) then
            return
        end

        if in_tbl(ft_triggers, ft_get(curr_buf())) then
            vim.cmd.bprevious()
        end
    end
end

---@type User.Config.Keymaps|User.Config.Keymaps.CallerFun
local Keymaps = {}

Keymaps.NOP = {
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
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '=',
    '?',
    '@',
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
    '\\',
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
    '|',
    '}',
    '~',
}

--- Global keymaps, plugin-agnostic
Keymaps.Keys = {
    n = {
        ['<leader>F'] = { group = '+Folding' }, --- Folding Control
        ['<leader>H'] = { group = '+Help' }, --- Help
        ['<leader>HM'] = { group = '+Man Pages' }, --- Help
        ['<leader>b'] = { group = '+Buffer' }, --- Buffer Handling
        ['<leader>f'] = { group = '+File' }, --- File Handling
        ['<leader>fF'] = { group = '+New File' }, --- New File Creation
        ['<leader>fi'] = { group = '+Indent' }, --- Indent Control
        ['<leader>fv'] = { group = '+Script Files' }, --- Script File Handling
        ['<leader>q'] = { group = '+Quit Nvim' }, --- Exiting
        ['<leader>t'] = { group = '+Tabs' }, --- Tabs Handling
        ['<leader>v'] = { group = '+Vim' }, --- Vim
        ['<leader>ve'] = { group = '+Edit Nvim Config File' }, --- `init.lua` Editing
        ['<leader>vh'] = { group = '+Checkhealth' }, --- `init.lua` Editing
        ['<leader>w'] = { group = '+Window' }, --- Window Handling
        ['<leader>ws'] = { group = '+Split' }, --- Window Splitting

        ['<Esc><Esc>'] = {
            function()
                vim.schedule(vim.cmd.noh)
            end,
            desc('Remove Highlighted Search'),
        },

        ['<leader>bd'] = {
            buf_del(),
            desc('Close Buffer'),
        },
        ['<leader>bD'] = {
            buf_del(true),
            desc('Close Buffer Forcefully'),
        },
        ['<leader>bf'] = { vim.cmd.bfirst, desc('Goto First Buffer') },
        ['<leader>bl'] = { vim.cmd.blast, desc('Goto Last Buffer') },
        ['<leader>bn'] = { vim.cmd.bnext, desc('Next Buffer') },
        ['<leader>bp'] = { vim.cmd.bprevious, desc('Previous Buffer') },

        ['<leader>/'] = { ':%s/', desc('Run Search-Replace Prompt For Whole File', false) },

        ['<leader>Fc'] = { ':%foldclose<CR>', desc('Close All Folds') },
        ['<leader>Fo'] = { ':%foldopen<CR>', desc('Open All Folds') },

        ['<leader>fFx'] = {
            gen_fun_blank(),
            desc('New Horizontal Blank File'),
        },
        ['<leader>fFv'] = {
            gen_fun_blank(true),
            desc('New Vertical Blank File'),
        },

        ['<leader>fs'] = {
            function()
                local notify = require('user_api.util.notify').notify

                local buf = curr_buf()

                ---@type boolean
                local ok = true
                ---@type unknown
                local err = nil

                if vim.api.nvim_get_option_value('modifiable', { buf = buf }) then
                    ok, err = pcall(vim.cmd.write)

                    if ok then
                        notify('File Written: ' .. vim.fn.expand('%:~'), 'info', {
                            animate = true,
                            title = 'Vim Write',
                            timeout = 1000,
                            hide_from_history = true,
                        })

                        return
                    end
                end

                notify(err or 'Unable to write', 'error', {
                    animate = true,
                    title = 'Vim Write',
                    timeout = 2250,
                    hide_from_history = false,
                })
            end,
            desc('Save File'),
        },
        ['<leader>fS'] = { ':w ', desc('Prompt Save File', false) },

        ['<leader>fir'] = {
            function()
                local notify = require('user_api.util.notify').notify

                ---@diagnostic disable-next-line
                local ok, err = pcall(vim.cmd, '%retab')

                if ok then
                    ok, err = pcall(vim.cmd.write)

                    if ok then
                        return
                    end
                end

                notify(err or 'Error attempting to retab', 'error', {
                    animate = true,
                    title = 'Retab',
                    timeout = 2500,
                    hide_from_history = false,
                })
            end,
            desc('Retab File'),
        },

        ['<leader>fvL'] = { ':luafile ', desc('Source Lua File (Prompt)', false) },
        ['<leader>fvV'] = { ':so ', desc('Source VimScript File (Prompt)', false) },
        ['<leader>fvl'] = {
            function()
                local notify = require('user_api.util.notify').notify

                local ft = ft_get()

                ---@type boolean
                local ok = true

                ---@type unknown
                local err = nil

                if ft == 'lua' then
                    ---@diagnostic disable-next-line
                    ok, err = pcall(vim.cmd.luafile, '%')

                    if ok then
                        notify('Sourced current Lua file', 'info', {
                            animate = true,
                            title = 'Lua',
                            timeout = 1500,
                            hide_from_history = true,
                        })

                        return
                    end
                end

                notify(err, 'error', {
                    animate = true,
                    title = 'Lua',
                    timeout = 2000,
                    hide_from_history = false,
                })
            end,
            desc('Source Current File As Lua File'),
        },
        ['<leader>fvv'] = {
            function()
                local notify = require('user_api.util.notify').notify

                local ft = ft_get()

                ---@type boolean
                local ok = true

                ---@type unknown
                local err = nil

                if ft == 'vim' then
                    ---@diagnostic disable-next-line
                    ok, err = pcall(vim.cmd, 'so %')

                    if ok then
                        notify('Sourced current Vim file', 'info', {
                            animate = true,
                            title = 'Vim',
                            timeout = 1000,
                            hide_from_history = true,
                        })

                        return
                    end
                end

                notify(err, 'error', {
                    animate = true,
                    title = 'Vim',
                    timeout = 2000,
                    hide_from_history = false,
                })
            end,
            desc('Source Current File As VimScript File'),
        },

        ['<leader>vee'] = {
            function()
                vim.cmd.edit(MYVIMRC)
            end,
            desc('Open In Current Window'),
        },
        ['<leader>ves'] = {
            function()
                vim.cmd.split(MYVIMRC)
            end,
            desc('Open In Horizontal Split'),
        },
        ['<leader>vet'] = {
            function()
                vim.cmd.tabnew(MYVIMRC)
            end,
            desc('Open In New Tab'),
        },
        ['<leader>vev'] = {
            function()
                vim.cmd.vsplit(MYVIMRC)
            end,
            desc('Open In Vertical Split'),
        },

        ['<leader>vhh'] = { vim.cmd.checkhealth, desc('Run Checkhealth') },
        ['<leader>vhH'] = { ':checkhealth ', desc('Prompt Checkhealth', false) },
        ['<leader>vhd'] = {
            function()
                vim.cmd.checkhealth('vim.health')
            end,
            desc('Run `vim.health` Checkhealth', false),
        },
        ['<leader>vhD'] = {
            function()
                vim.cmd.checkhealth('vim.deprecated')
            end,
            desc('Run `vim.deprecated` Checkhealth', false),
        },
        ['<leader>vhl'] = {
            function()
                vim.cmd.checkhealth('vim.lsp')
            end,
            desc('Run `vim.lsp` Checkhealth', false),
        },

        ['<leader>vs'] = {
            function()
                local notify = require('user_api.util.notify').notify

                ---@diagnostic disable-next-line
                local ok, err = pcall(vim.cmd.luafile, _G.MYVIMRC)

                if ok then
                    notify('Sourced `init.lua`', 'info', {
                        animate = true,
                        title = 'luafile',
                        timeout = 1000,
                        hide_from_history = true,
                    })

                    return
                end

                notify(err, 'error', {
                    animate = true,
                    title = 'luafile',
                    timeout = 2500,
                    hide_from_history = true,
                })
            end,
            desc('Source $MYVIMRC'),
        },

        ['<leader>HT'] = { ':tab h<CR>', desc('Open Help On New Tab') },
        ['<leader>HV'] = { ':vertical h<CR>', desc('Open Help On Vertical Split') },
        ['<leader>HX'] = { ':horizontal h<CR>', desc('Open Help On Horizontal Split') },
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

                vim.api.nvim_set_option_value('ft', ft, { buf = curr_buf() })
                vim.api.nvim_set_option_value('modifiable', true, { buf = curr_buf() })
                vim.api.nvim_set_option_value('modified', false, { buf = curr_buf() })
            end,
            desc('New Blank File'),
        },
        ['<leader>w='] = {
            function()
                vim.cmd.wincmd('=')
            end,
            desc('Resize all windows equally'),
        },
        ['<leader>w<Left>'] = {
            function()
                vim.cmd.wincmd('h')
            end,
            desc('Go To Window On The Left'),
        },
        ['<leader>w<Right>'] = {
            function()
                vim.cmd.wincmd('l')
            end,
            desc('Go To Window On The Right'),
        },
        ['<leader>w<Up>'] = {
            function()
                vim.cmd.wincmd('k')
            end,
            desc('Go To Window Above'),
        },
        ['<leader>w<Down>'] = {
            function()
                vim.cmd.wincmd('j')
            end,
            desc('Go To Window Below'),
        },
        ['<leader>wd'] = {
            function()
                vim.cmd.wincmd('q')
            end,
            desc('Close Window'),
        },
        ['<leader>wn'] = {
            function()
                vim.cmd.wincmd('w')
            end,
            desc('Next Window'),
        },
        ['<leader>ww'] = {
            function()
                vim.cmd.wincmd('w')
            end,
            desc('Next Window'),
        },
        ['<leader>wc'] = {
            function()
                vim.cmd.wincmd('o')
            end,
            desc('Close All Other Windows'),
        },
        ['<leader>wS'] = {
            function()
                vim.cmd.wincmd('x')
            end,
            desc('Swap Current WithNext'),
        },
        ['<leader>wt'] = {
            function()
                vim.cmd.wincmd('T')
            end,
            desc('Break Current Window Into Tab'),
        },
        ['<leader>wp'] = {
            function()
                vim.cmd.wincmd('W')
            end,
            desc('Previous Window'),
        },
        ['<leader>wsX'] = { ':split ', desc('Horizontal Split (Prompt)', false) },
        ['<leader>wsV'] = { ':vsplit ', desc('Vertical Split (Prompt)', false) },
        ['<leader>wsx'] = {
            function()
                vim.cmd.wincmd('s')
            end,
            desc('Horizontal Split'),
        },
        ['<leader>wsv'] = {
            function()
                vim.cmd.wincmd('v')
            end,
            desc('Vertical Split'),
        },

        ['<leader>qQ'] = { ':qa!<CR>', desc('Quit Nvim Forcefully') },
        ['<leader>qq'] = {
            function()
                if require('user_api.check.exists').module('toggleterm') then
                    local T = require('toggleterm.terminal').get_all(true)

                    for _, term in next, T do
                        term:close()
                    end
                end
                vim.cmd.qa()
            end,
            desc('Quit Nvim'),
        },

        ['<leader>tA'] = { vim.cmd.tabnew, desc('New Tab') },
        ['<leader>tD'] = { ':tabclose!<CR>', desc('Close Tab Forcefully') },
        ['<leader>ta'] = { ':tabnew ', desc('New Tab (Prompt)', false) },
        ['<leader>td'] = { vim.cmd.tabclose, desc('Close Tab') },
        ['<leader>tf'] = { vim.cmd.tabfirst, desc('Goto First Tab') },
        ['<leader>tl'] = { vim.cmd.tablast, desc('Goto Last Tab') },
        ['<leader>tn'] = { vim.cmd.tabnext, desc('Next Tab') },
        ['<leader>tp'] = { vim.cmd.tabprevious, desc('Previous Tab') },
    },
    v = {
        ['<leader>f'] = { group = '+File' }, --- File Handling
        ['<leader>fF'] = { group = '+Folding' }, --- Folding
        ['<leader>h'] = { group = '+Help' }, --- Help
        ['<leader>i'] = { group = '+Indent' }, --- Indent Control
        ['<leader>q'] = { group = '+Quit Nvim' }, --- Exiting
        ['<leader>v'] = { group = '+Vim' }, --- Vim

        ['<leader>fFc'] = { ':foldopen<CR>', desc('Open Fold') },
        ['<leader>fFo'] = { ':foldclose<CR>', desc('Close Fold') },
        ['<leader>fr'] = { ':s/', desc('Search/Replace Prompt For Selection', false) },
        ['<leader>fs'] = {
            function()
                local notify = require('user_api.util.notify').notify

                ---@type boolean
                local ok = true
                ---@type unknown
                local err = nil

                if vim.api.nvim_get_option_value('modifiable', { buf = curr_buf() }) then
                    ok, err = pcall(vim.cmd.write)

                    if ok then
                        return
                    end
                end

                notify(err or 'Unable to write', 'error', {
                    animate = true,
                    title = 'Vim Write',
                    timeout = 2250,
                    hide_from_history = false,
                })
            end,
            desc('Save File'),
        },

        ['<leader>ir'] = { ':retab<CR>', desc('Retab Selection') },

        ['<leader>qQ'] = { '<CMD>qa!<CR>', desc('Quit Nvim Forcefully') },
        ['<leader>qq'] = { vim.cmd.qa, desc('Quit Nvim') },
    },
    t = {
        ['<Esc>'] = { '<C-\\><C-n>', desc('Escape Terminal') },
    },
}

--- Set the `<leader>` key and, if desired, the `<localleader>` aswell
--- ---
--- ## Description
--- Setup a key as `<leader>` and `<localleader>`, but you can also set `<localleader>` to
--- a different key if you want.
---
--- If `<localleader>` is not explicitly set, then it'll be set as `<leader>`
---@param self User.Config.Keymaps
---@param leader string _`<leader>`_ key string (defaults to `<Space>`)
---@param local_leader? string _`<localleader>`_ string (defaults to `<Space>`)
---@param force? boolean Force leader switch (defaults to `false`)
function Keymaps:set_leader(leader, local_leader, force)
    leader = type_not_empty('string', leader) and leader or '<Space>'
    local_leader = type_not_empty('string', local_leader) and local_leader or leader
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
    nop(leader, { noremap = true, silent = true }, 'n')
    nop(leader, { noremap = true, silent = true }, 'v')

    --- If target `<leader>` and `<localleader>` keys aren't the same
    --- then noop `local_leader` aswell
    if leader ~= local_leader then
        nop(local_leader, { noremap = true, silent = true }, 'n')
        nop(local_leader, { noremap = true, silent = true }, 'v')
    end

    vim.g.mapleader = vim_vars.leader
    vim.g.maplocalleader = vim_vars.localleader

    _G.leader_set = true
end

---@param O? table
---@return table|User.Config.Keymaps|User.Config.Keymaps.CallerFun
function Keymaps.new(O)
    O = is_tbl(O) and O or {}
    return setmetatable(O, {
        __index = Keymaps,

        ---@type fun(self: User.Config.Keymaps, keys: AllModeMaps, bufnr: integer?, load_defaults: boolean?)
        __call = function(self, keys, bufnr, load_defaults)
            local MODES = Maps.modes
            local insp = inspect or vim.inspect

            local notify = require('user_api.util.notify').notify

            if not leader_set then
                notify('`keymaps:set_leader()` not called!', 'warn', {
                    hide_from_history = false,
                    timeout = 3250,
                    title = '[WARNING] (user_api.config.keymaps.setup)',
                })
            end

            keys = is_tbl(keys) and keys or {}
            bufnr = is_int(bufnr) and bufnr or nil
            load_defaults = is_bool(load_defaults) and load_defaults or false

            ---@type AllModeMaps
            local parsed_keys = {}

            for k, v in next, keys do
                if not in_tbl(MODES, k) then
                    notify(
                        string.format('Table not formatted correctly. Ignoring\n\n%s', insp(keys)),
                        'warn',
                        {
                            animate = true,
                            title = '(user_api.config.keymaps:setup())',
                            hide_from_history = false,
                            timeout = 1250,
                        }
                    )
                else
                    parsed_keys[k] = v
                end
            end

            self.no_oped = is_bool(self.no_oped) and self.no_oped or false

            --- Noop keys after `<leader>` to avoid accidents
            for _, mode in next, MODES do
                if self.no_oped then
                    break
                end

                if in_tbl({ 'n', 'v' }, mode) then
                    nop(self.NOP, { noremap = false, silent = true }, mode, '<leader>')
                end
            end

            self.no_oped = true

            ---@type AllModeMaps
            local res = load_defaults and vim.tbl_deep_extend('keep', parsed_keys, self.Keys)
                or parsed_keys

            --- Set keymaps
            if is_nil(bufnr) then
                map_dict(res, 'wk.register', true)
            else
                map_dict(res, 'wk.register', true, nil, bufnr)
            end
        end,
    })
end

local K = Keymaps.new()

return K

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
