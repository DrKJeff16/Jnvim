---@module 'blink.cmp'
---@module 'lazy'

local User = require('user_api')
local Check = User.check
local Util = User.util

local validate = vim.validate
local curr_buf = vim.api.nvim_get_current_buf
local copy = vim.deepcopy
local in_tbl = vim.tbl_contains

local exists = Check.exists.module
local executable = Check.exists.executable
local type_not_empty = Check.value.type_not_empty
local has_words_before = Util.has_words_before
local ft_get = Util.ft_get

local BUtil = {}
BUtil.Sources = {}
BUtil.Providers = {}
BUtil.curr_ft = ''

---@param snipps? boolean
---@param buf? boolean
function BUtil.reset_sources(snipps, buf)
    validate('BUtil.reset_sources - snipps', snipps, 'boolean', true, 'boolean')
    validate('BUtil.reset_sources - buffer', buf, 'boolean', true, 'boolean')

    snipps = snipps ~= nil and snipps or false
    buf = buf ~= nil and buf or true

    BUtil.Sources = {
        'lsp',
        'path',
        'env',
    }

    if snipps then
        table.insert(BUtil.Sources, 'snippets')
    end
    if buf then
        table.insert(BUtil.Sources, 'buffer')
    end

    local ft = ft_get(curr_buf())

    if ft == 'lua' then
        table.insert(BUtil.Sources, 1, 'lazydev')
        return
    end

    if ft == 'sshconfig' then
        table.insert(BUtil.Sources, 1, 'sshconfig')
        return
    end

    local git_fts = {
        'git',
        'gitcommit',
        'gitattributes',
        'gitrebase',
    }

    if in_tbl(git_fts) then
        table.insert(BUtil.Sources, 1, 'git')
    end

    if ft == 'gitcommit' then
        table.insert(BUtil.Sources, 1, 'conventional_commits')
    end
end

---@param snipps? boolean
---@param buf? boolean
function BUtil.gen_sources(snipps, buf)
    validate('BUtil.reset_sources - snipps', snipps, 'boolean', true, 'boolean')
    validate('BUtil.reset_sources - buffer', buf, 'boolean', true, 'boolean')

    BUtil.reset_sources(snipps, buf)

    return BUtil.Sources
end

