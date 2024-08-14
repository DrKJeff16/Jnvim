local User = require('user_api')
local Check = User.check
local types = User.types.cmp

local exists = Check.exists.module
local is_num = Check.value.is_num
local is_int = Check.value.is_int
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local is_bool = Check.value.is_bool
local empty = Check.value.empty

local cmp = require('cmp')

local gen_sources = cmp.config.sources

---@return integer[]
local function source_all_bufs()
    ---@type table<integer, boolean>
    local bufs = {}
    for _, win in next, vim.api.nvim_list_wins() do
        bufs[vim.api.nvim_win_get_buf(win)] = true
    end
    return vim.tbl_keys(bufs)
end

---@return integer[]
local function source_curr_buf()
    local win = vim.api.nvim_get_current_win()
    return vim.tbl_keys({ [vim.api.nvim_win_get_buf(win)] = true })
end

---@param group_index? integer
---@param all_bufs? boolean
---@return SourceBuf
local function buffer(group_index, all_bufs)
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
local function async_path(group_index)
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
local Sources = {
    c = {
        { name = 'nvim_lsp', group_index = 1 },
        { name = 'nvim_lsp_signature_help', group_index = 2 },
        { name = 'vsnip', group_index = 3 },
        async_path(5),
        buffer(4),
    },

    lua = {
        { name = 'nvim_lsp', group_index = 1 },
        { name = 'nvim_lsp_signature_help', group_index = 2 },
        { name = 'nvim_lua', group_index = 3 },
        { name = 'vsnip', group_index = 4 },
        buffer(5),
    },
}

if exists('cmp_doxygen') then
    table.insert(Sources.c, { name = 'doxygen' })
end

if exists('lazydev') then
    table.insert(Sources.lua, {
        name = 'lazydev',
        group_index = 0,
    })
end

---@type SetupSources
local ft = {
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
                { name = 'nvim_lsp_signature_help', group_index = 2 },
                async_path(3),
                { name = 'vsnip', group_index = 4 },
                buffer(5),
            }),
        },
    },
    {
        { 'conf', 'config', 'cfg', 'confini', 'gitconfig' },
        {
            sources = gen_sources({
                buffer(1),
                async_path(2),
            }),
        },
    },
    {
        { 'c', 'cpp' },
        {
            sources = gen_sources(Sources.c),
        },
    },
    ['lua'] = {
        sources = gen_sources(Sources.lua),
    },
    ['lisp'] = {
        sources = gen_sources({
            { name = 'vlime', group_index = 1 },
            buffer(2),
        }),
    },
    ['gitcommit'] = {
        sources = gen_sources({
            { name = 'conventionalcommits', group_index = 1 },
            { name = 'git', group_index = 2 },
            async_path(3),
            buffer(4),
        }),
    },
}

if exists('neorg') then
    ft['norg'] = {
        sources = gen_sources({
            { name = 'neorg', group_index = 1 },
            buffer(2),
            async_path(3),
        }),
    }
end

---@type SetupSources
local cmdline = {
    {
        { '/', '?' },
        {
            mapping = cmp.mapping.preset.cmdline(),
            sources = gen_sources({
                { name = 'nvim_lsp_document_symbol', group_index = 1 },
                buffer(2),
            }),
        },
    },
    [':'] = {
        mapping = cmp.mapping.preset.cmdline(),
        sources = gen_sources({
            {
                name = 'cmdline',
                group_index = 1,
                option = { treat_trailing_slash = false },
            },
            async_path(2),
        }),

        ---@diagnostic disable-next-line:missing-fields
        matching = { disallow_symbol_nonprefix_matching = false },
    },
}

---@type Sources
---@diagnostic disable-next-line:missing-fields
local M = {
    setup = function(T)
        local notify = require('user_api.util.notify').notify

        if is_tbl(T) and not empty(T) then
            for k, v in next, T do
                if is_num(k) and is_tbl({ v[1], v[2] }, true) then
                    table.insert(ft, v)
                elseif is_str(k) and is_tbl(v) then
                    ft[k] = v
                else
                    notify(
                        "(plugin.cmp.sources.setup): Couldn't parse the input table value",
                        'error',
                        {
                            title = 'plugin.cmp.sources',
                            timeout = 500,
                        }
                    )
                end
            end
        end

        for k, v in next, ft do
            if is_num(k) and is_tbl({ v[1], v[2] }, true) then
                local names = v[1]
                local opts = v[2]

                cmp.setup.filetype(names, opts)
            elseif is_str(k) and is_tbl(v) then
                cmp.setup.filetype(k, v)
            else
                notify(
                    "(plugin.cmp.sources.setup): Couldn't parse the input table value",
                    'error',
                    {
                        title = 'plugin.cmp.sources',
                        timeout = 500,
                    }
                )
            end
        end

        require('cmp_git').setup()

        for k, v in next, cmdline do
            if is_num(k) and is_tbl({ v[1], v[2] }, true) then
                local names = v[1]
                local opts = v[2]

                cmp.setup.cmdline(names, opts)
            elseif is_str(k) and is_tbl(v) then
                cmp.setup.cmdline(k, v)
            else
                notify(
                    "(plugin.cmp.sources.setup): Couldn't parse the input table value",
                    'error',
                    {
                        title = 'plugin.cmp.sources',
                        timeout = 500,
                    }
                )
            end
        end
    end,

    buffer = buffer,
    async_path = async_path,
}

function M.new() return setmetatable({}, { __index = M }) end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
