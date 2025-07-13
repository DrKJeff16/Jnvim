---@diagnostic disable:missing-fields

---@module 'plugin._types.mini'

local Keymaps = require('config.keymaps')
local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local type_not_empty = Check.value.type_not_empty
local desc = User.maps.kmap.desc
local notify = Util.notify.notify

---@param mini_mod string
---@param opts table|nil
local function src(mini_mod, opts)
    if not type_not_empty('string', mini_mod) then
        notify('Invalid or empty Mini module', 'error', {
            animate = true,
            hide_from_history = false,
            timeout = 2750,
            title = '(plugin.mini.src)',
        })
        return
    end

    -- If table key doesn't start with `mini.`
    local og_mini_mod = mini_mod
    mini_mod = mini_mod:sub(1, 5) ~= 'mini.' and string.format('mini.%s', mini_mod) or mini_mod

    if not exists(mini_mod) then
        notify(string.format('Unable to import `%s`', og_mini_mod), 'error', {
            animate = true,
            hide_from_history = false,
            timeout = 2750,
            title = '(plugin.mini.src)',
        })
        return
    end

    local M = require(mini_mod)

    opts = is_tbl(opts) and opts or nil

    if is_fun(M.setup) then
        ---@type boolean
        local ok
        local _

        if is_nil(opts) then
            ok, _ = pcall(M.setup)
        else
            ok, _ = pcall(M.setup, opts)
        end

        if not ok then
            notify(string.format('Could not setup `%s`', mini_mod), 'error', {
                animate = true,
                hide_from_history = false,
                timeout = 2750,
                title = '(plugin.mini.src)',
            })
        end
    end
end

---@type MiniModules
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

Mods.icons = {
    style = 'glyph',
    -- Customize per category. See `:h MiniIcons.config` for details.
    default = {
        -- Override default glyph for "file" category (reuse highlight group)
        file = { glyph = '󰈤' },
    },
    directory = {},
    extension = {
        lua = { hl = 'Special' },
    },
    file = {},
    filetype = {},
    lsp = {},
    os = {},

    -- Control which extensions will be considered during "file" resolutions
    ---@param ext string?
    ---@param file string?
    ---@return boolean
    ---@diagnostic disable-next-line:unused-local
    use_file_extension = function(ext, file)
        if type_not_empty('string', ext) then
            ---@diagnostic disable-next-line:need-check-nil
            return ext:sub(-3) ~= 'scm'
        end

        return false
    end,
}

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
        -- encode = require('mini.map').gen_encode_symbols.block('2x1'),
        -- encode = require('mini.map').gen_encode_symbols.dodt('1x2'),
        encode = require('mini.map').gen_encode_symbols.shade('1x2'),

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
        -- left = '<leader>Ml',
        -- right = '<leader>Mr',
        -- down = '<leader>Md',
        -- up = '<leader>Mu',
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

--[[ Mods.starter = exists('plugin.mini.starter') and require('plugin.mini.starter').telescope or {
    autoopen = true,
    -- Whether to evaluate action of single active item
    evaluate_single = false,
    items = nil,
    header = nil,
    footer = nil,
    content_hooks = nil,
    query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
    silent = true,
} ]]

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

---@type AllModeMaps
local Keys = {}

for mod, opts in next, Mods do
    src(mod, opts)

    if mod == 'icons' and exists('nvim-web-devicons') then
        require('mini.icons').mock_nvim_web_devicons()
    end

    if mod == 'map' then
        Keys['<leader>m'] = { group = '+Mini Map' }
        Keys['<leader>mt'] = { group = '+Toggles' }

        Keys['<leader>mtt'] = {
            require('mini.map').toggle,
            desc('Toggle Mini Map'),
        }
        Keys['<leader>mts'] = {
            require('mini.map').toggle_side,
            desc('Toggle Side'),
        }
        Keys['<leader>mtf'] = {
            require('mini.map').toggle_focus,
            desc('Toggle Focus'),
        }
        Keys['<leader>mo'] = {
            require('mini.map').open,
            desc('Open Mini Map'),
        }
        Keys['<leader>md'] = {
            require('mini.map').close,
            desc('Close Mini Map'),
        }
        Keys['<leader>mr'] = {
            require('mini.map').refresh,
            desc('Refresh Mini Map'),
        }
    end
end

Keymaps({ n = Keys })

User:register_plugin('plugin.mini')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
