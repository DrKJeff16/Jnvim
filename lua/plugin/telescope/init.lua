---@diagnostic disable:need-check-nil

---@class KeyMapArgs
---@field lhs string
---@field rhs string|fun()
---@field opts? User.Maps.Keymap.Opts

---@class TelAuData
---@field title string
---@field filetype string
---@field bufname string

---@class TelAuArgs
---@field data? TelAuData

---@class TelExtension
---@field [1] string
---@field keys? fun(): (table|AllMaps)

local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local is_nil = Check.value.is_nil
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local type_not_empty = Check.value.type_not_empty
local exists = Check.exists.module
local desc = User.maps.kmap.desc

if not exists('telescope') then
    return
end

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
                width = math.floor(vim.o.columns * 3 / 4),
                height = math.floor(vim.o.lines * 4 / 5),
            },
            horizontal = {
                width = math.floor(vim.o.columns * 4 / 5),
                height = math.floor(vim.o.lines * 3 / 4),
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
            n = {
                ['<M-p>'] = ActionsLayout.toggle_preview,
            },
        },

        vimgrep_arguments = vimgrep_arguments,

        preview = {
            filesize_limit = 0.75, -- MiB
        },
    },

    extensions = {
        projects = {
            layout_strategy = 'horizontal',
            layout_config = {
                anchor = 'N',
                height = 0.25,
                width = 0.6,
                prompt_position = 'bottom',
            },
            prompt_prefix = '󱎸  ',
        },
    },

    pickers = {
        autocommands = { theme = 'ivy' },
        buffers = { theme = 'dropdown' },
        colorscheme = { theme = 'dropdown' },
        commands = { theme = 'ivy' },
        current_buffer_fuzzy_find = { theme = 'cursor' },
        fd = { theme = 'ivy' },
        find_files = {
            theme = 'ivy',
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`'d
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
        },
        git_branches = { theme = 'ivy' },
        git_status = { theme = 'dropdown' },
        git_stash = { theme = 'dropdown' },
        highlights = { theme = 'ivf' },
        lsp_definitions = { theme = 'cursor' },
        lsp_document_symbols = { theme = 'cursor' },
        lsp_implementations = { theme = 'cursor' },
        lsp_type_definitions = { theme = 'cursor' },
        lsp_workspace_symbols = { theme = 'cursor' },
        man_pages = { theme = 'ivy' },
        picker_list = {
            theme = 'ivy',
            opts = {
                projects = { display_type = 'full' },
                project = { display_type = 'full' },
                notify = Themes.get_dropdown({}),
            },

            excluded_pickers = {},

            user_pickers = {
                'todo-comments',
                function()
                    vim.cmd('TodoTelescope theme=cursor')
                end,
            },
        },
        pickers = { theme = 'ivy' },
        planets = { theme = 'ivy' },
        vim_options = { theme = 'ivy' },
    },
}

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

if exists('plugin.telescope.tabs') then
    local pfx = require('plugin.telescope.tabs')

    if not is_nil(pfx) then
        pfx.create()
        pfx.loadkeys()
    end
end

Telescope.setup(Opts)

---@param name string
local function load_ext(name)
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
    ['<leader><C-t>'] = { group = '+Telescope' },
    ['<leader><C-t>b'] = { group = '+Builtins' },
    ['<leader><C-t>e'] = { group = '+Extensions' },

    ['<leader><leader>'] = {
        ':Telescope<CR>',
        desc('Default Telescope Picker'),
    },

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
    ['<leader>vK'] = { Builtin.keymaps, desc('Telescope Keymaps') },
    ['<leader>vO'] = { Builtin.vim_options, desc('Telescope Vim Options') },
    ['<leader>uC'] = { Builtin.colorscheme, desc('Telescope Colorschemes') },

    ['<leader><C-t>b/'] = { Builtin.current_buffer_fuzzy_find, desc('Buffer Fuzzy-Find') },
    ['<leader><C-t>bA'] = { Builtin.autocommands, desc('Autocommands') },
    ['<leader><C-t>bC'] = { Builtin.commands, desc('Commands') },
    ['<leader><C-t>bg'] = { Builtin.live_grep, desc('Live Grep') },
    ['<leader><C-t>bh'] = { Builtin.highlights, desc('Highlights') },
    ['<leader><C-t>bp'] = { Builtin.pickers, desc('Pickers') },
}

---@type table<string, TelExtension>
local known_exts = {
    ['telescope._extensions.file_browser'] = { 'file_browser' },
    ['plugin.telescope.cc'] = {
        'conventional_commits',

        ---@return AllMaps
        function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.conventional_commits) then
                return {}
            end

            return {
                ['<leader><C-t>eC'] = {
                    ':Telescope conventional_commits<CR>',
                    desc('Scope Buffers Picker'),
                },
            }
        end,
    },
    scope = {
        'scope',

        ---@return AllMaps
        function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.scope) then
                return {}
            end

            return {
                ['<leader><C-t>eS'] = { ':Telescope buffers<CR>', desc('Scope Buffers Picker') },
            }
        end,
    },
    persisted = {
        'persisted',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.persisted) then
                return {}
            end

            local pfx = Extensions.persisted

            return {
                ['<leader><C-t>ef'] = { pfx.persisted, desc('Persisted Picker') },
            }
        end,
    },
    ['telescope-makefile'] = {
        'make',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.make) then
                return {}
            end

            return {
                ['<leader><C-t>eM'] = { ':Telescope make<CR>', desc('Makefile Picker') },
            }
        end,
    },
    project_nvim = {
        'projects',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.projects) then
                return {}
            end

            return {
                ['<leader><C-t>ep'] = { ':Telescope projects<CR>', desc('Project Picker') },
                ['<leader>pT'] = { ':Telescope projects<CR>', desc('Project Picker') },
            }
        end,
    },
    notify = {
        'notify',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.notify) then
                return {}
            end

            return {
                ['<leader><C-t>eN'] = { ':Telescope notify<CR>', desc('Notify Picker') },
            }
        end,
    },
    noice = {
        'noice',

        ---@return table|AllMaps
        keys = function()
            ---@type AllMaps
            local res = {
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
            }

            return res
        end,
    },
    ['lazygit.utils'] = {
        'lazygit',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.lazygit) then
                return {}
            end

            ---@type AllMaps
            local res = {
                ['<leader><C-t>eG'] = { ':Telescope lazygit<CR>', desc('LazyGit Picker') },
            }

            return res
        end,
    },

    -- WARN: MUST BE LAST IN THIS LIST
    ['telescope-picker-list'] = {
        'picker_list',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.picker_list) then
                return {}
            end

            return {
                ['<leader><C-t>eP'] = { ':Telescope picker_list<CR>', desc('Picker List') },
                ['<leader><C-t>bp'] = {
                    ':Telescope picker_list<CR>',
                    desc('Picker List (Extension)'),
                },
                ['<leader><leader>'] = {
                    ':Telescope picker_list<CR>',
                    desc('Telescope Picker List'),
                },
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

local group = augroup('UserTelescope', { clear = true })

---@type AuRepeat
local au_tbl = {
    ['User'] = {
        {
            pattern = 'TelescopePreviewerLoaded',
            group = group,

            ---@param args vim.api.keyset.create_autocmd.callback_args
            callback = function(args)
                if args.data.filetype ~= 'help' then
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

Keymaps({ n = Keys })

User.register_plugin('plugin.telescope')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
