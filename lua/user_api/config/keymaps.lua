local fmt = string.format
local inspect = vim.inspect

local VIMRC = vim.fn.stdpath('config') .. '/init.lua'

local nop = require('user_api.maps').nop
local map_dict = require('user_api.maps').map_dict
local desc = require('user_api.maps').desc
local ft_get = require('user_api.util').ft_get
local bt_get = require('user_api.util').bt_get
local is_int = require('user_api.check.value').is_int

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO

local validate = vim.validate
local copy = vim.deepcopy
local curr_buf = vim.api.nvim_get_current_buf
local in_tbl = vim.tbl_contains
local d_extend = vim.tbl_deep_extend
local optset = vim.api.nvim_set_option_value

---@return fun()
local function rcfile_ed()
    return function()
        vim.cmd.edit(VIMRC)
    end
end

---@return fun()
local function rcfile_split()
    return function()
        vim.cmd.split(VIMRC)
    end
end

---@return fun()
local function rcfile_vsplit()
    return function()
        vim.cmd.vsplit(VIMRC)
    end
end

---@return fun()
local function rcfile_tab()
    return function()
        vim.cmd.tabnew(VIMRC)
    end
end

---@param check string
---@return fun()
local function gen_checkhealth(check)
    return function()
        vim.cmd.checkhealth(check)
    end
end

