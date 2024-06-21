---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.telescope
local kmap = User.maps.kmap
local WK = User.maps.wk

local is_nil = Check.value.is_nil
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local desc = kmap.desc

if not exists('telescope') then
    return
end

local in_tbl = vim.tbl_contains
local empty = vim.tbl_isempty
local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local Telescope = require('telescope')
local Builtin = require('telescope.builtin')
local Themes = require('telescope.themes')
local Actions = require('telescope.actions')
local ActionLayout = require('telescope.actions.layout')
local Extensions = Telescope.extensions

local load_ext = Telescope.load_extension

local Opts = {
    defaults = {
        layout_strategy = 'flex',
        layout_config = {
            vertical = {
                width = math.floor(vim.opt.columns:get() * 3 / 4),
            },
        },
        mappings = {
            i = {
                ['<C-h>'] = 'which_key',
                ['<C-u>'] = false,
                ['<C-d>'] = Actions.delete_buffer + Actions.move_to_top,
                ['<Esc>'] = Actions.close,
                ['<C-e>'] = Actions.close,
                ['<C-q>'] = Actions.close,
            },
            n = {},
        },
    },

    extensions = {},

    pickers = {
        colorscheme = { theme = 'dropdown' },
        find_files = { theme = 'dropdown' },
        lsp_definitions = { theme = 'dropdown' },
        pickers = { theme = 'dropdown' },
    },
}

if exists('trouble') then
    local open_with_trouble = require('trouble.sources.telescope').open

    -- Use this to add more results without clearing the trouble list
    local add_to_trouble = require('trouble.sources.telescope').add

    Opts.defaults.mappings.i['<C-t>'] = open_with_trouble
    Opts.defaults.mappings.n['<C-t>'] = open_with_trouble
end

if exists('lazy_cfg.telescope.file_browser') then
    Opts.extensions.file_browser = require('lazy_cfg.telescope.file_browser')
end

Telescope.setup(Opts)
if exists('telescope._extensions.file_browser') then
    load_ext('file_browser')
end

local function open()
    vim.cmd('Telescope')
end

---@type table<MapModes, KeyMapDict>
local Maps = {
    n = {
        ['<leader><leader>'] = { open, desc('Open Telescope') },
        ['<leader>ff'] = { Builtin.find_files, desc('Telescope File Picker') },
        ['<leader>hH'] = { Builtin.help_tags, desc('Telescope Help Tags') },
        ['<leader>lD'] = { Builtin.lsp_document_symbols, desc('Telescope Document Symbols') },
        ['<leader>ld'] = { Builtin.lsp_definitions, desc('Telescope Definitions') },
        ['<leader>vcc'] = { Builtin.colorscheme, desc('Telescope Colorschemes') },

        ['<leader>fTbC'] = { Builtin.commands, desc('Colommands') },
        ['<leader>fTbO'] = { Builtin.keymaps, desc('Vim Options') },
        ['<leader>fTbP'] = { Builtin.planets, desc('Planets') },
        ['<leader>fTbb'] = { Builtin.buffers, desc('Buffers') },
        ['<leader>fTbd'] = { Builtin.diagnostics, desc('Diagnostics') },
        ['<leader>fTbg'] = { Builtin.live_grep, desc('Live Grep') },
        ['<leader>fTbk'] = { Builtin.keymaps, desc('Keymaps') },
        ['<leader>fTbp'] = { Builtin.pickers, desc('Pickers') },
    },
}

---@type table<MapModes, RegKeysNamed>
local Names = {
    n = {
        ['<leader>fT'] = { name = '+Telescope' },
        ['<leader>fTb'] = { name = '+Builtins' },
        ['<leader>fTe'] = { name = '+Extensions' },
    },
}

---@type table<string, TelExtension>
local known_exts = {
    ['scope'] = { 'scope' },
    ['project_nvim'] = {
        'projects',
        ---@type fun(): KeyMapDict
        keys = function()
            if is_nil(Extensions.projects) then
                return {}
            end

            local pfx = Extensions.projects

            ---@type KeyMapDict
            local res = {
                ['<leader>fTep'] = { pfx.projects, desc('Project Picker') },
            }

            return res
        end,
    },
    ['notify'] = {
        'notify',
        ---@type fun(): KeyMapDict
        keys = exists('notify') and function()
            local pfx = Extensions.notify

            ---@type KeyMapDict
            local res = {
                ['<leader>fTeN'] = { pfx.notify, desc('Notify Picker') },
            }

            return res
        end,
    },
    ['noice'] = {
        'noice',
        ---@type fun(): KeyMapDict
        keys = function()
            local Noice = require('noice')

            ---@type KeyMapDict
            local res = {
                ['<leader>fTenl'] = {
                    function()
                        Noice.cmd('last')
                    end,
                    desc('NoiceLast'),
                },
                ['<leader>fTenh'] = {
                    function()
                        Noice.cmd('history')
                    end,
                    desc('NoiceHistory'),
                },
            }

            if is_tbl(Names['n']) then
                Names['n']['<leader>fTen'] = { name = '+Noice' }
            end

            return res
        end,
    },
}

--- Load and Set Keymaps for available extensions.
for mod, ext in next, known_exts do
    if not (exists(mod) and is_str(ext[1])) then
        goto continue
    end

    load_ext(ext[1])

    if is_fun(ext.keys) then
        for lhs, v in next, ext.keys() do
            for mode, _ in next, Maps do
                Maps[mode][lhs] = v
            end
        end
    end

    ::continue::
end

for mode, t in next, Maps do
    if WK.available() then
        if is_tbl(Names[mode]) and not empty(Names[mode]) then
            WK.register(Names[mode], { mode = mode })
        end

        WK.register(WK.convert_dict(t), { mode = mode })
    else
        for lhs, v in next, t do
            v[2] = is_tbl(v[2]) and v[2] or {}

            kmap[mode](lhs, v[1], v[2])
        end
    end
end

---@type AuRepeat
local au_tbl = {
    ['User'] = {
        {
            pattern = 'TelescopePreviewerLoaded',

            ---@type fun(args: TelAuArgs)
            callback = function(args)
                if not (is_tbl(args.data) and is_str(args.data.filetype) and args.data.filetype == 'help') then
                    vim.wo.number = true
                else
                    vim.wo.wrap = false
                end
            end,
        },
    },
}

for event, v in next, au_tbl do
    for _, au_opts in next, v do
        au(event, au_opts)
    end
end
