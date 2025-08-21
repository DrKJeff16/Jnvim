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

local floor = math.floor

local User = require('user_api')
local Check = User.check

local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local type_not_empty = Check.value.type_not_empty
local exists = Check.exists.module
local Keymaps = require('user_api.config.keymaps')
local desc = User.maps.kmap.desc

if not exists('telescope') then
    User.deregister_plugin('plugin.telescope')
    return
end

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local Telescope = require('telescope')
local Actions = require('telescope.actions')
local ActionsLayout = require('telescope.actions.layout')
local Config = require('telescope.config')

--- Clone the default Telescope configuration
local vimgrep_arguments = { (unpack or table.unpack)(Config.values.vimgrep_arguments) }
local extra_args = {
    --- Search in hidden/dot files
    '--hidden',
    --- Don't search in these hidden directories
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
                width = floor(vim.opt.columns:get() * 3 / 4),
                height = floor(vim.opt.lines:get() * 4 / 5),
            },
            horizontal = {
                width = floor(vim.opt.columns:get() * 4 / 5),
                height = floor(vim.opt.lines:get() * 3 / 4),
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
        persisted = {
            layout_config = { width = 0.75, height = 0.75 },
        },

        projects = {
            prompt_prefix = '󱎸  ',
        },

        undo = {
            use_delta = true,
            use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
            side_by_side = true,
            layout_strategy = 'vertical',
            layout_config = {
                preview_height = 0.8,
            },
            vim_diff_opts = {
                ctxlen = vim.opt.scrolloff:get(),
            },
            entry_format = 'state #$ID, $STAT, $TIME',
            time_format = '',
            saved_only = false,

            mappings = {
                i = {
                    ['<CR>'] = require('telescope-undo.actions').yank_additions,
                    ['<S-CR>'] = require('telescope-undo.actions').yank_deletions,
                    ['<C-CR>'] = require('telescope-undo.actions').restore,
                    -- alternative defaults, for users whose terminals do questionable things with modified <CR>
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
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`'d
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
    -- Use this to add more results without clearing the trouble list

    Opts.defaults.mappings.i['<C-T>'] = open_with_trouble
    Opts.defaults.mappings.n['<C-T>'] = open_with_trouble
end

if exists('plugin.telescope.file_browser') then
    local pfx = require('plugin.telescope.file_browser')

    if pfx ~= nil then
        Opts.extensions.file_browser = pfx.file_browser
        pfx.loadkeys()
    end
end

if exists('plugin.telescope.cc') then
    local pfx = require('plugin.telescope.cc')

    if pfx ~= nil then
        Opts.extensions.conventional_commits = pfx.cc
        pfx.loadkeys()
    end
end

if exists('plugin.telescope.tabs') then
    local pfx = require('plugin.telescope.tabs')

    if pfx ~= nil then
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

    ['<leader>HH'] = {
        '<CMD>Telescope help_tags<CR>',
        desc('Telescope Help Tags'),
    },
    ['<leader>HM'] = {
        '<CMD>Telescope man_pages<CR>',
        desc('Telescope Man Pages'),
    },
    ['<leader>GB'] = {
        '<CMD>Telescope git_branches<CR>',
        desc('Telescope Git Branches'),
    },
    ['<leader>GS'] = {
        '<CMD>Telescope git_stash<CR>',
        desc('Telescope Git Stash'),
    },
    ['<leader>Gs'] = {
        '<CMD>Telescope git_status<CR>',
        desc('Telescope Git Status'),
    },
    ['<leader>bB'] = {
        '<CMD>Telescope buffers<CR>',
        desc('Telescope Buffers'),
    },
    ['<leader>fD'] = {
        '<CMD>Telescope diagnostics<CR>',
        desc('Telescope Diagnostics'),
    },
    ['<leader>ff'] = {
        '<CMD>Telescope find_files<CR>',
        desc('Telescope File Picker'),
    },
    ['<leader>lD'] = {
        '<CMD>Telescope lsp_document_symbols<CR>',
        desc('Telescope Document Symbols'),
    },
    ['<leader>lT'] = {
        '<CMD>Telescope lsp_type_definitions<CR>',
        desc('Telescope Definitions'),
    },
    ['<leader>ld'] = {
        '<CMD>Telescope lsp_definitions<CR>',
        desc('Telescope Definitions'),
    },
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
    ['<leader>vK'] = {
        '<CMD>Telescope keymaps<CR>',
        desc('Telescope Keymaps'),
    },
    ['<leader>vO'] = {
        '<CMD>Telescope vim_options<CR>',
        desc('Telescope Vim Options'),
    },
    ['<leader>uC'] = {
        '<CMD>Telescope colorscheme<CR>',
        desc('Telescope Colorschemes'),
    },

    ['<leader><C-t>b/'] = {
        '<CMD>Telescope current_buffer_fuzzy_find<CR>',
        desc('Buffer Fuzzy-Find'),
    },
    ['<leader><C-t>bA'] = {
        '<CMD>Telescope autocommands<CR>',
        desc('Autocommands'),
    },
    ['<leader><C-t>bC'] = {
        '<CMD>Telescope commands<CR>',
        desc('Commands'),
    },
    ['<leader><C-t>bg'] = {
        '<CMD>Telescope live_grep<CR>',
        desc('Live Grep'),
    },
    ['<leader><C-t>bh'] = {
        '<CMD>Telescope highlights<CR>',
        desc('Highlights'),
    },
    ['<leader><C-t>bp'] = {
        '<CMD>Telescope pickers<CR>',
        desc('Pickers'),
    },
}

---@type table<string, TelExtension>
local known_exts = {
    ['telescope._extensions.file_browser'] = {
        'file_browser',
    },

    ['telescope._extensions.undo'] = {
        'undo',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.undo) then
                return {}
            end

            return {
                ['<leader><C-t>eu'] = {
                    '<CMD>Telescope undo<CR>',
                    desc('Undo Picker'),
                },

                ['<leader>fu'] = {
                    '<CMD>Telescope undo<CR>',
                    desc('Undo Telescope Picker'),
                },
            }
        end,
    },

    ['plugin.telescope.cc'] = {
        'conventional_commits',

        ---@return AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.conventional_commits) then
                return {}
            end

            return {
                ['<leader><C-t>eC'] = {
                    '<CMD>Telescope conventional_commits<CR>',
                    desc('Conventional Commits Picker'),
                },

                ['<leader>GC'] = {
                    '<CMD>Telescope conventional_commits<CR>',
                    desc('Conventional Commits Telescope Picker'),
                },
            }
        end,
    },

    scope = {
        'scope',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.scope) then
                return {}
            end

            return {
                ['<leader><C-t>eS'] = {
                    '<CMD>Telescope buffers<CR>',
                    desc('Scope Buffers Picker'),
                },

                ['<leader>S'] = { group = '+Scope' },

                ['<leader>Sb'] = {
                    '<CMD>Telescope buffers<CR>',
                    desc('Scope Buffers Telescope Picker'),
                },
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
                ['<leader><C-t>ef'] = {
                    pfx.persisted,
                    desc('Persisted Picker'),
                },
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
                ['<leader><C-t>eM'] = {
                    '<CMD>Telescope make<CR>',
                    desc('Makefile Picker'),
                },

                ['<leader>fM'] = { group = '+Make' },

                ['<leader>fMT'] = {
                    '<CMD>Telescope make<CR>',
                    desc('Makefile Telescope Picker'),
                },
            }
        end,
    },

    aerial = {
        'aerial',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.aerial) then
                return {}
            end

            return {
                ['<leader><C-t>ea'] = {
                    '<CMD>Telescope aerial<CR>',
                    desc('Aerial Picker'),
                },

                ['<leader>laT'] = {
                    '<CMD>Telescope aerial<CR>',
                    desc('Aerial Telescope Picker'),
                },
            }
        end,
    },

    project = {
        'projects',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.projects) then
                return {}
            end

            return {
                ['<leader><C-t>ep'] = {
                    '<CMD>Telescope projects<CR>',
                    desc('Project Picker'),
                },

                ['<leader>pT'] = {
                    '<CMD>Telescope projects<CR>',
                    desc('Project Telescope Picker'),
                },
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
                ['<leader><C-t>eN'] = {
                    '<CMD>Telescope notify<CR>',
                    desc('Notify Picker'),
                },

                ['<leader>N'] = { group = '+Notify' },

                ['<leader>NT'] = {
                    '<CMD>Telescope notify<CR>',
                    desc('Notify Telescope Picker'),
                },
            }
        end,
    },
    noice = {
        'noice',

        ---@return AllMaps
        keys = function()
            return {
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

            return {
                ['<leader><C-t>eG'] = {
                    '<CMD>Telescope lazygit<CR>',
                    desc('LazyGit Picker'),
                },

                ['<leader>GlT'] = {
                    '<CMD>Telescope lazygit<CR>',
                    desc('LazyGit Telescope Picker'),
                },
            }
        end,
    },

    ['telescope._extensions.picker_list'] = {
        'picker_list',

        ---@return table|AllMaps
        keys = function()
            local Extensions = require('telescope').extensions

            if not type_not_empty('table', Extensions.picker_list) then
                return {}
            end

            return {
                ['<leader><C-t>eP'] = {
                    '<CMD>Telescope picker_list<CR>',
                    desc('Picker List'),
                },
                ['<leader><C-t>bp'] = {
                    '<CMD>Telescope picker_list<CR>',
                    desc('Picker List (Extension)'),
                },

                ['<leader><leader>'] = {
                    '<CMD>Telescope picker_list<CR>',
                    desc('Telescope Picker List'),
                },
            }
        end,
    },
}

--- Load and Set Keymaps for available extensions
for mod, ext in next, known_exts do
    --- If extension is unavailable/invalid
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

            callback = function(ev)
                if ev.data.filetype ~= 'help' then
                    vim.wo.number = true
                elseif ev.data.bufname:match('*.csv') then
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
