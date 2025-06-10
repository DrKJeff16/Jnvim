---@diagnostic disable:missing-fields

---@module 'user_api.types.mini'

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local empty = Check.value.empty
local map_dict = User.maps.map_dict
local desc = User.maps.kmap.desc
local wk_avail = User.maps.wk.available
local notify = Util.notify.notify

User:register_plugin('plugin.mini')

---@param mini_mod string
---@param opts table|nil
local function src(mini_mod, opts)
    if not is_str(mini_mod) or empty(mini_mod) then
        notify('Invalid or empty Mini module', 'error', {
            animate = true,
            hide_from_history = false,
            timeout = 2750,
            title = '(plugin.mini:src)',
        })
        return
    end

    -- If table key doesn't start with `mini.`
    local og_mini_mod = mini_mod
    mini_mod = mini_mod:sub(1, 5) ~= 'mini.' and 'mini.' .. mini_mod or mini_mod

    if not exists(mini_mod) then
        notify('Unable to import `' .. og_mini_mod .. '`', 'error', {
            animate = true,
            hide_from_history = false,
            timeout = 2250,
            title = '(plugin.mini:src)',
        })
        return
    end

    local M = require(mini_mod)

    opts = is_tbl(opts) and opts or nil

    if is_fun(M.setup) then
        ---@type boolean
        local ok

        if is_nil(opts) then
            ok = pcall(M.setup)
        else
            ok = pcall(M.setup, opts)
        end

        if not ok then
            notify('Could not setup `' .. mini_mod .. '`', 'error', {
                animate = true,
                hide_from_history = false,
                timeout = 600,
                title = '(plugin.mini:src)',
            })
        end
    end
end

---@type MiniModules
local Mods = {}

--[[ Mods.align = {
    -- Module mappings. Use `''` (empty string) to disable one
    mappings = {
        start = 'ga',
        start_with_preview = 'gA',
    },

    -- Modifiers changing alignment steps and/or options
    modifiers = {
        -- TODO: Implement this if necessary
        -- Main option modifiers
        -- ['s'] = --<function: enter split pattern>,
        -- ['j'] = --<function: choose justify side>,
        -- ['m'] = --<function: enter merge delimiter>,
        --
        -- -- Modifiers adding pre-steps
        -- ['f'] = --<function: filter parts by entering Lua expression>,
        -- ['i'] = --<function: ignore some split matches>,
        -- ['p'] = --<function: pair parts>,
        -- ['t'] = --<function: trim parts>,
        --
        -- -- Delete some last pre-step
        -- ['<BS>'] = --<function: delete some last pre-step>,
        --
        -- -- Special configurations for common splits
        -- ['='] = --<function: enhanced setup for '='>,
        -- [','] = --<function: enhanced setup for ','>,
        -- [' '] = --<function: enhanced setup for ' '>,

        t = function(steps, _)
            local trim_high = require('mini.align').gen_step.trim('both', 'high')
            table.insert(steps.pre_justify, trim_high)
        end,

        T = function(steps, _)
            table.insert(steps.pre_justify, require('mini.align').gen_step.trim('both', 'remove'))
        end,

        j = function(_, opts)
            local next_option = ({
                left = 'center',
                center = 'right',
                right = 'none',
                none = 'left',
            })[opts.justify_side]
            opts.justify_side = next_option or 'left'
        end,
    },

    -- Default options controlling alignment process
    options = {
        split_pattern = '',
        justify_side = { 'right', 'left' },
        merge_delimiter = '',
    },

    -- Default steps performing alignment (if `nil`, default is used)
    steps = {
        pre_split = {},
        split = nil,
        pre_justify = {
            require('mini.align').gen_step.filter('n == 1'),
        },

    -- Whether to disable showing non-error feedback
    silent = true,
} ]]

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
        relnum_in_visual_mode = true,
    },

    silent = true,
}

Mods.bufremove = {
    set_vim_settings = true,
    silent = true,
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
    extension = {},
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
        if is_str(ext) then
            ---@diagnostic disable-next-line:need-check-nil
            return ext:sub(-3) ~= 'scm'
        end

        return false
    end,
}

Mods.map = {
    -- Highlight integrations (none by default)
    integrations = {
        require('mini.map').gen_integration.diagnostic(),
        require('mini.map').gen_integration.diff(),
        require('mini.map').gen_integration.builtin_search(),
    },

    -- Symbols used to display data
    symbols = {
        -- Encode symbols. See `:h MiniMap.config` for specification and
        -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
        -- Default: solid blocks with 3x2 resolution.
        encode = nil,

        -- Scrollbar parts for view and line. Use empty string to disable any.
        scroll_line = '█',
        scroll_view = '┃',
    },

    -- Window options
    window = {
        -- Whether window is focusable in normal way (with `wincmd` or mouse)
        focusable = true,

        -- Side to stick ('left' or 'right')
        side = 'right',

        -- Whether to show count of multiple integration highlights
        show_integration_count = false,

        -- Total width
        width = 10,

        -- Value of 'winblend' option
        winblend = 35,

        -- Z-index
        zindex = 10,
    },
}

Mods.move = {
    -- Module mappings. Use `''` (empty string) to disable one
    mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl
        left = '<leader>Ml',
        right = '<leader>Mr',
        down = '<leader>Md',
        up = '<leader>Mu',

        -- Move current line in Normal mode
        line_left = '<leader>Ml',
        line_right = '<leader>Mr',
        line_down = '<leader>Md',
        line_up = '<leader>Mu',
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

for mod, opts in next, Mods do
    src(mod, opts)
    if not wk_avail() then
        goto continue
    end

    if mod == 'move' then
        map_dict({
            n = {
                ['<leader>M'] = { group = '+Mini Move' },
            },
            v = {
                ['<leader>MM'] = { group = '+Mini Move' },
            },
        }, 'wk.register', true)
    elseif mod == 'map' then
        map_dict({
            ['<leader>m'] = { group = '+Mini Map' },
            ['<leader>mt'] = { group = '+Toggles' },
        }, 'wk.register', false, 'n')
    end

    ::continue::

    if mod == 'map' then
        map_dict({
            ['<leader>mtt'] = {
                require('mini.map').toggle,
                desc('Toggle Mini Map'),
            },
            ['<leader>mts'] = {
                require('mini.map').toggle_side,
                desc('Toggle Side'),
            },
            ['<leader>mtf'] = {
                require('mini.map').toggle_focus,
                desc('Toggle Focus'),
            },
            ['<leader>mo'] = {
                require('mini.map').open,
                desc('Open Mini Map'),
            },
            ['<leader>md'] = {
                require('mini.map').close,
                desc('Close Mini Map'),
            },
            ['<leader>mr'] = {
                require('mini.map').refresh,
                desc('Refresh Mini Map'),
            },
        }, 'wk.register', false, 'n')
    end
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
