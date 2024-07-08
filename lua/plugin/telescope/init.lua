---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local types = User.types.telescope
local WK = User.maps.wk

local is_nil = Check.value.is_nil
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local exists = Check.exists.module
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

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
        autocommands = { theme = 'ivy' },
        buffers = { theme = 'dropdown' },
        colorscheme = { theme = 'ivy' },
        commands = { theme = 'ivy' },
        current_buffer_fuzzy_find = { theme = 'cursor' },
        find_files = { theme = 'dropdown' },
        git_branches = { theme = 'ivy' },
        git_status = { theme = 'dropdown' },
        git_stash = { theme = 'dropdown' },
        highlights = { theme = 'ivy' },
        lsp_definitions = { theme = 'cursor' },
        lsp_document_symbols = { theme = 'dropdown' },
        lsp_implementations = { theme = 'cursor' },
        lsp_type_definitions = { theme = 'cursor' },
        lsp_workspace_symbols = { theme = 'dropdown' },
        man_pages = { theme = 'dropdown' },
        pickers = { theme = 'ivy' },
        planets = { theme = 'dropdown' },
        reloader = { theme = 'dropdown' },
        vim_options = { theme = 'ivy' },
    },
}

if exists('trouble') then
    local open_with_trouble = require('trouble.sources.telescope').open

    -- Use this to add more results without clearing the trouble list
    local add_to_trouble = require('trouble.sources.telescope').add

    Opts.defaults.mappings.i['<C-T>'] = open_with_trouble
    Opts.defaults.mappings.n['<C-T>'] = open_with_trouble
end

if Check.exists.modules({ 'plugin.telescope.file_browser' }) then
    Opts.extensions.file_browser = require('plugin.telescope.file_browser').file_browser
    require('plugin.telescope.file_browser').loadkeys()
end

if exists('persisted') then
    Opts.extensions.persisted = {
        layout_config = { width = 0.6, height = 0.6 },
    }
end

Telescope.setup(Opts)

if exists('telescope._extensions.file_browser') then
    load_ext('file_browser')
end
if exists('persisted') then
    load_ext('persisted')
end

local function open()
    vim.cmd('Telescope')
end

---@type KeyMapDict
local Maps = {
    ['<leader>Rr'] = { Builtin.reloader, desc('Telescope Reloader') },
    ['<leader><leader>'] = { open, desc('Open Telescope') },
    ['<leader>?H'] = { Builtin.help_tags, desc('Telescope Help Tags') },
    ['<leader>?M'] = { Builtin.man_pages, desc('Telescope Man Pages') },
    ['<leader>GB'] = { Builtin.git_branches, desc('Telescope Git Branches') },
    ['<leader>Gs'] = { Builtin.git_status, desc('Telescope Git Status') },
    ['<leader>GS'] = { Builtin.git_stash, desc('Telescope Git Stash') },
    ['<leader>bB'] = { Builtin.buffers, desc('Telescope Buffers') },
    ['<leader>fD'] = { Builtin.diagnostics, desc('Telescope Diagnostics') },
    ['<leader>ff'] = { Builtin.find_files, desc('Telescope File Picker') },
    ['<leader>lD'] = { Builtin.lsp_document_symbols, desc('Telescope Document Symbols') },
    ['<leader>lT'] = { Builtin.lsp_type_definitions, desc('Telescope Definitions') },
    ['<leader>ld'] = { Builtin.lsp_definitions, desc('Telescope Definitions') },
    ['<leader>li'] = { Builtin.lsp_implementations, desc('Telelcope Lsp Implementations') },
    ['<leader>lwD'] = { Builtin.lsp_dynamic_workspace_symbols, desc('Telescope Dynamic Workspace Symbols') },
    ['<leader>lwd'] = { Builtin.lsp_workspace_symbols, desc('Telescope Workspace Symbols') },
    ['<leader>vK'] = { Builtin.keymaps, desc('Telescope Keymaps') },
    ['<leader>vO'] = { Builtin.vim_options, desc('Telescope Vim Options') },
    ['<leader>vcC'] = { Builtin.colorscheme, desc('Telescope Colorschemes') },

    ['<leader>fTb/'] = { Builtin.current_buffer_fuzzy_find, desc('Buffer Fuzzy-Find') },
    ['<leader>fTbA'] = { Builtin.autocommands, desc('Autocommands') },
    ['<leader>fTbC'] = { Builtin.commands, desc('Commands') },
    ['<leader>fTbP'] = { Builtin.planets, desc('Planets') },
    ['<leader>fTbg'] = { Builtin.live_grep, desc('Live Grep') },
    ['<leader>fTbh'] = { Builtin.highlights, desc('Highlights') },
    ['<leader>fTbp'] = { Builtin.pickers, desc('Pickers') },
}

---@type RegKeysNamed
local Names = {
    ['<leader>R'] = { name = '+Reload' },
    ['<leader>fT'] = { name = '+Telescope' },
    ['<leader>fTb'] = { name = '+Builtins' },
    ['<leader>fTe'] = { name = '+Extensions' },
}

---@type table<string, TelExtension>
local known_exts = {
    ['scope'] = { 'scope' },
    ['persisted'] = { 'persisted' },
    ['telescope-makefile'] = {
        'make',
        ---@type fun(): KeyMapDict
        keys = function()
            if is_nil(Extensions.make) then
                return {}
            end

            local pfx = Extensions.make

            return {
                ['<leader>fTeM'] = { pfx.make, desc('Makefile Picker') },
            }
        end,
    },
    ['project_nvim'] = {
        'projects',
        ---@type fun(): KeyMapDict
        keys = function()
            if is_nil(Extensions.projects) then
                return {}
            end

            local pfx = Extensions.projects

            return {
                ['<leader>fTep'] = { pfx.projects, desc('Project Picker') },
            }
        end,
    },
    ['notify'] = {
        'notify',
        ---@type fun(): KeyMapDict
        keys = function()
            local pfx = Extensions.notify

            return {
                ['<leader>fTeN'] = { pfx.notify, desc('Notify Picker') },
            }
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

            if is_tbl(Names) then
                Names['<leader>fTen'] = { name = '+Noice' }
            end

            return res
        end,
    },
    ['lazygit.utils'] = {
        'lazygit',

        ---@type fun(): KeyMapDict
        keys = function()
            if is_nil(Extensions.lazygit) then
                return {}
            end

            local pfx = Extensions.lazygit

            ---@type KeyMapDict
            local res = {
                ['<leader>fTeG'] = { pfx.lazygit, desc('LazyGit Picker') },
            }

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
            Maps[lhs] = v
        end
    end

    ::continue::
end

if WK.available() and is_tbl(Names) and not empty(Names) then
    map_dict(Names, 'wk.register', false, 'n')
end
map_dict(Maps, 'wk.register', false, 'n')

---@type AuRepeat
local au_tbl = {
    ['User'] = {
        {
            pattern = 'TelescopePreviewerLoaded',

            ---@param args TelAuArgs
            callback = function(args)
                if not (is_tbl(args.data) and is_str(args.data.filetype) and args.data.filetype == 'help') then
                    vim.wo.number = true
                elseif args.data.bufname:match('*.csv') then
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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
