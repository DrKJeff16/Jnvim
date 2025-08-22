local fmt = string.format

local User = require('user_api')
local Check = User.check
local Util = User.util
local Keymaps = require('user_api.config.keymaps')

local exists = Check.exists.module
local is_fun = Check.value.is_fun
local type_not_empty = Check.value.type_not_empty
local desc = User.maps.kmap.desc
local ft_get = Util.ft_get

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN

local in_tbl = vim.tbl_contains

---@param mini_mod string
---@param opts table|nil
local function src(mini_mod, opts)
    if not type_not_empty('string', mini_mod) then
        vim.notify('(mini src()): Invalid or empty Mini module', ERROR)
        return
    end

    -- If table key doesn't start with `mini.`
    local og_mini_mod = mini_mod
    mini_mod = mini_mod:sub(1, 5) ~= 'mini.' and fmt('mini.%s', mini_mod) or mini_mod

    if not exists(mini_mod) then
        vim.notify(fmt('(mini src()): Unable to import `%s`', og_mini_mod), ERROR)
        return
    end

    local M = require(mini_mod)

    if not is_fun(M.setup) then
        vim.notify(fmt('(mini src()): `setup()` not found for module `%s`', mini_mod), WARN)
        return
    end

    opts = opts or {}

    M.setup(opts)
end

---@class MiniModules
local Mods = {}

Mods.basics = {
    options = {
        basic = true,
        extra_ui = true,
        win_borders = 'rounded',
    },

    mappings = {
        basic = false,
        option_toggle_prefix = '',
        windows = true,
        move_with_alt = false,
    },

    autocommands = {
        basic = true,
        relnum_in_visual_mode = false,
    },

    silent = true,
}

Mods.bufremove = {
    set_vim_settings = true,
    silent = true,
}

Mods.doc = {
    -- Function which extracts part of line used to denote annotation.
    -- For more information see 'Notes' in |MiniDoc.config|.
    annotation_extractor = function(l)
        return string.find(l, '^%-%-%-(%S*) ?')
    end,

    -- Identifier of block annotation lines until first captured identifier
    default_section_id = '@text',

    -- Hooks to be applied at certain stage of document life cycle. Should
    -- modify its input in place (and not return new one).
    hooks = {
        -- Applied to block before anything else
        -- block_pre = --<function: infers header sections (tag and/or signature)>,

        -- Applied to section before anything else
        -- section_pre = --<function: replaces current aliases>,

        -- Applied if section has specified captured id
        -- sections = {
        --     ['@alias'] = --<function: registers alias in MiniDoc.current.aliases>,
        --     ['@class'] = --<function>,
        --     ['@diagnostic'] = --<function: ignores any section content>,
        --     -- For most typical usage see |MiniDoc.afterlines_to_code|
        --     ['@eval'] = --<function: evaluates lines; replaces with their return>,
        --     ['@field'] = --<function>,
        --     ['@overload'] = --<function>,
        --     ['@param'] = --<function>,
        --     ['@private'] = --<function: registers block for removal>,
        --     ['@return'] = --<function>,
        --     ['@seealso'] = --<function>,
        --     ['@signature'] = --<function: formats signature of documented object>,
        --     ['@tag'] = --<function: turns its line in proper tag lines>,
        --     ['@text'] = --<function: purposefully does nothing>,
        --     ['@toc'] = --<function: clears all section lines>,
        --     ['@toc_entry'] = --<function: registers lines for table of contents>,
        --     ['@type'] = --<function>,
        --     ['@usage'] = --<function>,
        -- },

        -- Applied to section after all previous steps
        -- section_post = --<function: currently does nothing>,

        -- Applied to block after all previous steps
        -- block_post = --<function: does many things>,

        -- Applied to file after all previous steps
        -- file = --<function: adds separator>,

        -- Applied to doc after all previous steps
        -- doc = --<function: adds modeline>,

        -- Applied before output file is written. Takes lines array as argument.
        -- write_pre = --<function: currently returns its input>,

        -- Applied after output help file is written. Takes doc as argument.
        -- write_post = --<function: various convenience actions>,
    },

    -- Path (relative to current directory) to script which handles project
    -- specific help file generation (like custom input files, hooks, etc.).
    script_path = 'scripts/minidoc.lua',

    -- Whether to disable showing non-error feedback
    silent = false,
}

