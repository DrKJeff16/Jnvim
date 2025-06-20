---@diagnostic disable:need-check-nil

---@module 'user_api.types.telescope'

local User = require('user_api')
local Check = User.check

local is_nil = Check.value.is_nil
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local is_tbl = Check.value.is_tbl
local type_not_empty = Check.value.type_not_empty
local exists = Check.exists.module
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict
local wk_avail = User.maps.wk.available

if not exists('telescope') then
    return
end

User:register_plugin('plugin.telescope')

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local Telescope = require('telescope')
local Actions = require('telescope.actions')
local ActionsLayout = require('telescope.actions.layout')
local Builtin = require('telescope.builtin')
local Config = require('telescope.config')
local Themes = require('telescope.themes')

-- Clone the default Telescope configuration
local vimgrep_arguments = { (unpack or table.unpack)(Config.values.vimgrep_arguments) }
local extra_args = {
    -- Search in hidden/dot files
    '--hidden',
    -- Don't search in these hidden directories
    '--glob',
    '!**/.git/*',
    '!**/.ropeproject/*',
    '!**/.mypy_cache/*',
}

for _, arg in next, extra_args do
    table.insert(vimgrep_arguments, arg)
end

local Opts = {
    defaults = {
        layout_strategy = 'flex',
        layout_config = {
            vertical = {
                width = math.floor(vim.opt.columns:get() * 3 / 4),
                height = math.floor(vim.opt.lines:get() * 3 / 5),
            },
        },

        mappings = {
            i = {
                ['<C-h>'] = 'which_key',
                ['<C-u>'] = false, --- Clear prompt
                ['<C-d>'] = Actions.delete_buffer + Actions.move_to_top,
                ['<Esc>'] = Actions.close,
                ['<C-e>'] = Actions.close,
                ['<C-q>'] = Actions.close,
                ['<C-s>'] = Actions.cycle_previewers_next,
                ['<C-a>'] = Actions.cycle_previewers_prev,
                ['<M-p>'] = ActionsLayout.toggle_preview,
            },
            n = {
                ['<M-p>'] = ActionsLayout.toggle_preview,
            },
        },

        vimgrep_arguments = vimgrep_arguments,

        preview = {
            filesize_limit = 0.75, -- MB
        },
    },

    extensions = {},

    pickers = {
        autocommands = { theme = 'ivy' },
        buffers = { theme = 'dropdown' },
        colorscheme = { theme = 'dropdown' },
        commands = { theme = 'ivy' },
        current_buffer_fuzzy_find = { theme = 'cursor' },
        fd = { theme = 'dropdown' },
        find_files = {
            theme = 'dropdown',
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`'d
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
        },
        git_branches = { theme = 'ivy' },
        git_status = { theme = 'dropdown' },
        git_stash = { theme = 'dropdown' },
        highlights = { theme = 'dropdown' },
        lsp_definitions = { theme = 'dropdown' },
        lsp_document_symbols = { theme = 'dropdown' },
        lsp_implementations = { theme = 'dropdown' },
        lsp_type_definitions = { theme = 'dropdown' },
        lsp_workspace_symbols = { theme = 'dropdown' },
        man_pages = { theme = 'dropdown' },
        pickers = { theme = 'dropdown' },
        picker_list = { theme = 'dropdown' },
        planets = { theme = 'dropdown' },
        vim_options = { theme = 'ivy' },
    },
}

if exists('telescope._extensions.picker_list') then
    Opts.extensions.picker_list = {
        theme = 'dropdown',
        opts = {
            projects = { display_type = 'full' },
            project = { display_type = 'full' },
            notify = Themes.get_dropdown({}),
        },

        excluded_pickers = {
            'fzf',
            'fd',
            'live_grep',
        },

        user_pickers = {
            'todo-comments',
            function() vim.cmd('TodoTelescope theme=dropdown') end,
        },
    }
end

if exists('trouble.sources.telescope') then
    local pfx = require('trouble.sources.telescope')

    local open_with_trouble = pfx.open
    -- Use this to add more results without clearing the trouble list

    Opts.defaults.mappings.i['<C-T>'] = open_with_trouble
    Opts.defaults.mappings.n['<C-T>'] = open_with_trouble
end

if exists('plugin.telescope.file_browser') then
    local pfx = require('plugin.telescope.file_browser')

    if not is_nil(pfx) then
        Opts.extensions.file_browser = pfx.file_browser
        pfx.loadkeys()
    end
end

if exists('persisted') then
    Opts.extensions.persisted = {
        layout_config = { width = 0.75, height = 0.75 },
    }
end

if exists('plugin.telescope.cc') then
    local pfx = require('plugin.telescope.cc')

    if not is_nil(pfx) then
        Opts.extensions.conventional_commits = pfx.cc
        pfx.loadkeys()
    end
end

Telescope.setup(Opts)

---@param name string
local load_ext = function(name)
    Telescope.load_extension(name)

    -- Make sure `picker_list` doesn't load itself
    if name == 'picker_list' then
        _G.telescope_picker_list_loaded = true
        return
    end

    -- If `picker_list` is loaded, also register extension with it
    if telescope_picker_list_loaded then
        require('telescope._extensions.picker_list.main').register(name)
    end
end

---@type AllMaps
local Keys = {
    ['<leader><leader>'] = { function() vim.cmd('Telescope') end, desc('Open Telescope') },
    ['<leader>HH'] = { Builtin.help_tags, desc('Telescope Help Tags') },
    ['<leader>HM'] = { Builtin.man_pages, desc('Telescope Man Pages') },
    ['<leader>GB'] = { Builtin.git_branches, desc('Telescope Git Branches') },
    ['<leader>GS'] = { Builtin.git_stash, desc('Telescope Git Stash') },
    ['<leader>Gs'] = { Builtin.git_status, desc('Telescope Git Status') },
    ['<leader>bB'] = { Builtin.buffers, desc('Telescope Buffers') },
    ['<leader>fD'] = { Builtin.diagnostics, desc('Telescope Diagnostics') },
    ['<leader>ff'] = { Builtin.find_files, desc('Telescope File Picker') },
    ['<leader>lD'] = { Builtin.lsp_document_symbols, desc('Telescope Document Symbols') },
    ['<leader>lT'] = { Builtin.lsp_type_definitions, desc('Telescope Definitions') },
    ['<leader>ld'] = { Builtin.lsp_definitions, desc('Telescope Definitions') },
    ['<leader>li'] = { Builtin.lsp_implementations, desc('Telelcope Lsp Implementations') },
    ['<leader>lwD'] = {
        Builtin.lsp_dynamic_workspace_symbols,
        desc('Telescope Dynamic Workspace Symbols'),
    },
    ['<leader>lwd'] = { Builtin.lsp_workspace_symbols, desc('Telescope Workspace Symbols') },
    ['<leader>vC'] = { Builtin.highlights, desc('Telescope Highlights') },
    ['<leader>vK'] = { Builtin.keymaps, desc('Telescope Keymaps') },
    ['<leader>vO'] = { Builtin.vim_options, desc('Telescope Vim Options') },
    ['<leader>vcC'] = { Builtin.colorscheme, desc('Telescope Colorschemes') },

    ['<leader>fTb/'] = { Builtin.current_buffer_fuzzy_find, desc('Buffer Fuzzy-Find') },
    ['<leader>fTbA'] = { Builtin.autocommands, desc('Autocommands') },
    ['<leader>fTbC'] = { Builtin.commands, desc('Commands') },
    ['<leader>fTbg'] = { Builtin.live_grep, desc('Live Grep') },
    ['<leader>fTbh'] = { Builtin.highlights, desc('Highlights') },
    ['<leader>fTbp'] = { Builtin.pickers, desc('Pickers') },
}

---@type RegKeysNamed
local Names = {
    ['<leader>fT'] = { group = '+Telescope' },
    ['<leader>fTb'] = { group = '+Builtins' },
    ['<leader>fTe'] = { group = '+Extensions' },
}

local Extensions = Telescope.extensions

---@type table<string, TelExtension>
local known_exts = {
    ['telescope._extensions.file_browser'] = { 'file_browser' },
    ['plugin.telescope.cc'] = {
        'conventional_commits',

        ---@return AllMaps
        function()
            if not type_not_empty('table', Extensions.conventional_commits) then
                return {}
            end

            local pfx = Extensions.conventional_commits

            return {
                ['<leader>fTeC'] = { pfx.conventional_commits, desc('Scope Buffers Picker') },
            }
        end,
    },
    scope = {
        'scope',

        ---@return AllMaps
        function()
            if not type_not_empty('table', Extensions.scope) then
                return {}
            end

            local pfx = Extensions.scope

            return {
                ['<leader>fTeS'] = { pfx.buffers, desc('Scope Buffers Picker') },
            }
        end,
    },
    persisted = {
        'persisted',

        ---@return table|AllMaps
        keys = function()
            if not type_not_empty('table', Extensions.persisted) then
                return {}
            end

            local pfx = Extensions.persisted

            return {
                ['<leader>fTef'] = { pfx.persisted, desc('Persisted Picker') },
            }
        end,
    },
    ['telescope-makefile'] = {
        'make',

        ---@return table|AllMaps
        keys = function()
            if not type_not_empty('table', Extensions.make) then
                return {}
            end

            local pfx = Extensions.make

            return {
                ['<leader>fTeM'] = { pfx.make, desc('Makefile Picker') },
            }
        end,
    },
    project_nvim = {
        'projects',

        ---@return table|AllMaps
        keys = function()
            if not type_not_empty('table', Extensions.projects) then
                return {}
            end

            local pfx = Extensions.projects

            return {
                ['<leader>fTep'] = { pfx.projects, desc('Project Picker') },
            }
        end,
    },
    notify = {
        'notify',

        ---@return table|AllMaps
        keys = function()
            if not type_not_empty('table', Extensions.notify) then
                return {}
            end

            local pfx = Extensions.notify

            return {
                ['<leader>fTeN'] = { pfx.notify, desc('Notify Picker') },
            }
        end,
    },
    noice = {
        'noice',

        ---@return table|AllMaps
        keys = function()
            ---@type AllMaps
            local res = {
                ['<leader>fTenl'] = {
                    function() require('noice').cmd('last') end,
                    desc('NoiceLast'),
                },
                ['<leader>fTenh'] = {
                    function() require('noice').cmd('history') end,
                    desc('NoiceHistory'),
                },
            }

            if require('user_api.maps.wk').available() and type_not_empty('table', Names) then
                Names['<leader>fTen'] = { group = '+Noice' }
            end

            return res
        end,
    },
    ['lazygit.utils'] = {
        'lazygit',

        ---@return table|AllMaps
        keys = function()
            if not type_not_empty('table', Extensions.lazygit) then
                return {}
            end

            local pfx = Extensions.lazygit

            ---@type AllMaps
            local res = {
                ['<leader>fTeG'] = { pfx.lazygit, desc('LazyGit Picker') },
            }

            return res
        end,
    },

    -- WARN: MUST BE LAST IN THIS LIST
    ['telescope-picker-list'] = {
        'picker_list',

        ---@return table|AllMaps
        keys = function()
            if not type_not_empty('table', Extensions.picker_list) then
                return {}
            end

            local pfx = Extensions.picker_list

            return {
                ['<leader>fTeP'] = { pfx.picker_list, desc('Picker List') },
                ['<leader>fTbp'] = { pfx.picker_list, desc('Picker List (Extension)') },
                ['<leader><leader>'] = { pfx.picker_list, desc('Telescope Picker List') },
            }
        end,
    },
}

--- Load and Set Keymaps for available extensions
for mod, ext in next, known_exts do
    -- If extension is unavailable/invalid
    if not (exists(mod) and is_str(ext[1])) then
        goto continue
    end

    load_ext(ext[1])

    if is_fun(ext.keys) then
        for lhs, v in next, ext.keys() do
            Keys[lhs] = v
        end
    end

    ::continue::
end

if wk_avail() then
    map_dict(Names, 'wk.register', false, 'n')
end
map_dict(Keys, 'wk.register', false, 'n')

local group = augroup('UserTelescope', { clear = false })

---@type AuRepeat
local au_tbl = {
    ['User'] = {
        {
            pattern = 'TelescopePreviewerLoaded',
            group = group,

            ---@param args TelAuArgs
            callback = function(args)
                if
                    not (
                        is_tbl(args.data)
                        and is_str(args.data.filetype)
                        and args.data.filetype == 'help'
                    )
                then
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

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