function BUtil.reset_providers()
    BUtil.Providers = {
        cmdline = {
            module = 'blink.cmp.sources.cmdline',
        },

        buffer = {
            score_offset = -20,
            max_items = 10,

            opts = {
                -- default to all visible buffers
                get_bufnrs = function()
                    return vim.iter(vim.api.nvim_list_wins())
                        :map(function(win)
                            return vim.api.nvim_win_get_buf(win)
                        end)
                        :filter(
                            ---@param bufnr integer
                            ---@return boolean
                            function(bufnr)
                                return vim.bo[bufnr].buftype ~= 'nofile'
                            end
                        )
                        :totable()
                end,
                -- buffers when searching with `/` or `?`
                ---@return integer[]
                get_search_bufnrs = function()
                    return { curr_buf() }
                end,
                -- Maximum total number of characters (across all selected buffers) for which buffer completion runs synchronously. Above this, asynchronous processing is used.
                max_sync_buffer_size = 20000,
                -- Maximum total number of characters (across all selected buffers) for which buffer completion runs asynchronously. Above this, buffer completions are skipped to avoid performance issues.
                max_async_buffer_size = 200000,
                -- Maximum text size across all buffers (default: 500KB)
                max_total_buffer_size = 500000,
                -- Order in which buffers are retained for completion, up to the max total size limit (see above)
                retention_order = {
                    'focused',
                    'visible',
                    'recency',
                    'largest',
                },
                -- Cache words for each buffer which increases memory usage but drastically reduces cpu usage. Memory usage depends on the size of the buffers from `get_bufnrs`. For 100k items, it will use ~20MBs of memory. Invalidated and refreshed whenever the buffer content is modified.
                use_cache = true,
                -- Whether to enable buffer source in substitute (:s) and global (:g) commands.
                -- Note: Enabling this option will temporarily disable Neovim's 'inccommand' feature
                -- while editing Ex commands, due to a known redraw issue (see neovim/neovim#9783).
                -- This means you will lose live substitution previews when using :s, :smagic, or :snomagic
                -- while buffer completions are active.
                enable_in_ex_commands = false,
            },

            -- keep case of first char
            transform_items = function(ctx, items)
                local keyword = ctx.get_keyword()
                local correct

                ---@type fun(s: string|number): string
                local case

                if keyword:match('^%l') then
                    correct = '^%u%l+$'
                    case = string.lower
                elseif keyword:match('^%u') then
                    correct = '^%l+$'
                    case = string.upper
                else
                    return items
                end

                -- avoid duplicates from the corrections
                local seen, out = {}, {}

                for _, item in next, items do
                    ---@type string
                    local raw = item.insertText

                    if raw:match(correct) then
                        local text = case(raw:sub(1, 1)) .. raw:sub(2)
                        item.insertText = text
                        item.label = text
                    end
                    if not seen[item.insertText] then
                        seen[item.insertText] = true
                        table.insert(out, item)
                    end
                end

                return out
            end,
        },

        path = {
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = 30,

            opts = {
                trailing_slash = false,
                label_trailing_slash = true,

                show_hidden_files_by_default = true,

                get_cwd = function(ctx)
                    return vim.fn.expand(('#%d:p:h'):format(ctx.bufnr))
                end,

                ignore_root_slash = false,
            },
        },

        snippets = {
            name = 'Snippet',
            score_offset = -10,

            opts = {
                -- Whether to use show_condition for filtering snippets
                use_show_condition = true,
                -- Whether to show autosnippets in the completion list
                show_autosnippets = false,
                -- Whether to prefer docTrig placeholders over trig when expanding regTrig snippets
                prefer_doc_trig = false,
            },

            should_show_items = function(ctx)
                return ctx.trigger.initial_kind ~= 'trigger_character'
            end,
        },

        lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
        },

        lsp = {
            name = 'LSP',
            module = 'blink.cmp.sources.lsp',
            score_offset = 70,

            transform_items = function(_, items)
                return vim.tbl_filter(function(value)
                    return value.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
                end, items)
            end,
        },
    }

    if exists('blink-cmp-sshconfig') then
        BUtil.Providers.sshconfig = {
            name = 'SshConfig',
            module = 'blink-cmp-sshconfig',
        }
    end

    if exists('blink-cmp-env') then
        BUtil.Providers.env = {
            name = 'Env',
            module = 'blink-cmp-env',
            score_offset = 40,
            opts = {
                item_kind = require('blink.cmp.types').CompletionItemKind.Variable,
                show_braces = false,
                show_documentation_window = true,
            },
        }
    end

    if exists('blink-cmp-git') then
        BUtil.Providers.git = {
            name = 'Git',
            module = 'blink-cmp-git',

            ---@return boolean
            enabled = function()
                local git_fts = {
                    'git',
                    'gitcommit',
                    'gitattributes',
                    'gitrebase',
                }

                return in_tbl(git_fts, ft_get(curr_buf()))
            end,

            opts = {},
        }
    end

    if exists('blink-cmp-conventional-commits') then
        ---@module 'blink-cmp-conventional-commits'

        BUtil.Providers.conventional_commits = {
            name = 'CC',
            module = 'blink-cmp-conventional-commits',
            score_offset = 100,

            ---@return boolean
            enabled = function()
                return ft_get(curr_buf()) == 'gitcommit'
            end,

            opts = {}, -- none so far
        }
    end

    if exists('orgmode') then
        BUtil.Providers.orgmode = {
            name = 'Orgmode',
            module = 'orgmode.org.autocompletion.blink',
        }
    end
end

function BUtil.gen_providers(P)
    validate('BUtil.gen_providers - P', P, 'table', true, 'BlinkCmp.Util.Providers')

    BUtil.reset_providers()

    if type_not_empty('table', P) then
        BUtil.Providers = vim.tbl_deep_extend('keep', P, copy(BUtil.Providers))
    end

    return BUtil.Providers
end

local gen_sources = BUtil.gen_sources
local gen_providers = BUtil.gen_providers

---@param key string
---@return fun()
local function gen_termcode_fun(key)
    validate('key', key, 'string', false)

    return function()
        local termcode = vim.api.nvim_replace_termcodes(key, true, false, true)
        vim.api.nvim_feedkeys(termcode, 'i', false)
    end
end

local select_opts = {
    auto_insert = true,
    preselect = false,
}