Mods.extra = {}

-- Mods.cursorword = { delay = 1000 }

-- Mods.icons = {
--     style = 'glyph',
--     -- Customize per category. See `:h MiniIcons.config` for details.
--     default = {
--         -- Override default glyph for "file" category (reuse highlight group)
--         file = { glyph = '󰈤' },
--     },
--     directory = {},
--     extension = {
--         lua = { hl = 'Special' },
--     },
--     file = {},
--     filetype = {},
--     lsp = {},
--     os = {},
--
--     -- Control which extensions will be considered during "file" resolutions
--     ---@param ext string?
--     ---@param file string?
--     ---@return boolean
--     use_file_extension = function(ext, file)
--         return (ext ~= nil) and (ext:sub(-3) ~= 'scm') or false
--     end,
-- }

Mods.map = {
    -- Highlight integrations (none by default)
    integrations = {
        require('mini.map').gen_integration.builtin_search(),
        require('mini.map').gen_integration.diagnostic(),
        require('mini.map').gen_integration.diff(),
        require('mini.map').gen_integration.gitsigns(),
    },

    -- Symbols used to display data
    symbols = {
        -- Encode symbols. See `:h MiniMap.config` for specification and
        -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
        -- Default: solid blocks with 3x2 resolution.
        encode = require('mini.map').gen_encode_symbols.block('2x1'),
        -- encode = require('mini.map').gen_encode_symbols.dodt('1x2'),
        -- encode = require('mini.map').gen_encode_symbols.shade('1x2'),

        -- Scrollbar parts for view and line. Use empty string to disable any.
        scroll_line = '█',
        scroll_view = '┃',
    },

    -- Window options
    window = {
        -- Whether window is focusable in normal way (with `wincmd` or mouse)
        focusable = false,

        -- Side to stick ('left' or 'right')
        side = 'right',

        -- Whether to show count of multiple integration highlights
        show_integration_count = true,

        -- Total width
        width = 20,

        -- Value of 'winblend' option
        winblend = 25,

        -- Z-index
        zindex = 50,
    },
}

Mods.move = {
    -- Module mappings. Use `''` (empty string) to disable one
    mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl
        left = '<C-Left>',
        right = '<C-Right>',
        down = '<C-Down>',
        up = '<C-Up>',

        -- Move current line in Normal mode
        line_left = '<C-Left>',
        line_right = '<C-Right>',
        line_down = '<C-Down>',
        line_up = '<C-Up>',
    },

    -- Options which control moving behavior
    options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
    },
}

Mods.splitjoin = {
    -- Module mappings. Use `''` (empty string) to disable one.
    -- Created for both Normal and Visual modes.
    mappings = {
        toggle = '<leader>mst',
        split = '<leader>mss',
        join = '<leader>msj',
    },

    -- Detection options: where split/join should be done
    detect = {
        -- Array of Lua patterns to detect region with arguments.
        -- Default: { '%b()', '%b[]', '%b{}' }
        brackets = {
            '%b()',
            '%b[]',
            '%b{}',
        },

        -- String Lua pattern defining argument separator
        separator = '[,;]',

        -- Array of Lua patterns for sub-regions to exclude separators from.
        -- Enables correct detection in presence of nested brackets and quotes.
        -- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
        exclude_regions = {
            '%b()',
            '%b[]',
            '%b{}',
            '%b""',
            "%b''",
        },
    },

    -- Split options
    split = {
        hooks_pre = {},
        hooks_post = {},
    },

    -- Join options
    join = {
        hooks_pre = {},
        hooks_post = {},
    },
}

