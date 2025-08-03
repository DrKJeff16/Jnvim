---@diagnostic disable:missing-fields

-- Setup keymaps
-- WARNING: You must call `Keymaps:set_leader()` beforehand or this will complain
---@alias User.Config.Keymaps.CallerFun fun(keys: AllModeMaps, bufnr: integer?, load_defaults: boolean?)

---@class Keymaps.PreExec
---@field ft string[]
---@field bt string[]

_G.MYVIMRC = MYVIMRC or vim.fn.stdpath('config') .. '/init.lua'

local Value = require('user_api.check.value')

local is_tbl = Value.is_tbl
local is_int = Value.is_int
local is_bool = Value.is_bool
local type_not_empty = Value.type_not_empty
local nop = require('user_api.maps').nop
local map_dict = require('user_api.maps').map_dict
local desc = require('user_api.maps.kmap').desc
local ft_get = require('user_api.util').ft_get
local bt_get = require('user_api.util').bt_get

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN
local INFO = vim.log.levels.INFO

local copy = vim.deepcopy
local curr_buf = vim.api.nvim_get_current_buf
local in_tbl = vim.tbl_contains
local d_extend = vim.tbl_deep_extend
local optget = vim.api.nvim_get_option_value
local optset = vim.api.nvim_set_option_value

---@return fun()
local function rcfile_ed()
    return function()
        vim.cmd.edit(MYVIMRC)
    end
end

---@return fun()
local function rcfile_split()
    return function()
        vim.cmd.split(MYVIMRC)
    end
end

---@return fun()
local function rcfile_vsplit()
    return function()
        vim.cmd.vsplit(MYVIMRC)
    end
end

---@return fun()
local function rcfile_tab()
    return function()
        vim.cmd.tabnew(MYVIMRC)
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
    vertical = is_bool(vertical) and vertical or false

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
-- Global keymaps, plugin-agnostic
---@field Keys AllModeMaps
-- Set both the `<leader>` and `<localleader>` keys
-- ---
-- ## Description
-- Setup a key as `<leader>` and `<localleader>`, but you can also set `<localleader>` to
-- a different key if you want.
--
-- If `<localleader>` is not explicitly set, then it'll be set as `<leader>`
-- ---
---@field set_leader fun(leader: string, local_leader: string?, force: boolean?)
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

Keymaps.NOP = NOP

setmetatable(Keymaps.NOP, {
    __index = Keymaps.NOP,

    ---@diagnostic disable-next-line:unused-local
    __newindex = function(self, k)
        error('(user_api.config.keymaps.NOP): Read-only table!', ERROR)
    end,
})

-- Global keymaps, plugin-agnostic
Keymaps.Keys = {}

