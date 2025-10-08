---@class TelAuData
---@field title string
---@field filetype string
---@field bufname string

---@class TelAuArgs
---@field data? TelAuData

---@class TelExtension
---@field [1] string
---@field keys? AllMaps

local floor = math.floor

local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local Keymaps = require('user_api.config.keymaps')
local desc = User.maps.desc

if not exists('telescope') then
    return
end

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local Telescope = require('telescope')
local Actions = require('telescope.actions')
local ActionsLayout = require('telescope.actions.layout')
local Config = require('telescope.config')

local vimgrep_arguments = { unpack(Config.values.vimgrep_arguments) }
local extra_args = { '--hidden', '--glob', '!**/.git/*', '!**/.ropeproject/*', '!**/.mypy_cache/*' }

for _, arg in next, extra_args do
    table.insert(vimgrep_arguments, arg)
end

local Opts = {
    defaults = {
        layout_strategy = 'flex',
        layout_config = {
            vertical = {
                width = floor(vim.o.columns * 3 / 4),
                height = floor(vim.o.lines * 4 / 5),
            },
            horizontal = {
                width = floor(vim.o.columns * 4 / 5),
                height = floor(vim.o.lines * 3 / 4),
            },
        },
        mappings = {
            i = {
                ['<C-h>'] = 'which_key',
                ['<C-?>'] = 'which_key',
                ['<C-u>'] = false, -- Clear prompt
                ['<C-d>'] = Actions.delete_buffer + Actions.move_to_top,
                ['<Esc>'] = Actions.close,
                ['<C-e>'] = Actions.close,
                ['<C-q>'] = Actions.close,
                ['<C-s>'] = Actions.cycle_previewers_next,
                ['<C-a>'] = Actions.cycle_previewers_prev,
                ['<M-p>'] = ActionsLayout.toggle_preview,
            },
            n = { ['<M-p>'] = ActionsLayout.toggle_preview },
        },
        vimgrep_arguments = vimgrep_arguments,
        preview = { filesize_limit = 0.75 },
    },
    extensions = {
        persisted = { layout_config = { width = 0.75, height = 0.75 } },
        projects = { prompt_prefix = '󱎸  ' },
        undo = {
            use_delta = true,
            use_custom_command = nil,
            side_by_side = true,
            layout_strategy = 'vertical',
            layout_config = { preview_height = 0.8 },
            vim_diff_opts = { ctxlen = vim.o.scrolloff },
            entry_format = 'state #$ID, $STAT, $TIME',
            time_format = '',
            saved_only = false,
            mappings = {
                i = {
                    ['<CR>'] = require('telescope-undo.actions').yank_additions,
                    ['<S-CR>'] = require('telescope-undo.actions').yank_deletions,
                    ['<C-CR>'] = require('telescope-undo.actions').restore,
                    ['<C-y>'] = require('telescope-undo.actions').yank_deletions,
                    ['<C-r>'] = require('telescope-undo.actions').restore,
                },
                n = {
                    y = require('telescope-undo.actions').yank_additions,
                    Y = require('telescope-undo.actions').yank_deletions,
                    u = require('telescope-undo.actions').restore,
                },
            },
        },
    },

    pickers = {
        autocommands = { theme = 'dropdown' },
        buffers = { theme = 'dropdown' },
        colorscheme = { theme = 'dropdown' },
        commands = { theme = 'ivy' },
        current_buffer_fuzzy_find = { theme = 'cursor' },
        fd = { theme = 'ivy' },
        find_files = {
            theme = 'ivy',
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
        },
        git_branches = { theme = 'dropdown' },
        git_status = { theme = 'dropdown' },
        git_stash = { theme = 'dropdown' },
        highlights = { theme = 'dropdown' },
        lsp_definitions = { theme = 'cursor' },
        lsp_document_symbols = { theme = 'cursor' },
        lsp_implementations = { theme = 'cursor' },
        lsp_type_definitions = { theme = 'cursor' },
        lsp_workspace_symbols = { theme = 'cursor' },
        man_pages = { theme = 'dropdown' },
        pickers = { theme = 'ivy' },
        planets = { theme = 'ivy' },
        vim_options = { theme = 'ivy' },
    },
}
if exists('trouble.sources.telescope') then
    local pfx = require('trouble.sources.telescope')
    local open_with_trouble = pfx.open
    Opts.defaults.mappings.i['<C-T>'] = open_with_trouble
    Opts.defaults.mappings.n['<C-T>'] = open_with_trouble