if not exists('nvim-autopairs') then
    Mods.pairs = {
        -- In which modes mappings from this `config` should be created
        modes = {
            insert = true,
            command = true,
            terminal = false,
        },

        -- Global mappings. Each right hand side should be a pair information, a
        -- table with at least these fields (see more in |MiniPairs.map|):
        -- - <action> - one of 'open', 'close', 'closeopen'.
        -- - <pair> - two character string for pair to be used.
        -- By default pair is not inserted after `\`, quotes are not recognized by
        -- <CR>, `'` does not insert pair after a letter.
        -- Only parts of tables can be tweaked (others will use these defaults).
        mappings = {
            ['('] = {
                action = 'open',
                pair = '()',
                neigh_pattern = '[^\\].',
            },
            ['['] = {
                action = 'open',
                pair = '[]',
                neigh_pattern = '[^\\].',
            },
            ['{'] = {
                action = 'open',
                pair = '{}',
                neigh_pattern = '[^\\].',
            },
            ['<'] = {
                action = 'open',
                pair = '<>',
                neigh_pattern = '[^\\].',
            },

            [')'] = {
                action = 'close',
                pair = '()',
                neigh_pattern = '[^\\].',
            },
            [']'] = {
                action = 'close',
                pair = '[]',
                neigh_pattern = '[^\\].',
            },
            ['}'] = {
                action = 'close',
                pair = '{}',
                neigh_pattern = '[^\\].',
            },
            ['>'] = {
                action = 'close',
                pair = '<>',
                neigh_pattern = '[^\\].',
            },

            ['"'] = {
                action = 'closeopen',
                pair = '""',
                neigh_pattern = '[^\\].',
                register = { cr = false },
            },
            ["'"] = {
                action = 'closeopen',
                pair = "''",
                neigh_pattern = '[^%a\\].',
                register = { cr = false },
            },
            ['`'] = {
                action = 'closeopen',
                pair = '``',
                neigh_pattern = '[^\\].',
                register = { cr = false },
            },
        },
    }
end

Mods.trailspace = { only_in_normal_buffers = true }

-- WARN: This section creates visual hell if combined with other highlight plugins
-- (e.g. todo-comments)
if not exists('todo-comments') then
    Mods.hipatterns = {
        highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme = {
                pattern = '%f[%w]()FIXME()%f[%W]',
                group = 'MiniHipatternsFixme',
            },
            hack = {
                pattern = '%f[%w]()HACK()%f[%W]',
                group = 'MiniHipatternsHack',
            },
            todo = {
                pattern = '%f[%w]()TODO()%f[%W]',
                group = 'MiniHipatternsTodo',
            },
            note = {
                pattern = '%f[%w]()NOTE()%f[%W]',
                group = 'MiniHipatternsNote',
            },

            -- Highlight hex color strings (`#rrggbb`) using that color
            hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },

        delay = {
            text_change = 1500,
            scroll = 350,
        },
    }
end

---@type AllMaps
local Keys = {
    ['<leader>m'] = { group = '+Mini' },
}

local group = vim.api.nvim_create_augroup('UserMini', { clear = true })

for mod, opts in next, Mods do
    src(mod, opts)

    if mod == 'map' then
        Keys['<leader>mm'] = { group = '+Mini Map' }
        Keys['<leader>mmt'] = { group = '+Toggles' }

        Keys['<leader>mmt'] = {
            require('mini.map').toggle,
            desc('Toggle Mini Map'),
        }
        Keys['<leader>mms'] = {
            require('mini.map').toggle_side,
            desc('Toggle Side'),
        }
        Keys['<leader>mmf'] = {
            require('mini.map').toggle_focus,
            desc('Toggle Focus'),
        }
        Keys['<leader>mmo'] = {
            require('mini.map').open,
            desc('Open Mini Map'),
        }
        Keys['<leader>mmd'] = {
            require('mini.map').close,
            desc('Close Mini Map'),
        }
        Keys['<leader>mmr'] = {
            require('mini.map').refresh,
            desc('Refresh Mini Map'),
        }
    end

    if mod == 'splitjoin' then
        Keys['<leader>ms'] = { group = '+Splitjoin' }

        vim.api.nvim_create_autocmd({ 'BufNew', 'BufAdd', 'BufEnter', 'BufCreate', 'WinEnter' }, {
            group = group,
            callback = function(ev)
                local ft = ft_get(ev.buf)
                local accepted = { 'lua' }

                if not in_tbl(accepted, ft) then
                    return
                end

                local hook = require('mini.splitjoin').gen_hook
                local bracks = { brackets = { '%b{}' } }

                local split_post = {
                    hook.add_trailing_separator(bracks),
                }
                local join_post = {
                    hook.del_trailing_separator(bracks),
                    hook.pad_brackets(bracks),
                }

                vim.b.minisplitjoin_config = {
                    split = { hooks_post = split_post },
                    join = { hooks_post = join_post },
                }
            end,
        })
    end
end

Keymaps({ n = Keys })

User.register_plugin('plugin.mini')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