-- Normal Mode Keys
Keymaps.Keys.n = {
    ['<leader>'] = { group = '+Open `which-key`' },
    ['<leader>F'] = { group = '+Folding' },
    ['<leader>H'] = { group = '+Help' },
    ['<leader>HM'] = { group = '+Man Pages' },
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
        ':%foldclose<CR>',
        desc('Close All Folds'),
    },
    ['<leader>Fo'] = {
        ':%foldopen<CR>',
        desc('Open All Folds'),
    },

    ['<leader>fFx'] = {
        gen_fun_blank(),
        desc('New Horizontal Blank File'),
    },
    ['<leader>fFv'] = { gen_fun_blank(true), desc('New Vertical Blank File') },

    ['<leader>fs'] = {
        function()
            local notify = require('user_api.util.notify').notify

            local buf = curr_buf()

            local ok, err = true, nil

            if optget('modifiable', { buf = buf }) then
                ok, err = pcall(vim.cmd.write)

                if ok then
                    notify('File Written', INFO, {
                        title = vim.fn.expand('%'),
                        animate = true,
                        timeout = 500,
                        hide_from_history = true,
                    })

                    return
                end
            end

            notify(err or 'Unable to write', ERROR, {
                title = 'Vim Write',
                animate = true,
                timeout = 1500,
                hide_from_history = false,
            })
        end,
        desc('Save File'),
    },
    ['<leader>fS'] = {
        ':w ',
        desc('Prompt Save File', false),
    },

    ['<leader>fir'] = {
        ':%retab<CR>',
        desc('Retab File'),
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
            local notify = require('user_api.util.notify').notify

            local ft = ft_get(curr_buf())
            local ok, err = true, ''

            if ft == 'lua' then
                ---@diagnostic disable-next-line:param-type-mismatch
                ok, err = pcall(vim.cmd.luafile, '%')

                if ok then
                    notify('Sourced current Lua file', INFO, {
                        title = 'Lua',
                        animate = true,
                        timeout = 1500,
                        hide_from_history = true,
                    })

                    return
                end
            end

            notify(err, ERROR, {
                title = 'Lua',
                animate = true,
                timeout = 2000,
                hide_from_history = false,
            })
        end,
        desc('Source Current File As Lua File'),
    },
    ['<leader>fvv'] = {
        function()
            local notify = require('user_api.util.notify').notify

            local ft = ft_get(curr_buf())
            local ok, err = true, ''

            if ft == 'vim' then
                ---@diagnostic disable-next-line:param-type-mismatch
                ok, err = pcall(vim.cmd.source, '%')

                if ok then
                    notify('Sourced current Vim file', INFO, {
                        title = 'Vim',
                        animate = true,
                        timeout = 1000,
                        hide_from_history = true,
                    })

                    return
                end
            end

            notify(err, ERROR, {
                title = 'Vim',
                animate = true,
                timeout = 2000,
                hide_from_history = false,
            })
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
            local notify = require('user_api.util.notify').notify

            ---@diagnostic disable-next-line:param-type-mismatch
            local ok, err = pcall(vim.cmd.luafile, MYVIMRC)

            if ok then
                notify('Sourced `init.lua`', INFO, {
                    animate = true,
                    title = 'luafile',
                    timeout = 500,
                    hide_from_history = true,
                })

                return
            end

            notify(err, ERROR, {
                animate = true,
                title = 'luafile',
                timeout = 2500,
                hide_from_history = true,
            })
        end,
        desc('Source $MYVIMRC'),
    },

    ['<leader>HT'] = {
        function()
            vim.cmd.help()
            vim.schedule(function()
                vim.cmd.wincmd('T')
            end)
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
        desc('Prompt For Help'),
    },
    ['<leader>Ht'] = {
        ':tab h ',
        desc('Prompt For Help On New Tab'),
    },
    ['<leader>Hv'] = {
        ':vertical h ',
        desc('Prompt For Help On Vertical Split'),
    },
    ['<leader>Hx'] = {
        ':horizontal h ',
        desc('Prompt For Help On Horizontal Split'),
    },
    ['<leader>HMM'] = {
        ':Man ',
        desc('Prompt For Man'),
    },
    ['<leader>HMT'] = {
        ':tab Man ',
        desc('Prompt For Arbitrary Man Page (Tab)'),
    },
    ['<leader>HMV'] = {
        ':vert Man ',
        desc('Prompt For Arbitrary Man Page (Vertical)'),
    },
    ['<leader>HMX'] = {
        ':horizontal Man ',
        desc('Prompt For Arbitrary Man Page (Horizontal)'),
    },
    ['<leader>HMm'] = {
        ':Man<CR>',
        desc('Open Manpage For Word Under Cursor'),
    },
    ['<leader>HMt'] = {
        ':tab Man<CR>',
        desc('Open Arbitrary Man Page (Tab)'),
    },
    ['<leader>HMv'] = {
        ':vert Man<CR>',
        desc('Open Arbitrary Man Page (Vertical)'),
    },
    ['<leader>HMx'] = {
        ':horizontal Man<CR>',
        desc('Open Arbitrary Man Page (Horizontal)'),
    },

    ['<leader>wN'] = {
        function()
            local buf = curr_buf()
            local ft = ft_get(buf)

            vim.cmd.wincmd('n')
            vim.cmd.wincmd('o')

            optset('ft', ft, { buf = buf })
            optset('modifiable', true, { buf = buf })
            optset('modified', false, { buf = buf })
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
        desc('Swap Current With Next'),
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

    ['<leader>qQ'] = {
        function()
            vim.cmd.quitall({ bang = true })
        end,
        desc('Quit Nvim Forcefully'),
    },
    ['<leader>qq'] = {
        function()
            if require('user_api.check.exists').module('toggleterm') then
                local T = require('toggleterm.terminal').get_all(true)

                for _, term in next, T do
                    term:close()
                end
            end
            vim.cmd.quitall()
        end,
        desc('Quit Nvim'),
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
        function()
            pcall(vim.cmd.tabclose)
        end,
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
            vim.notify(inspect(Keymaps.Keys))
        end,
        desc('Print all custom keymaps in their respective modes'),
    },
}

