local Check = require('user_api.check')
local Keymaps = require('user_api.config.keymaps')
local exists = Check.exists.module
local is_bool = Check.value.is_bool
local type_not_empty = Check.value.type_not_empty
local desc = require('user_api.maps').desc
local ft_get = require('user_api.util').ft_get

local ERROR = vim.log.levels.ERROR
local WARN = vim.log.levels.WARN

local curr_buf = vim.api.nvim_get_current_buf

---@param mini_mod string
---@param opts table|nil
local function src(mini_mod, opts)
    if not type_not_empty('string', mini_mod) then
        vim.notify('(mini src()): Invalid or empty Mini module', ERROR)
        return
    end

    -- If table key doesn't start with `mini.`
    local og_mini_mod = mini_mod
    mini_mod = mini_mod:sub(1, 5) ~= 'mini.' and ('mini.%s'):format(mini_mod) or mini_mod
    if not exists(mini_mod) then
        vim.notify(('(mini src()): Unable to import `%s`'):format(og_mini_mod), ERROR)
        return
    end

    local M = require(mini_mod)
    if not (M.setup and vim.is_callable(M.setup)) then
        vim.notify(('(mini src()): `setup()` not found for module `%s`'):format(mini_mod), WARN)
        return
    end

    M.setup(opts or {})
end

---@class MiniModules
---@field pairs? MiniModules.Pairs
---@field hipatterns? MiniModules.HiPatterns
local Mods = {}

---@class MiniModules.Basics
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

-- ---@class MiniModules.Bufremove
-- Mods.bufremove = {
--     set_vim_settings = true,
--     silent = true,
-- }

-- ---@class MiniModules.Cursorword
-- Mods.cursorword = { delay = 200 }

---@class MiniModules.Extra
Mods.extra = {}

---@class MiniModules.Icons
Mods.icons = {
    style = 'glyph',
    default = {
        -- Override default glyph for "file" category (reuse highlight group)
        file = { glyph = '󰈤' },
    },
    extension = {
        -- Override highlight group (not necessary from 'mini.icons')
        lua = { hl = 'Special' },

        -- Add icons for custom extension. This will also be used in
        -- 'file' category for input like 'file.my.ext'.
        -- ['my.ext'] = { glyph = '󰻲', hl = 'MiniIconsRed' },
    },
}

-- ---@class MiniModules.Map
-- Mods.map = {
--     -- Highlight integrations (none by default)
--     integrations = {
--         require('mini.map').gen_integration.builtin_search(),
--         require('mini.map').gen_integration.diagnostic(),
--         require('mini.map').gen_integration.diff(),
--         require('mini.map').gen_integration.gitsigns(),
--     },
--
--     -- Symbols used to display data
--     symbols = {
--         -- Encode symbols. See `:h MiniMap.config` for specification and
--         -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
--         -- Default: solid blocks with 3x2 resolution.
--         encode = require('mini.map').gen_encode_symbols.block('2x1'),
--         -- encode = require('mini.map').gen_encode_symbols.dodt('1x2'),
--         -- encode = require('mini.map').gen_encode_symbols.shade('1x2'),
--
--         -- Scrollbar parts for view and line. Use empty string to disable any.
--         scroll_line = '█',
--         scroll_view = '┃',
--     },
--
--     -- Window options
--     window = {
--         -- Whether window is focusable in normal way (with `wincmd` or mouse)
--         focusable = false,
--
--         -- Side to stick ('left' or 'right')
--         side = 'right',
--
--         -- Whether to show count of multiple integration highlights
--         show_integration_count = true,
--
--         -- Total width
--         width = 20,
--
--         -- Value of 'winblend' option
--         winblend = 25,
--
--         -- Z-index
--         zindex = 50,
--     },
-- }

---@class MiniModules.Move
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

---@class MiniModules.SplitJoin
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
    ---@class MiniModules.Pairs
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

Mods.sessions = {
    -- Whether to read default session if Neovim opened without file arguments
    autoread = false,

    -- Whether to write currently read session before leaving it
    autowrite = true,

    -- Directory where global sessions are stored (use `''` to disable)
    -- directory = <"session" subdir of user data directory from |stdpath()|>,

    -- File for local session (use `''` to disable)
    file = '',

    -- Whether to force possibly harmful actions (meaning depends on function)
    force = { read = false, write = true, delete = false },

    -- Hook functions for actions. Default `nil` means 'do nothing'.
    -- Takes table with active session data as argument.
    hooks = {
        -- Before successful action
        pre = {
            read = nil,
            write = nil,
            delete = nil,
        },
        -- After successful action
        post = { read = nil, write = nil, delete = nil },
    },

    -- Whether to print session path after action
    verbose = { read = true, write = true, delete = true },
}

---@class MiniModules.Trailspace
Mods.trailspace = { only_in_normal_buffers = true }

-- WARN: This section creates visual hell if combined with other highlight plugins
-- (e.g. todo-comments)
if not exists('todo-comments') then
    ---@class MiniModules.HiPatterns
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
local Keys = {}

---@param force? boolean
---@return fun()
local function gen_bdel(force)
    force = is_bool(force) and force or false

    return function()
        require('mini.bufremove').delete(curr_buf(), force)
    end
end

local group = vim.api.nvim_create_augroup('UserMini', { clear = true })

for mod, opts in pairs(Mods) do ---@cast mod string
    src(mod, opts)

    if mod == 'icons' then
        exists('nvim-web-devicons')
        _G.MiniIcons.mock_nvim_web_devicons()
        _G.MiniIcons.tweak_lsp_kind('prepend')
    end

    if mod == 'bufremove' then
        Keys['<leader>bd'] = {
            gen_bdel(false),
            desc('Close Buffer (Mini)'),
        }
        Keys['<leader>bD'] = {
            gen_bdel(true),
            desc('Close Buffer Forcefully (Mini)'),
        }
    end

    if mod == 'map' then
        local Map = require('mini.map')
        Keys['<leader>mm'] = { group = '+Mini Map' }
        Keys['<leader>mmt'] = { group = '+Toggles' }
        Keys['<leader>mmt'] = {
            Map.toggle,
            desc('Toggle Mini Map'),
        }
        Keys['<leader>mms'] = {
            Map.toggle_side,
            desc('Toggle Side'),
        }
        Keys['<leader>mmf'] = {
            Map.toggle_focus,
            desc('Toggle Focus'),
        }
        Keys['<leader>mmo'] = {
            Map.open,
            desc('Open Mini Map'),
        }
        Keys['<leader>mmd'] = {
            Map.close,
            desc('Close Mini Map'),
        }
        Keys['<leader>mmr'] = {
            Map.refresh,
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

                if not vim.list_contains(accepted, ft) then
                    return
                end

                local hook = require('mini.splitjoin').gen_hook
                local add_trail_sep = hook.add_trailing_separator
                local del_trail_sep = hook.del_trailing_separator
                local pad_bracks = hook.pad_brackets

                local bracks = { brackets = { '%b{}' } }
                local join = {
                    hooks_post = {
                        add_trail_sep(bracks),
                    },
                }
                local split = {
                    hooks_post = {
                        del_trail_sep(bracks),
                        pad_bracks(bracks),
                    },
                }

                vim.b.minisplitjoin_config = {
                    split = split,
                    join = join,
                }
            end,
        })
    end
end

if not vim.tbl_isempty(Keys) then
    Keys['<leader>m'] = { group = '+Mini' }
    Keymaps({ n = Keys })
end
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