---@param vertical? boolean
---@return fun()
local function gen_fun_blank(vertical)
    validate('vertical', vertical, 'boolean', true)

    vertical = vertical ~= nil and vertical or false

    return function()
        local buf = vim.api.nvim_create_buf(true, false)
        local win = vim.api.nvim_open_win(buf, true, { vertical = vertical })

        ---@type vim.api.keyset.option
        local set_opts = { scope = 'local' }

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
    validate('force', force, 'boolean', true)

    force = force ~= nil and force or false

    local ft_triggers = {
        'NvimTree',
        'noice',
        'trouble',
    }

    local pre_exc = {
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
        local buf = curr_buf()
        local prev_ft, prev_bt = ft_get(buf), bt_get(buf)

        if not force then
            force = prev_bt == 'terminal'
        end

        -- # HACK: Special workaround for `terminal` buffers
        vim.cmd.bdelete({ bang = force })

        if in_tbl(pre_exc.ft, prev_ft) or in_tbl(pre_exc.bt, prev_bt) then
            return
        end

        if in_tbl(ft_triggers, ft_get(curr_buf())) then
            vim.cmd.bprevious()
        end
    end
end

---@class User.Config.Keymaps
---@field no_oped? boolean
local Keymaps = {}

local NOP = {
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
    '<CR>',
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

Keymaps.NOP = setmetatable({}, {
    __index = NOP,

    __newindex = function(_, _, _)
        error('(user_api.config.keymaps.NOP): Read-only table!', ERROR)
    end,
})

--- Global keymaps, plugin-agnostic
---@type AllModeMaps
Keymaps.Keys = {
    -- Normal Mode Keys
    n = {
        ['<leader>'] = { group = '+Open `which-key`' },
        ['<leader>F'] = { group = '+Folding' },
        ['<leader>H'] = { group = '+Help' },
        ['<leader>Hm'] = { group = '+Man Pages' },
        ['<leader>b'] = { group = '+Buffer' },
        ['<leader>f'] = { group = '+File' },
        ['<leader>fF'] = { group = '+New File' },
        ['<leader>fi'] = { group = '+Indent' },
        ['<leader>fv'] = { group = '+Script Files' },
        ['<leader>q'] = { group = '+Quit Nvim' },
        ['<leader>t'] = { group = '+Tabs' },
        ['<leader>v'] = { group = '+Vim' },
        ['<leader>ve'] = { group = '+Edit Nvim Config File' },
        ['<leader>vh'] = { group = '+Checkhealth' },
        ['<leader>w'] = { group = '+Window' },
        ['<leader>wW'] = { group = '+Extra Operations' },
        ['<leader>ws'] = { group = '+Split' },
        ['<leader>U'] = { group = '+User API' },
        ['<leader>UK'] = { group = '+Keymaps' },

        ['<Esc><Esc>'] = {
            vim.cmd.noh,
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
        ['<leader>bf'] = {
            vim.cmd.bfirst,
            desc('Goto First Buffer'),
        },
        ['<leader>bl'] = {
            vim.cmd.blast,
            desc('Goto Last Buffer'),
        },
        ['<leader>bn'] = {
            vim.cmd.bnext,
            desc('Next Buffer'),
        },
        ['<leader>bp'] = {
            vim.cmd.bprevious,
            desc('Previous Buffer'),
        },

        ['<leader>/'] = {
            ':%s/',
            desc('Run Search-Replace Prompt For Whole File', false),
        },

        ['<leader>Fc'] = {
            ':%foldclose!<CR>',
            desc('Close All Folds'),
        },
        ['<leader>Fo'] = {
            ':%foldopen!<CR>',
            desc('Open All Folds'),
        },

        ['<leader>fFx'] = {
            gen_fun_blank(),
            desc('New Horizontal Blank File'),
        },
        ['<leader>fFv'] = {
            gen_fun_blank(true),
            desc('New Vertical Blank File'),
        },

        ['<leader>fs'] = {
            vim.cmd.write,
            desc('Save File'),
        },
        ['<leader>fS'] = {
            ':w ',
            desc('Prompt Save File', false),
        },

        ['<leader>fii'] = {
            function()
                local opt_get = vim.api.nvim_get_option_value
                local cursor_set = vim.api.nvim_win_set_cursor
                local cursor_get = vim.api.nvim_win_get_cursor

                local bufnr = curr_buf()

                if not opt_get('modifiable', { buf = bufnr }) then
                    error('Unable to indent. File is not modifiable!', ERROR)
                end

                local win = vim.api.nvim_get_current_win()
                local saved_pos = cursor_get(win)

                vim.api.nvim_feedkeys('gg=G', 'n', false)

                -- HACK: Wait for `feedkeys` to end, then reset to position
                vim.schedule(function()
                    cursor_set(win, saved_pos)
                end)
            end,
            desc('Indent Whole File'),
        },

        ['<leader>fir'] = {
            ':%retab<CR>',
            desc('Retab File'),
        },
        ['<leader>fiR'] = {
            ':%retab!<CR>',
            desc('Retab File (Forcefully)'),
        },

        ['<leader>fvL'] = {
            ':luafile ',
            desc('Source Lua File (Prompt)', false),
        },
        ['<leader>fvV'] = {
            ':so ',
            desc('Source VimScript File (Prompt)', false),
        },
        ['<leader>fvl'] = {
            function()
                vim.cmd.luafile('%')
            end,
            desc('Source Current File As Lua File'),
        },
        ['<leader>fvv'] = {
            function()
                vim.cmd.source('%')
            end,
            desc('Source Current File As VimScript File'),
        },

        ['<leader>vee'] = {
            rcfile_ed(),
            desc('Open In Current Window'),
        },
        ['<leader>vex'] = {
            rcfile_split(),
            desc('Open In Horizontal Split'),
        },
        ['<leader>vet'] = {
            rcfile_tab(),
            desc('Open In New Tab'),
        },
        ['<leader>vev'] = {
            rcfile_vsplit(),
            desc('Open In Vertical Split'),
        },

        ['<leader>vhh'] = {
            vim.cmd.checkhealth,
            desc('Run Checkhealth'),
        },
        ['<leader>vhH'] = {
            ':checkhealth ',
            desc('Prompt Checkhealth', false),
        },
        ['<leader>vhd'] = {
            gen_checkhealth('vim.health'),
            desc('Run `vim.health` Checkhealth'),
        },
        ['<leader>vhD'] = {
            gen_checkhealth('vim.deprecated'),
            desc('Run `vim.deprecated` Checkhealth'),
        },
        ['<leader>vhl'] = {
            gen_checkhealth('vim.lsp'),
            desc('Run `vim.lsp` Checkhealth'),
        },
        ['<leader>vhp'] = {
            gen_checkhealth('vim.provider'),
            desc('Run `vim.provider` Checkhealth'),
        },
        ['<leader>vht'] = {
            gen_checkhealth('vim.treesitter'),
            desc('Run `vim.treesitter` Checkhealth'),
        },

        ['<leader>vs'] = {
            function()
                vim.cmd.source(VIMRC)
            end,
            desc('Source $MYVIMRC'),
        },

        ['<leader>HT'] = {
            function()
                vim.cmd.help()
                vim.cmd.wincmd('T')
            end,
            desc('Open Help On New Tab'),
        },
        ['<leader>HV'] = {
            function()
                vim.cmd.help({ mods = { vertical = true } })
            end,
            desc('Open Help On Vertical Split'),
        },
        ['<leader>HX'] = {
            function()
                vim.cmd.help({ mods = { horizontal = true } })
            end,
            desc('Open Help On Horizontal Split'),
        },
        ['<leader>Hh'] = {
            ':h ',
            desc('Prompt For Help', false),
        },
        ['<leader>Ht'] = {
            ':tab h ',
            desc('Prompt For Help On New Tab', false),
        },
        ['<leader>Hv'] = {
            ':vertical h ',
            desc('Prompt For Help On Vertical Split', false),
        },
        ['<leader>Hx'] = {
            ':horizontal h ',
            desc('Prompt For Help On Horizontal Split', false),
        },
        ['<leader>HmM'] = {
            ':Man ',
            desc('Prompt For Man', false),
        },
        ['<leader>HmT'] = {
            ':tab Man ',
            desc('Prompt For Arbitrary Man Page (Tab)', false),
        },
        ['<leader>HmV'] = {
            ':vert Man ',
            desc('Prompt For Arbitrary Man Page (Vertical)', false),
        },
        ['<leader>HmX'] = {
            ':horizontal Man ',
            desc('Prompt For Arbitrary Man Page (Horizontal)', false),
        },
        ['<leader>Hmm'] = {
            ':Man<CR>',
            desc('Open Manpage For Word Under Cursor'),
        },
        ['<leader>Hmt'] = {
            ':tab Man<CR>',
            desc('Open Arbitrary Man Page (Tab)'),
        },
        ['<leader>Hmv'] = {
            ':vert Man<CR>',
            desc('Open Arbitrary Man Page (Vertical)'),
        },
        ['<leader>Hmx'] = {
            ':horizontal Man<CR>',
            desc('Open Arbitrary Man Page (Horizontal)'),
        },

        ['<leader>wN'] = {
            function()
                local bufnr = curr_buf()
                local ft = ft_get(bufnr)

                vim.cmd.wincmd('n')
                vim.cmd.wincmd('o')

                local opts = { buf = bufnr }

                optset('ft', ft, opts)
                optset('modifiable', true, opts)
                optset('modified', false, opts)
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
        ['<leader>wS'] = {
            function()
                vim.cmd.wincmd('x')
            end,
            desc('Swap Current With Next'),
        },
        ['<leader>wx'] = {
            function()
                vim.cmd.wincmd('x')
            end,
            desc('Exchange Current With Next'),
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
        ['<leader>w<CR>'] = {
            function()
                vim.cmd.wincmd('o')
            end,
            desc('Make Current Only Window'),
        },
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
        ['<leader>wsX'] = {
            ':split ',
            desc('Horizontal Split (Prompt)', false),
        },
        ['<leader>wsV'] = {
            ':vsplit ',
            desc('Vertical Split (Prompt)', false),
        },
        ['<leader>w|'] = {
            function()
                vim.cmd.wincmd('^')
            end,
            desc('Split Current To Edit Alternate File'),
        },
        ['<leader>wW<Up>'] = {
            function()
                vim.cmd.wincmd('K')
            end,
            desc('Move Window To The Very Top'),
        },
        ['<leader>wW<Down>'] = {
            function()
                vim.cmd.wincmd('J')
            end,
            desc('Move Window To The Very Bottom'),
        },
        ['<leader>wW<Right>'] = {
            function()
                vim.cmd.wincmd('L')
            end,
            desc('Move Window To Far Right'),
        },
        ['<leader>wW<Left>'] = {
            function()
                vim.cmd.wincmd('H')
            end,
            desc('Move Window To Far Left'),
        },

        ['<leader>qQ'] = {
            function()
                vim.cmd.quitall({ bang = true })
            end,
            desc('Quit Nvim Forcefully'),
        },
        ['<leader>qq'] = {
            vim.cmd.quitall,
            desc('Quit Nvim'),
        },
        ['<leader>qr'] = {
            ':restart +qall! lua vim.pack.update()<CR>',
            desc('Restart Nvim'),
        },

        ['<leader>tA'] = {
            vim.cmd.tabnew,
            desc('New Tab'),
        },
        ['<leader>tD'] = {
            function()
                vim.cmd.tabclose({ bang = true })
            end,
            desc('Close Tab Forcefully'),
        },
        ['<leader>ta'] = {
            ':tabnew ',
            desc('New Tab (Prompt)', false),
        },
        ['<leader>td'] = {
            vim.cmd.tabclose,
            desc('Close Tab'),
        },
        ['<leader>tf'] = {
            vim.cmd.tabfirst,
            desc('Goto First Tab'),
        },
        ['<leader>tl'] = {
            vim.cmd.tablast,
            desc('Goto Last Tab'),
        },
        ['<leader>tn'] = {
            vim.cmd.tabnext,
            desc('Next Tab'),
        },
        ['<leader>tp'] = {
            vim.cmd.tabprevious,
            desc('Previous Tab'),
        },

        ['<leader>UKp'] = {
            function()
                vim.notify(inspect(Keymaps.Keys), INFO)
            end,
            desc('Print all custom keymaps in their respective modes'),
        },
    },

    --- Visual Mode Keys
    v = {
        ['<leader>'] = { group = '+Open `which-key`' },
        ['<leader>f'] = { group = '+File' }, --- File Handling
        ['<leader>fF'] = { group = '+Folding' }, --- Folding
        ['<leader>fi'] = { group = '+Indent' }, --- Indent Control
        ['<leader>h'] = { group = '+Help' }, --- Help
        ['<leader>q'] = { group = '+Quit Nvim' }, --- Exiting
        ['<leader>v'] = { group = '+Vim' }, --- Vim

        ['<leader>S'] = {
            ':sort!<CR>',
            desc('Sort Selection (Reverse)'),
        },
        ['<leader>s'] = {
            ':sort<CR>',
            desc('Sort Selection'),
        },

        ['<leader>fFo'] = {
            ':foldopen<CR>',
            desc('Open Fold'),
        },
        ['<leader>fFc'] = {
            ':foldclose<CR>',
            desc('Close Fold'),
        },
        ['<leader>fr'] = {
            ':s/',
            desc('Search/Replace Prompt For Selection', false),
        },

        ['<leader>fir'] = {
            ':retab<CR>',
            desc('Retab Selection'),
        },
        ['<leader>fiR'] = {
            ':retab!<CR>',
            desc('Retab Selection Forcefully'),
        },

        ['<leader>qQ'] = {
            function()
                vim.cmd.quitall({ bang = true })
            end,
            desc('Quit Nvim Forcefully'),
        },
        ['<leader>qq'] = {
            vim.cmd.quitall,
            desc('Quit Nvim'),
        },
    },

    -- Terminal Mode Keys
    t = {
        ['<Esc>'] = {
            '<C-\\><C-n>',
            desc('Escape Terminal'),
        },
    },
}

---Set both the `<leader>` and `<localleader>` keys.
---
---Setup a key as `<leader>` and `<localleader>`,
---but you can also set `<localleader>` to
---a different key if you want.
---
---If `<localleader>` is not explicitly set,
---then it'll be set as `<leader>`.
--- ---
---@param leader string _`<leader>`_ key string (defaults to `<Space>`)
---@param local_leader? string _`<localleader>`_ string (defaults to `<Space>`)
---@param force? boolean Force leader switch (defaults to `false`)
function Keymaps.set_leader(leader, local_leader, force)
    validate('leader', leader, 'string', false)
    validate('local_leader', local_leader, 'string', true)
    validate('force', force, 'boolean', true)

    leader = leader ~= '' and leader or '<Space>'
    local_leader = (local_leader ~= nil and local_leader ~= '') and local_leader or leader
    force = force ~= nil and force or false

    if vim.g.leader_set and not force then
        return
    end

    local vim_vars = { leader = '', localleader = '' }

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

    local opts = { noremap = true, silent = true }

    --- No-op the target `<leader>` key
    nop(leader, opts, 'n')
    nop(leader, opts, 'v')

    --- If target `<leader>` and `<localleader>` keys aren't the same
    --- then noop `local_leader` aswell
    if leader ~= local_leader then
        nop(local_leader, opts, 'n')
        nop(local_leader, opts, 'v')
    end

    vim.g.mapleader = vim_vars.leader
    vim.g.maplocalleader = vim_vars.localleader

    vim.g.leader_set = true
end

---@param K table<('n'|'i'|'v'|'t'|'o'|'x'), string[]>|string[]
---@param bufnr? integer
---@return table<('n'|'i'|'v'|'t'|'o'|'x'), nil[]>|nil
function Keymaps.delete(K, bufnr)
    validate('K', K, 'table', false, "{ [('n'|'i'|'v'|'t'|'o'|'x')]: string[] }|string[]")
    validate('bufnr', bufnr, 'number', true, 'integer')

    bufnr = bufnr or nil

    if vim.tbl_isemyty(K) then
        return
    end

    ---@type table<('n'|'i'|'v'|'t'|'o'|'x'), nil[]>
    local ditched_keys = {}

    for k, v in next, K do
        local isarr = is_int(k)

        if isarr then
            Keymaps.delete(v, bufnr)
        end

        if bufnr ~= nil then
            vim.keymap.del(k, v, { buffer = bufnr })
        else
            vim.keymap.del(k, v, {})
        end

        ditched_keys[k][v] = nil
    end

    return ditched_keys
end

---@type table|User.Config.Keymaps|fun(keys: AllModeMaps, bufnr?: integer, load_defaults?: boolean)
local M = setmetatable({}, {
    __index = Keymaps,

    __newindex = function(_, _, _)
        error('User.Config.Keymaps table is Read-Only!', ERROR)
    end,

    ---@param keys AllModeMaps
    ---@param bufnr? integer
    ---@param load_defaults? boolean
    __call = function(_, keys, bufnr, load_defaults)
        validate('keys', keys, 'table', false, 'AllModeMaps')
        validate('bufnr', bufnr, 'number', true, 'integer')
        validate('load_defaults', load_defaults, 'boolean', true)

        if vim.tbl_isempty(keys) then
            return
        end

        local MODES = require('user_api.maps').modes
        local insp = vim.inspect

        if not vim.g.leader_set then
            vim.notify('`keymaps.set_leader()` not called!', WARN)
        end

        bufnr = bufnr or nil
        load_defaults = load_defaults ~= nil and load_defaults or false

        ---@type AllModeMaps
        local parsed_keys = {}

        for k, v in pairs(keys) do
            if not in_tbl(MODES, k) then
                vim.notify(fmt('Ignoring badly formatted table\n`%s`', insp(keys)), WARN)
            else
                parsed_keys[k] = v
            end
        end

        if Keymaps.no_oped == nil then
            Keymaps.no_oped = false
        end

        -- Noop keys after `<leader>` to avoid accidents
        for _, mode in ipairs(MODES) do
            if Keymaps.no_oped then
                break
            end

            if in_tbl({ 'n', 'v' }, mode) then
                nop(NOP, { noremap = false, silent = true }, mode, '<leader>')
            end
        end

        Keymaps.no_oped = true

        ---@type AllModeMaps
        Keymaps.Keys = d_extend('keep', parsed_keys, copy(Keymaps.Keys))

        local Keys = load_defaults and Keymaps.Keys or parsed_keys

        map_dict(Keys, 'wk.register', true, nil, bufnr)
    end,
})

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
