---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check
local Util = User.util
local types = User.types.mini
local WK = User.maps.wk

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_tbl = Check.value.is_tbl
local is_fun = Check.value.is_fun
local is_str = Check.value.is_str
local empty = Check.value.empty
local map_dict = User.maps.map_dict
local notify = Util.notify.notify

---@param mini_mod string
---@param opts table|nil
local function src(mini_mod, opts)
    if not is_str(mini_mod) or empty(mini_mod) then
        error('(plugin.mini:src): Invalid or empty Mini module.')
    end

    mini_mod = mini_mod:sub(1, 5) ~= 'mini.' and 'mini.' .. mini_mod or mini_mod

    if not exists(mini_mod) then
        error('(plugin.mini:src): Unable to import `' .. mini_mod .. '`')
    end

    local M = require(mini_mod)

    opts = is_tbl(opts) and opts or nil

    if is_fun(M.setup) then
        local ok

        if is_nil(opts) then
            ok, _ = pcall(M.setup)
        else
            ok, _ = pcall(M.setup, opts)
        end

        if not ok then
            notify(
                '(plugin.mini:src): Could not setup `' .. mini_mod .. '`',
                'error',
                { title = mini_mod, timeout = 400, hide_from_history = false }
            )
        end
    end
end

---@type MiniModules
local Mods = {
    ['align'] = {
        -- Module mappings. Use `''` (empty string) to disable one
        mappings = {
            start = 'ga',
            start_with_preview = 'gA',
        },

        -- Modifiers changing alignment steps and/or options
        modifiers = {
            --[[ -- Main option modifiers
            ['s'] = --<function: enter split pattern>,
            ['j'] = --<function: choose justify side>,
            ['m'] = --<function: enter merge delimiter>,

            -- Modifiers adding pre-steps
            ['f'] = --<function: filter parts by entering Lua expression>,
            ['i'] = --<function: ignore some split matches>,
            ['p'] = --<function: pair parts>,
            ['t'] = --<function: trim parts>,

            -- Delete some last pre-step
            ['<BS>'] = --<function: delete some last pre-step>,

            -- Special configurations for common splits
            ['='] = --<function: enhanced setup for '='>,
            [','] = --<function: enhanced setup for ','>,
            [' '] = --<function: enhanced setup for ' '>, ]]

            t = function(steps, _)
                local trim_high = require('mini.align').gen_step.trim('both', 'high')
                table.insert(steps.pre_justify, trim_high)
            end,
            T = function(steps, _)
                table.insert(
                    steps.pre_justify,
                    require('mini.align').gen_step.trim('both', 'remove')
                )
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
            pre_justify = { require('mini.align').gen_step.filter('n == 1') },
            justify = nil,
            pre_merge = {},
            merge = nil,
        },

        -- Whether to disable showing non-error feedback
        silent = true,
    },
    ['basics'] = {
        options = {
            basic = true,
            extra_ui = true,
            win_borders = 'single',
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
    },
    ['bufremove'] = {
        set_vim_settings = true,
        silent = true,
    },
    ['cursorword'] = { delay = 1000 },
    ['doc'] = nil,
    ['extra'] = {},
    ['move'] = {
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
    },
    --[[ ['starter'] = exists('plugin.mini.starter') and require('plugin.mini.starter').telescope or {
        autoopen = true,
        -- Whether to evaluate action of single active item
        evaluate_single = false,
        items = nil,
        header = nil,
        footer = nil,
        content_hooks = nil,
        query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
        silent = true,
    }, ]]
    ['trailspace'] = { only_in_normal_buffers = true },
}

if not exists('todo-comments') then
    Mods.hlpatterns = {
        highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
            hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
            todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
            note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

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

    if mod == 'move' and WK.available() then
        map_dict({ ['<leader>M'] = { name = '+Mini Move' } }, 'wk.register', false, 'n')
        map_dict({ ['<leader>M'] = { name = '+Mini Move' } }, 'wk.register', false, 'v')
    end
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