---@type LazySpec
return {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = false,
    dependencies = {
        {
            'L3MON4D3/LuaSnip',
            version = false,
            dependencies = {
                'rafamadriz/friendly-snippets',
                'benfowler/telescope-luasnip.nvim',
            },
            build = executable('make') and 'make -j $(nproc) install_jsregexp' or false,
            config = function(_, opts)
                local luasnip = require('luasnip')
                local ft_extend = luasnip.filetype_extend

                if opts then
                    luasnip.config.setup(opts)
                end
                vim.tbl_map(function(type)
                    require('luasnip.loaders.from_' .. type).lazy_load()
                end, { 'vscode', 'snipmate', 'lua' })

                -- friendly-snippets - enable standardized comments snippets
                ft_extend('c', { 'cdoc' })
                ft_extend('cpp', { 'cppdoc' })
                ft_extend('cs', { 'csharpdoc' })
                ft_extend('java', { 'javadoc' })
                ft_extend('javascript', { 'jsdoc' })
                ft_extend('kotlin', { 'kdoc' })
                ft_extend('lua', { 'luadoc' })
                ft_extend('php', { 'phpdoc' })
                ft_extend('python', { 'pydoc' })
                ft_extend('ruby', { 'rdoc' })
                ft_extend('rust', { 'rustdoc' })
                ft_extend('sh', { 'shelldoc' })
                ft_extend('typescript', { 'tsdoc' })
            end,
        },
        {
            'onsails/lspkind.nvim',
            version = false,
            config = require('config.util').require('plugin.lspkind'),
        },

        'folke/lazydev.nvim',
        'Kaiser-Yang/blink-cmp-git',
        'disrupted/blink-cmp-conventional-commits',
        {
            'bydlw98/blink-cmp-env',
            dev = true,
            version = false,
        },
        {
            'DrKJeff16/blink-cmp-sshconfig',
            dev = true,
            build = executable('uv') and 'make' or false,
            version = false,
        },
    },
    build = executable('cargo') and 'cargo build --release' or false,
    config = function()
        if not exists('blink.cmp') then
            User.deregister_plugin('plugin.blink_cmp')
            return
        end

        local Blink = require('blink.cmp')

        if exists('luasnip.loaders.from_vscode') then
            require('luasnip.loaders.from_vscode').lazy_load()
        end

        Blink.setup({
            keymap = {
                preset = 'super-tab',

                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-e>'] = { 'cancel', 'fallback' },
                ['<CR>'] = { 'accept', 'fallback' },
                ['<Tab>'] = {
                    function(cmp)
                        local visible = cmp.is_menu_visible
                        local snip_active = cmp.snippet_active

                        if snip_active({ direction = 1 }) then
                            return cmp.snippet_forward()
                        end

                        if not visible() and has_words_before() then
                            return cmp.show({ providers = gen_sources(true, true) })
                        end

                        return cmp.select_next(select_opts)
                    end,
                    'fallback',
                },
                ['<S-Tab>'] = {
                    function(cmp)
                        local visible = cmp.is_menu_visible
                        local snip_active = cmp.snippet_active

                        if snip_active({ direction = -1 }) then
                            return cmp.snippet_backward()
                        end

                        if not visible() and has_words_before() then
                            return cmp.show({ providers = gen_sources(true, true) })
                        end

                        return cmp.select_prev(select_opts)
                    end,
                    'fallback',
                },

                ['<Up>'] = {
                    function(cmp)
                        if cmp.is_menu_visible() then
                            return cmp.cancel({
                                callback = gen_termcode_fun('<Up>'),
                            })
                        end
                    end,
                    'fallback',
                },
                ['<Down>'] = {
                    function(cmp)
                        if cmp.is_menu_visible() then
                            return cmp.cancel({
                                callback = gen_termcode_fun('<Down>'),
                            })
                        end
                    end,
                    'fallback',
                },
                ['<Left>'] = { 'fallback' },
                ['<Right>'] = { 'fallback' },

                ['<C-p>'] = { 'fallback' },
                ['<C-n>'] = { 'fallback' },

                ['<C-b>'] = {
                    function(cmp)
                        if cmp.is_documentation_visible() then
                            return cmp.scroll_documentation_up(4)
                        end
                    end,
                    'fallback',
                },
                ['<C-f>'] = {
                    function(cmp)
                        if cmp.is_documentation_visible() then
                            return cmp.scroll_documentation_down(4)
                        end
                    end,
                    'fallback',
                },
                ['<C-k>'] = {
                    function(cmp)
                        if cmp.is_signature_visible() then
                            return cmp.hide_signature()
                        end

                        return cmp.show_signature()
                    end,
                    'fallback',
                },
            },

            appearance = {
                nerd_font_variant = 'mono',

                highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),

                ---Sets the fallback highlight groups to nvim-cmp's highlight groups
                ---Useful for when your theme doesn't support blink.cmp
                ---Will be removed in a future release
                use_nvim_cmp_as_default = false,

                kind_icons = require('lspkind').symbol_map,
            },

            completion = {
                trigger = {
                    show_in_snippet = true,
                    show_on_trigger_character = true,
                },

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    update_delay_ms = 100,

                    treesitter_highlighting = true,

                    window = {
                        border = 'rounded',
                        winblend = 0,

                        winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',

                        ---Note that the gutter will be disabled when `border ~= 'none'`
                        scrollbar = false,

                        ---Which directions to show the documentation window,
                        ---for each of the possible menu window directions,
                        ---falling back to the next direction when there's not enough space
                        direction_priority = {
                            menu_north = { 'e', 'w', 'n', 's' },
                            menu_south = { 'e', 'w', 's', 'n' },
                        },
                    },
                },

                keyword = { range = 'full' },

                accept = {
                    auto_brackets = { enabled = false },
                    create_undo_point = true,
                    dot_repeat = true,
                },

                list = {
                    selection = {
                        preselect = function(_) -- `ctx`
                            return require('blink.cmp').snippet_active({ direction = 1 })
                        end,

                        auto_insert = true,
                    },

                    cycle = {
                        from_top = true,
                        from_bottom = true,
                    },
                },

                menu = {
                    ---Don't automatically show the completion menu
                    auto_show = true,

                    border = 'single',

                    ---`nvim-cmp`-style menu
                    draw = {
                        padding = { 0, 1 },
                        treesitter = { 'lsp' },

                        columns = {
                            { 'label', 'label_description', gap = 1 },
                            { 'kind_icon', 'kind' },
                            { 'source_name', gap = 1 },
                        },
                    },
                },

                ghost_text = { enabled = false },
            },

            cmdline = {
                enabled = false,

                keymap = {
                    preset = 'cmdline',

                    ['<Right>'] = { 'fallback' },
                    ['<Left>'] = { 'fallback' },
                    ['<C-p>'] = { 'fallback' },
                    ['<C-n>'] = { 'fallback' },
                },

                sources = function()
                    local type = vim.fn.getcmdtype()
                    local res = {}
                    -- Search forward and backward
                    if type == '/' or type == '?' then
                        res = { 'buffer' }
                    end

                    -- Commands
                    if type == ':' or type == '@' then
                        res = { 'cmdline', 'buffer' }
                    end

                    return res
                end,
            },

            sources = {
                default = function()
                    return gen_sources(true, true)
                end,

                ---Function to use when transforming the items before they're returned for all providers
                ---The default will lower the score for snippets to sort them lower in the list
                transform_items = function(_, items)
                    return items
                end,

                providers = gen_providers(),
            },

            fuzzy = {
                implementation = executable({ 'cargo', 'rustc' }) and 'prefer_rust_with_warning'
                    or 'lua',

                ---@param keyword string
                ---@return integer
                max_typos = function(keyword)
                    return math.floor(#keyword / 3)
                end,

                sorts = {
                    'exact',
                    -- 'label',
                    -- 'kind',
                    'score',
                    'sort_text',
                },
            },

            snippets = {
                preset = exists('luasnip') and 'luasnip' or 'default',

                ---Function to use when expanding LSP provided snippets
                expand = function(snippet)
                    vim.snippet.expand(snippet)
                end,

                ---Function to use when checking if a snippet is active
                active = function(filter)
                    return vim.snippet.active(filter)
                end,

                ---Function to use when jumping between tab stops in a snippet,
                ---where direction can be negative or positive
                jump = function(direction)
                    vim.snippet.jump(direction) ---@diagnostic disable-line:param-type-mismatch
                end,
            },

            signature = {
                enabled = true,

                trigger = {
                    ---Show the signature help automatically
                    enabled = true,

                    ---Show the signature help window after typing any of alphanumerics, `-` or `_`
                    show_on_keyword = false,

                    blocked_trigger_characters = {},
                    blocked_retrigger_characters = {},

                    ---Show the signature help window after typing a trigger character
                    show_on_trigger_character = true,

                    ---Show the signature help window when entering insert mode
                    show_on_insert = false,

                    ---Show the signature help window when the cursor comes after a trigger character when entering insert mode
                    show_on_insert_on_trigger_character = true,
                },

                window = {
                    treesitter_highlighting = true,
                    show_documentation = true,
                    border = 'single',
                    scrollbar = false,
                    direction_priority = { 'n', 's' },
                    -- direction_priority = { 's', 'n' },
                },
            },

            term = { enabled = false },
        })

        User.register_plugin('plugin.blink_cmp')
    end,
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