end
if exists('plugin.telescope.file_browser') then
    local pfx = require('plugin.telescope.file_browser')
    if pfx then
        Opts.extensions.file_browser = pfx.file_browser
        pfx.loadkeys()
    end
end
if exists('plugin.telescope.cc') then
    local pfx = require('plugin.telescope.cc')
    if pfx then
        Opts.extensions.conventional_commits = pfx.cc
        pfx.loadkeys()
    end
end
if exists('plugin.telescope.tabs') then
    local pfx = require('plugin.telescope.tabs')
    if pfx then
        pfx.create()
        pfx.loadkeys()
    end
end

Telescope.setup(Opts)

local function load_ext(name) ---@param name string
    Telescope.load_extension(name)
    -- Make sure `picker_list` doesn't load itself
    if name == 'picker_list' then
        _G.telescope_picker_list_loaded = true
        return
    end
    -- If `picker_list` is loaded, also register extension with it
    if exists('telescope._extensions.picker_list.main') then
        require('telescope._extensions.picker_list.main').register(name)
    end
end

---@type AllMaps
local Keys = {
    ['<leader><C-t>'] = { group = '+Telescope' },
    ['<leader><C-t>b'] = { group = '+Builtins' },
    ['<leader><C-t>e'] = { group = '+Extensions' },
    ['<leader><leader>'] = {
        '<CMD>Telescope<CR>',
        desc('Default Telescope Picker', true, nil, false),
    },
    ['<leader>HH'] = { '<CMD>Telescope help_tags<CR>', desc('Telescope Help Tags') },
    ['<leader>HM'] = { '<CMD>Telescope man_pages<CR>', desc('Telescope Man Pages') },
    ['<leader>GB'] = { '<CMD>Telescope git_branches<CR>', desc('Telescope Git Branches') },
    ['<leader>GS'] = { '<CMD>Telescope git_stash<CR>', desc('Telescope Git Stash') },
    ['<leader>Gs'] = { '<CMD>Telescope git_status<CR>', desc('Telescope Git Status') },
    ['<leader>bB'] = { '<CMD>Telescope buffers<CR>', desc('Telescope Buffers') },
    ['<leader>fD'] = { '<CMD>Telescope diagnostics<CR>', desc('Telescope Diagnostics') },
    ['<leader>ff'] = { '<CMD>Telescope find_files<CR>', desc('Telescope File Picker') },
    ['<leader>lD'] = {
        '<CMD>Telescope lsp_document_symbols<CR>',
        desc('Telescope Document Symbols'),
    },
    ['<leader>lT'] = { '<CMD>Telescope lsp_type_definitions<CR>', desc('Telescope Definitions') },
    ['<leader>ld'] = { '<CMD>Telescope lsp_definitions<CR>', desc('Telescope Definitions') },
    ['<leader>li'] = {
        '<CMD>Telescope lsp_implementations<CR>',
        desc('Telelcope Lsp Implementations'),
    },
    ['<leader>lwD'] = {
        '<CMD>Telescope lsp_dynamic_workspace_symbols<CR>',
        desc('Telescope Dynamic Workspace Symbols'),
    },
    ['<leader>lwd'] = {
        '<CMD>Telescope lsp_workspace_symbols<CR>',
        desc('Telescope Workspace Symbols'),
    },
    ['<leader>vK'] = { '<CMD>Telescope keymaps<CR>', desc('Telescope Keymaps') },
    ['<leader>vO'] = { '<CMD>Telescope vim_options<CR>', desc('Telescope Vim Options') },
    ['<leader>uC'] = { '<CMD>Telescope colorscheme<CR>', desc('Telescope Colorschemes') },
    ['<leader><C-t>b/'] = {
        '<CMD>Telescope current_buffer_fuzzy_find<CR>',
        desc('Buffer Fuzzy-Find'),
    },
    ['<leader><C-t>bA'] = { '<CMD>Telescope autocommands<CR>', desc('Autocommands') },
    ['<leader><C-t>bC'] = { '<CMD>Telescope commands<CR>', desc('Commands') },
    ['<leader><C-t>bg'] = { '<CMD>Telescope live_grep<CR>', desc('Live Grep') },
    ['<leader><C-t>bh'] = { '<CMD>Telescope highlights<CR>', desc('Highlights') },
    ['<leader><C-t>bp'] = { '<CMD>Telescope pickers<CR>', desc('Pickers') },
}