-- Visual Mode Keys
Keymaps.Keys.v = {
    ['<leader>'] = { group = '+Open `which-key`' },
    ['<leader>f'] = { group = '+File' }, --- File Handling
    ['<leader>fF'] = { group = '+Folding' }, --- Folding
    ['<leader>h'] = { group = '+Help' }, --- Help
    ['<leader>i'] = { group = '+Indent' }, --- Indent Control
    ['<leader>q'] = { group = '+Quit Nvim' }, --- Exiting
    ['<leader>v'] = { group = '+Vim' }, --- Vim

    ['<leader>fFc'] = {
        ':foldopen<CR>',
        desc('Open Fold'),
    },
    ['<leader>fFo'] = {
        ':foldclose<CR>',
        desc('Close Fold'),
    },
    ['<leader>fr'] = {
        ':s/',
        desc('Search/Replace Prompt For Selection', false),
    },
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

            notify(err or 'Unable to write', ERROR, {
                animate = true,
                title = 'Vim Write',
                timeout = 2250,
                hide_from_history = false,
            })
        end,
        desc('Save File'),
    },

    ['<leader>ir'] = {
        ':retab<CR>',
        desc('Retab Selection'),
    },

    ['<leader>qQ'] = {
        ':qa!<CR>',
        desc('Quit Nvim Forcefully'),
    },
    ['<leader>qq'] = {
        vim.cmd.quitall,
        desc('Quit Nvim'),
    },
}

-- Terminal Mode Keys
Keymaps.Keys.t = {
    ['<Esc>'] = {
        '<C-\\><C-n>',
        desc('Escape Terminal'),
    },
}

---@param leader string _`<leader>`_ key string (defaults to `<Space>`)
---@param local_leader? string _`<localleader>`_ string (defaults to `<Space>`)
---@param force? boolean Force leader switch (defaults to `false`)
function Keymaps.set_leader(leader, local_leader, force)
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

    ---@operator call: fun(keys: AllModeMaps, bufnr: integer?, load_defaults: boolean?)
    return setmetatable(O, {
        __index = Keymaps,

        ---@param self User.Config.Keymaps
        ---@param keys AllModeMaps
        ---@param bufnr? integer
        ---@param load_defaults? boolean
        __call = function(self, keys, bufnr, load_defaults)
            local MODES = require('user_api.maps').modes
            local insp = inspect or vim.inspect

            local notify = require('user_api.util.notify').notify

            if not leader_set then
                notify('`keymaps.set_leader()` not called!', WARN, {
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
                        string.format('Ignoring badly formatted table\n`%s`', insp(keys)),
                        WARN,
                        {
                            title = '(user_api.config.keymaps())',
                            animate = true,
                            timeout = 1750,
                            hide_from_history = false,
                        }
                    )
                else
                    parsed_keys[k] = v
                end
            end

            self.no_oped = is_bool(self.no_oped) and self.no_oped or false

            -- Noop keys after `<leader>` to avoid accidents
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
            local res = load_defaults and d_extend('keep', parsed_keys, self.Keys) or parsed_keys

            map_dict(res, 'wk.register', true, nil, bufnr or nil)

            self.Keys = d_extend('keep', copy(self.Keys), parsed_keys)
        end,
    })
end

return Keymaps.new()

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
