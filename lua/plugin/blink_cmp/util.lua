---@module 'blink.cmp'

---@alias BlinkCmp.Util.Sources ('lsp'|'path'|'snippets'|'buffer'|string)[]

---@alias BlinkCmp.Util.Providers table<string, blink.cmp.SourceProviderConfigPartial>

local User = require('user_api')
local Check = User.check
local Util = User.util

local exists = Check.exists.module
local type_not_empty = Check.value.type_not_empty
local ft_get = Util.ft_get

local curr_buf = vim.api.nvim_get_current_buf
local copy = vim.deepcopy
local in_tbl = vim.tbl_contains
local validate = vim.validate

---@class BlinkCmp.Util
local BUtil = {}

---@type BlinkCmp.Util.Sources
BUtil.Sources = {}

---@type BlinkCmp.Util.Providers
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
---@return BlinkCmp.Util.Sources
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
            ---@param ctx blink.cmp.Context
            ---@param items blink.cmp.CompletionItem[]
            ---@return blink.cmp.CompletionItem[]
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

            ---@type blink.cmp.PathOpts
            opts = {
                trailing_slash = false,
                label_trailing_slash = true,

                show_hidden_files_by_default = true,

                ---@param ctx blink.cmp.Context
                ---@return string
                get_cwd = function(ctx)
                    return vim.fn.expand(('#%d:p:h'):format(ctx.bufnr))
                end,

                ignore_root_slash = false,
            },
        },

        snippets = {
            name = 'Snippet',
            score_offset = -10,

            ---@type blink.cmp.SnippetsOpts
            opts = {
                -- Whether to use show_condition for filtering snippets
                use_show_condition = true,
                -- Whether to show autosnippets in the completion list
                show_autosnippets = false,
                -- Whether to prefer docTrig placeholders over trig when expanding regTrig snippets
                prefer_doc_trig = false,
            },

            ---@param ctx blink.cmp.Context
            ---@return boolean
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

            ---@param _ blink.cmp.Context
            ---@param items blink.cmp.CompletionItem[]
            ---@return blink.cmp.CompletionItem[]
            transform_items = function(_, items)
                return vim.tbl_filter(
                    ---@param value blink.cmp.CompletionItem
                    ---@return boolean
                    function(value)
                        return value.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword
                    end,
                    items
                )
            end,
        },
    }

    if exists('blink-cmp-sshconfig') then
        ---@module 'blink-cmp-sshconfig'
        BUtil.Providers.sshconfig = {
            name = 'SshConfig',
            module = 'blink-cmp-sshconfig',
        }
    end

    if exists('blink-cmp-env') then
        ---@module 'blink-cmp-env'

        BUtil.Providers.env = {
            name = 'Env',
            module = 'blink-cmp-env',
            score_offset = 40,

            --- @type blink-cmp-env.Options
            opts = {
                item_kind = require('blink.cmp.types').CompletionItemKind.Variable,
                show_braces = false,
                show_documentation_window = true,
            },
        }
    end

    if exists('blink-cmp-git') then
        ---@module 'blink-cmp-git'

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

            ---@type blink-cmp-git.Options
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

            ---@type blink-cmp-conventional-commits.Options
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

---@param P? BlinkCmp.Util.Providers
---@return BlinkCmp.Util.Providers
function BUtil.gen_providers(P)
    validate('BUtil.gen_providers - P', P, 'table', true, 'BlinkCmp.Util.Providers')

    BUtil.reset_providers()

    if type_not_empty('table', P) then
        BUtil.Providers = vim.tbl_deep_extend('keep', P, copy(BUtil.Providers))
    end

    return BUtil.Providers
end

return BUtil

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