---@type table<string, TelExtension>
local known_exts = {
    ['telescope._extensions.file_browser'] = { 'file_browser' },
    ['telescope._extensions.undo'] = {
        'undo',
        keys = {
            ['<leader><C-t>eu'] = { '<CMD>Telescope undo<CR>', desc('Undo Picker') },
            ['<leader>fu'] = { '<CMD>Telescope undo<CR>', desc('Undo Telescope Picker') },
        },
    },
    ['plugin.telescope.cc'] = {
        'conventional_commits',
        keys = {
            ['<leader><C-t>eC'] = {
                '<CMD>Telescope conventional_commits<CR>',
                desc('Conventional Commits'),
            },
            ['<leader>GC'] = {
                '<CMD>Telescope conventional_commits<CR>',
                desc('Conventional Commits Telescope Picker'),
            },
        },
    },
    scope = {
        'scope',
        keys = {
            ['<leader>S'] = { group = '+Scope' },
            ['<leader><C-t>eS'] = { '<CMD>Telescope buffers<CR>', desc('Scope Buffers Picker') },
            ['<leader>Sb'] = { '<CMD>Telescope buffers<CR>', desc('Scope Buffers (Telescope)') },
        },
    },
    persisted = {
        'persisted',
        keys = {
            ['<leader><C-t>ef'] = { '<CMD>Telescope persisted<CR>', desc('Persisted Picker') },
        },
    },
    ['telescope-makefile'] = {
        'make',
        keys = {
            ['<leader>fM'] = { group = '+Make' },
            ['<leader><C-t>eM'] = { '<CMD>Telescope make<CR>', desc('Makefile Picker') },
            ['<leader>fMT'] = { '<CMD>Telescope make<CR>', desc('Makefile Telescope Picker') },
        },
    },
    aerial = {
        'aerial',
        keys = {
            ['<leader><C-t>ea'] = { '<CMD>Telescope aerial<CR>', desc('Aerial Picker') },
            ['<leader>laT'] = { '<CMD>Telescope aerial<CR>', desc('Aerial Telescope Picker') },
        },
    },
    ['telescope._extensions.projects'] = {
        'projects',
        keys = {
            ['<leader><C-t>ep'] = { '<CMD>Telescope projects<CR>', desc('Project Picker') },
            ['<leader>pT'] = { '<CMD>Telescope projects<CR>', desc('Project Telescope Picker') },
        },
    },
    notify = {
        'notify',
        keys = {
            ['<leader>N'] = { group = '+Notify' },
            ['<leader>NT'] = { '<CMD>Telescope notify<CR>', desc('Notify Telescope Picker') },
            ['<leader><C-t>eN'] = { '<CMD>Telescope notify<CR>', desc('Notify Picker') },
        },
    },
    noice = {
        'noice',
        keys = {
            ['<leader><C-t>en'] = { group = '+Noice' },
            ['<leader><C-t>enl'] = {
                function()
                    require('noice').cmd('last')
                end,
                desc('NoiceLast'),
            },
            ['<leader><C-t>enh'] = {
                function()
                    require('noice').cmd('history')
                end,
                desc('NoiceHistory'),
            },
        },
    },
    ['lazygit.utils'] = {
        'lazygit',
        keys = {
            ['<leader><C-t>eG'] = { '<CMD>Telescope lazygit<CR>', desc('LazyGit Picker') },
            ['<leader>GlT'] = { '<CMD>Telescope lazygit<CR>', desc('LazyGit Telescope Picker') },
        },
    },
    ['telescope._extensions.picker_list'] = {
        'picker_list',
        keys = {
            ['<leader><C-t>eP'] = { '<CMD>Telescope picker_list<CR>', desc('Picker List') },
            ['<leader><C-t>bp'] = {
                '<CMD>Telescope picker_list<CR>',
                desc('Picker List (Extension)'),
            },
            ['<leader><leader>'] = {
                '<CMD>Telescope picker_list<CR>',
                desc('Telescope Picker List'),
            },
        },
    },
}
for mod, ext in next, known_exts do
    local extension = ext[1] or ''
    if exists(mod) and extension ~= '' then
        load_ext(extension)
        if ext.keys then
            for lhs, v in pairs(ext.keys) do
                Keys[lhs] = v
            end
        end
    end
end
Keymaps({ n = Keys })

au('User', {
    group = augroup('UserTelescope', { clear = true }),
    pattern = 'TelescopePreviewerLoaded',
    callback = function(ev)
        local wo = vim.wo[vim.api.nvim_get_current_win()]
        if ev.data.filetype ~= 'help' then
            wo.number = true
        elseif ev.data.bufname:match('*.csv') then
            wo.wrap = false
        end
    end,
})
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
