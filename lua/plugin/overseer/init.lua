local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local empty = Check.value.empty

local ucmd = vim.api.nvim_create_user_command

if not exists('overseer') then
    return
end

User:register_plugin('plugin.overseer')

local OS = require('overseer')

OS.setup({
    strategy = 'terminal',

    -- Configuration for task floating windows
    task_win = {
        -- How much space to leave around the floating window
        padding = 2,
        border = 'rounded',
        -- Set any window options here (e.g. winhighlight)
        win_opts = {
            winblend = 0,
        },
    },
    -- Configuration for mapping help floating windows
    help_win = {
        border = 'rounded',
        win_opts = {},
    },
    -- Aliases for bundles of components. Redefine the builtins, or create your own.
    component_aliases = {
        -- Most tasks are initialized with the default components
        default = {
            { 'display_duration', detail_level = 2 },
            'on_output_summarize',
            'on_exit_set_status',
            'on_complete_notify',
            { 'on_complete_dispose', require_view = { 'SUCCESS', 'FAILURE' } },
        },
        -- Tasks from tasks.json use these components
        default_vscode = {
            'default',
            'on_result_diagnostics',
        },
    },

    auto_detect_success_color = true,
    dap = false,

    task_list = {
        direction = 'bottom',
        min_height = math.floor(vim.opt.lines:get() / 3),
        default_detail = 1,
        separator = '────────────────────────────────────────',
        -- Set keymap to false to remove default behavior
        -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
        bindings = {
            ['?'] = 'ShowHelp',
            ['g?'] = 'ShowHelp',
            ['<CR>'] = 'RunAction',
            ['<C-e>'] = 'Edit',
            ['o'] = 'Open',
            ['<C-v>'] = 'OpenVsplit',
            ['<C-s>'] = 'OpenSplit',
            ['<C-f>'] = 'OpenFloat',
            ['<C-q>'] = 'OpenQuickFix',
            ['p'] = 'TogglePreview',
            ['<C-l>'] = 'IncreaseDetail',
            ['<C-h>'] = 'DecreaseDetail',
            ['L'] = 'IncreaseAllDetail',
            ['H'] = 'DecreaseAllDetail',
            ['['] = 'DecreaseWidth',
            [']'] = 'IncreaseWidth',
            ['{'] = 'PrevTask',
            ['}'] = 'NextTask',
            ['<C-k>'] = 'ScrollOutputUp',
            ['<C-j>'] = 'ScrollOutputDown',
            ['q'] = 'Close',
        },
    },

    templates = {
        'builtin',
        'user.c_build',
        'user.clang_build',
        'user.clangpp_build',
        'user.cpp_build',
        'user.stylua',
    },

    form = {
        border = 'rounded',
        zindex = 40,
        min_width = 80,
        max_width = 0.9,
        min_height = 10,
        max_height = 0.5,

        win_opts = {
            winblend = 0,
        },
    },

    task_editor = {
        -- Set keymap to false to remove default behavior
        -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
        bindings = {
            i = {
                ['<CR>'] = 'NextOrSubmit',
                ['<C-s>'] = 'Submit',
                ['<Tab>'] = 'Next',
                ['<S-Tab>'] = 'Prev',
                ['<C-c>'] = 'Cancel',
            },
            n = {
                ['<CR>'] = 'NextOrSubmit',
                ['<C-s>'] = 'Submit',
                ['<Tab>'] = 'Next',
                ['<S-Tab>'] = 'Prev',
                ['q'] = 'Cancel',
                ['?'] = 'ShowHelp',
            },
        },
    },
    -- Configure the floating window used for confirmation prompts
    confirm = {
        border = 'rounded',
        zindex = 40,
        -- Dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_X and max_X can be a single value or a list of mixed integer/float types.
        min_width = 20,
        max_width = 0.5,
        width = nil,
        min_height = 6,
        max_height = 0.9,
        height = nil,
        -- Set any window options here (e.g. winhighlight)
        win_opts = {
            winblend = 0,
        },
    },

    task_launcher = {
        -- Set keymap to false to remove default behavior
        -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
        bindings = {
            i = {
                ['<C-s>'] = 'Submit',
                ['<C-c>'] = 'Cancel',
            },
            n = {
                ['<CR>'] = 'Submit',
                ['<C-s>'] = 'Submit',
                ['q'] = 'Cancel',
                ['?'] = 'ShowHelp',
            },
        },
    },
    bundles = {
        -- When saving a bundle with OverseerSaveBundle or save_task_bundle(), filter the tasks with
        -- these options (passed to list_tasks())
        save_task_opts = {
            bundleable = true,
        },
        -- Autostart tasks when they are loaded from a bundle
        autostart_on_load = true,
    },
    -- A list of components to preload on setup.
    -- Only matters if you want them to show up in the task editor.
    preload_components = {},
    -- Controls when the parameter prompt is shown when running a template
    --   always    Show when template has any params
    --   missing   Show when template has any params not explicitly passed in
    --   allow     Only show when a required param is missing
    --   avoid     Only show when a required param with no default value is missing
    --   never     Never show prompt (error if required param missing)
    default_template_prompt = 'allow',
    -- For template providers, how long to wait (in ms) before timing out.
    -- Set to 0 to disable timeouts.
    template_timeout = 3000,
    -- Cache template provider results if the provider takes longer than this to run.
    -- Time is in ms. Set to 0 to disable caching.
    template_cache_threshold = 100,
    -- Configure where the logs go and what level to use
    -- Types are "echo", "notify", and "file"
    log = {
        {
            type = 'echo',
            level = vim.log.levels.WARN,
        },
        {
            type = 'file',
            filename = 'overseer.log',
            level = vim.log.levels.WARN,
        },
    },
})

ucmd('OverseerRestartLast', function()
    local overseer = require('overseer')
    local tasks = overseer.list_tasks({ recent_first = true })
    if empty(tasks) then
        vim.notify('No tasks found', vim.log.levels.WARN)
    else
        overseer.run_action(tasks[1], 'restart')
    end
end, {})

User:register_plugin('plugin.overseer')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
