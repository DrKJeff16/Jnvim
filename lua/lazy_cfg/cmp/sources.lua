---@diagnostic disable:unused-function
---@diagnostic disable:unused-local

local User = require('user')
local Check = User.check
local Util = User.util
local types = User.types.cmp

local exists = Check.exists.module
local is_nil = Check.value.is_nil
local is_num = Check.value.is_num
local is_int = Check.value.is_int
local is_tbl = Check.value.is_tbl
local is_str = Check.value.is_str
local empty = Check.value.empty

local cmp = require('cmp')

---@param priority? integer
---@return SourceBuf
local function buffer(priority)
    ---@type SourceBuf
    local res = {
        name = 'buffer',
        option = {
            -- keyword_pattern = [[\k\+]],
            keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-.]\w*\)*\)]],
            get_bufnrs = function()
                local bufs = {}
                for _, win in next, vim.api.nvim_list_wins() do
                    bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
            end,
        },
    }

    if is_int(priority) then
        res.priority = priority
    end

    return res
end

---@param priority? integer
---@return SourceAPath
local function async_path(priority)
    ---@type SourceAPath
    local res = {
        name = 'async_path',
        option = {
            trailing_slash = true,
            label_trailing_slash = true,
            show_hidden_files_by_default = true,
        },
    }

    if is_int(priority) then
        res.priority = priority
    end

    return res
end

---@type table<string, (cmp.SourceConfig|SourceBuf|SourceAPath)[]>
local Sources = {
    c = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
        async_path(),
        buffer(),
    },

    lua = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
        buffer(),
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
            'sh',
            'bash',
            'crontab',
            'zsh',
            'html',
            'markdown',
            'json',
            'json5',
            'jsonc',
            'yaml',
        },
        {
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                async_path(),
                { name = 'nvim_lsp_signature_help' },
                { name = 'luasnip' },
                buffer(),
            }),
        },
    },
    {
        { 'conf', 'config', 'cfg', 'confini', 'gitconfig', 'toml' },
        {
            sources = cmp.config.sources({
                async_path(),
                buffer(),
            }),
        },
    },
    {
        { 'c', 'cpp' },
        {
            sources = cmp.config.sources(Sources.c),
        },
    },
    ['lua'] = {
        sources = cmp.config.sources(Sources.lua),
    },
    ['lisp'] = {
        sources = cmp.config.sources({
            { name = 'vlime' },
            buffer(),
        }),
    },
    ['gitcommit'] = {
        sources = cmp.config.sources({
            { name = 'conventionalcommits' },
            { name = 'git' },
            async_path(),
            buffer(),
        }),
    },
}

if exists('neorg') then
    ft['norg'] = {
        sources = cmp.config.sources({
            { name = 'neorg' },
            async_path(),
            buffer(),
        }),
    }
end

---@type SetupSources
local cmdline = {
    {
        { '/', '?' },
        {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'nvim_lsp_document_symbol' },
                buffer(),
            }),
        },
    },
    [':'] = {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            {
                name = 'cmdline',
                option = { treat_trailing_slash = false },
            },
            async_path(),
        }),

        ---@diagnostic disable-next-line:missing-fields
        matching = { disallow_symbol_nonprefix_matching = false },
    },
}

---@type Sources
---@diagnostic disable-next-line:missing-fields
local M = {
    setup = function(T)
        local notify = require('user.util.notify').notify

        if is_tbl(T) and not empty(T) then
            for k, v in next, T do
                if is_num(k) and is_tbl({ v[1], v[2] }, true) then
                    table.insert(ft, v)
                elseif is_str(k) and is_tbl(v) then
                    ft[k] = v
                else
                    notify("(lazy_cfg.cmp.sources.setup): Couldn't parse the input table value", 'error', {
                        title = 'lazy_cfg.cmp.sources',
                        timeout = 500,
                    })
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
                notify("(lazy_cfg.cmp.sources.setup): Couldn't parse the input table value", 'error', {
                    title = 'lazy_cfg.cmp.sources',
                    timeout = 500,
                })
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
                notify("(lazy_cfg.cmp.sources.setup): Couldn't parse the input table value", 'error', {
                    title = 'lazy_cfg.cmp.sources',
                    timeout = 500,
                })
            end
        end
    end,

    buffer = buffer,
    async_path = async_path,
}

function M.new()
    return setmetatable({}, { __index = M })
end

return M
