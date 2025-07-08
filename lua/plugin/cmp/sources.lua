local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local is_num = Check.value.is_num
local is_int = Check.value.is_int
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local empty = Check.value.empty

local cmp = require('cmp')

local win_buf = vim.api.nvim_win_get_buf
local tbl_keys = vim.tbl_keys

local gen_sources = cmp.config.sources

---@return integer[]
local function source_all_bufs()
    ---@type table<integer, boolean>
    local bufs = {}
    for _, win in next, vim.api.nvim_list_wins() do
        bufs[win_buf(win)] = true
    end
    return tbl_keys(bufs)
end

---@return integer[]
local function source_curr_buf()
    local win = vim.api.nvim_get_current_win()
    return tbl_keys({ [win_buf(win)] = true })
end

---@type Sources
---@diagnostic disable-next-line:missing-fields
local Sources = {}

---@param group_index? integer
---@param all_bufs? boolean
---@return SourceBuf
function Sources.buffer(group_index, all_bufs)
    all_bufs = is_bool(all_bufs) and all_bufs or true

    ---@type SourceBuf
    local res = {
        name = 'buffer',
        option = {
            -- keyword_pattern = [[\k\+]],
            keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-.]\w*\)*\)]],
            get_bufnrs = all_bufs and source_all_bufs or source_curr_buf,
        },
    }

    if is_int(group_index) then
        res.group_index = group_index
    end

    return res
end

---@param group_index? integer
---@return SourceAsyncPath
function Sources.async_path(group_index)
    ---@type SourceAsyncPath
    local res = {
        name = 'async_path',
        option = {
            trailing_slash = true,
            label_trailing_slash = true,
            show_hidden_files_by_default = true,
        },
    }

    if is_int(group_index) then
        res.group_index = group_index
    end

    return res
end

---@type table<string, (cmp.SourceConfig|SourceBuf|SourceAsyncPath)[]>
Sources.Sources = {
    c = {
        { name = 'nvim_lsp', group_index = 1 },
        { name = 'vsnip', group_index = 2 },
        { name = 'nvim_lsp_signature_help', group_index = 3 },
        Sources.buffer(4),
        Sources.async_path(5),
    },

    lua = {
        { name = 'nvim_lsp', group_index = 1 },
        { name = 'nvim_lua', group_index = 2 },
        { name = 'vsnip', group_index = 3 },
        { name = 'nvim_lsp_signature_help', group_index = 4 },
        Sources.buffer(5),
    },
}

if exists('cmp_doxygen') then
    table.insert(Sources.Sources.c, { name = 'doxygen' })
end

if exists('lazydev') then
    table.insert(Sources.Sources.lua, {
        name = 'lazydev',
        group_index = 0,
    })
end

---@type SetupSources
Sources.ft = {
    {
        {
            'bash',
            'crontab',
            'html',
            'json',
            'json5',
            'jsonc',
            'markdown',
            'sh',
            'toml',
            'yaml',
            'zsh',
        },
        {
            sources = gen_sources({
                { name = 'nvim_lsp', group_index = 1 },
                { name = 'vsnip', group_index = 3 },
                Sources.async_path(2),
                { name = 'nvim_lsp_signature_help', group_index = 4 },
                Sources.buffer(5),
            }),
        },
    },
    {
        { 'conf', 'config', 'cfg', 'confini', 'gitconfig' },
        {
            sources = gen_sources({
                Sources.buffer(1),
                Sources.async_path(2),
            }),
        },
    },
    {
        { 'c', 'cpp' },
        {
            sources = gen_sources(Sources.Sources.c),
        },
    },
    ['lua'] = {
        sources = gen_sources(Sources.Sources.lua),
    },
    ['lisp'] = {
        sources = gen_sources({
            { name = 'vlime', group_index = 1 },
            Sources.buffer(2),
        }),
    },
    ['gitcommit'] = {
        sources = gen_sources({
            { name = 'conventionalcommits', group_index = 1 },
            { name = 'git', group_index = 2 },
            Sources.buffer(3),
            Sources.async_path(4),
        }),
    },
}

if exists('neorg') then
    Sources.ft['norg'] = {
        sources = gen_sources({
            { name = 'neorg', group_index = 1 },
            Sources.buffer(2),
            Sources.async_path(3),
        }),
    }
end

---@type SetupSources
Sources.cmdline = {
    {
        { '/', '?' },
        {
            mapping = cmp.mapping.preset.cmdline(),
            sources = gen_sources({
                { name = 'nvim_lsp_document_symbol', group_index = 1 },
                Sources.buffer(2),
            }),
        },
    },
    [':'] = {
        mapping = cmp.mapping.preset.cmdline(),
        sources = gen_sources({
            {
                name = 'cmdline',
                group_index = 1,
                option = {
                    treat_trailing_slash = false,
                },
            },
            Sources.async_path(2),
        }),

        ---@diagnostic disable-next-line:missing-fields
        matching = { disallow_symbol_nonprefix_matching = false },
    },
}

function Sources.setup(T)
    local notify = require('user_api.util.notify').notify

    if is_tbl(T) and not empty(T) then
        for k, v in next, T do
            if is_num(k) and is_tbl({ v[1], v[2] }, true) then
                table.insert(Sources.ft, v)
            elseif is_str(k) and is_tbl(v) then
                Sources.ft[k] = v
            else
                notify("Couldn't parse the input table value", 'error', {
                    hide_from_history = false,
                    timeout = 800,
                    title = '(plugin.cmp.sources.setup)',
                })
            end
        end
    end

    for k, v in next, Sources.ft do
        if is_num(k) and is_tbl({ v[1], v[2] }, true) then
            local names = v[1]
            local opts = v[2]

            cmp.setup.filetype(names, opts)
        elseif is_str(k) and is_tbl(v) then
            cmp.setup.filetype(k, v)
        else
            notify("Couldn't parse the input table value", 'error', {
                hide_from_history = false,
                timeout = 800,
                title = '(plugin.cmp.sources.setup)',
            })
        end
    end

    require('cmp_git').setup()

    for k, v in next, Sources.cmdline do
        if is_num(k) then
            local names = v[1]
            local opts = v[2]

            cmp.setup.cmdline(names, opts)
        elseif is_str(k) and is_tbl(v) then
            cmp.setup.cmdline(k, v)
        else
            notify("Couldn't parse the input table value", 'error', {
                hide_from_history = false,
                timeout = 800,
                title = '(plugin.cmp.sources.setup)',
            })
        end
    end
end

function Sources.new()
    return setmetatable({}, { __index = Sources })
end

return Sources

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
