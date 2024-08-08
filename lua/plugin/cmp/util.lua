---@diagnostic disable:unused-local
---@diagnostic disable:unused-function
---@diagnostic disable:missing-fields

local User = require('user_api')
local Check = User.check
local types = User.types.cmp

local exists = Check.exists.module
local modules = Check.exists.modules
local is_nil = Check.value.is_nil
local is_bool = Check.value.is_bool
local is_tbl = Check.value.is_tbl

if not exists('cmp') then
    error('Either `cmp` is not installed.')
end

local cmp = require('cmp')
local Types = require('cmp.types')
local CmpTypes = require('cmp.types.cmp')

local tbl_contains = vim.tbl_contains
local get_mode = vim.api.nvim_get_mode
local buf_lines = vim.api.nvim_buf_get_lines
local win_cursor = vim.api.nvim_win_get_cursor

local M = {}

---@return boolean
function M.has_words_before()
    unpack = unpack or table.unpack

    local line, col = unpack(win_cursor(vim.api.nvim_get_current_win()))
    return col ~= 0 and buf_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

function M.feedkey(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

---@param fallback fun()
function M.n_select(fallback)
    ---@type cmp.SelectOption
    local opts = { behavior = cmp.SelectBehavior.Insert }

    if cmp.visible() then
        cmp.select_next_item(opts)
    elseif vim.fn['vsnip#available'](1) == 1 then
        M.feedkey('<Plug>(vsnip-expand-or-jump)', '')
    elseif M.has_words_before() then
        cmp.complete()
        if cmp.visible() then
            cmp.select_next_item(opts)
        end
    else
        fallback()
    end
end

---@param fallback fun()
function M.n_shift_select(fallback)
    ---@type cmp.SelectOption
    local opts = { behavior = cmp.SelectBehavior.Replace }

    if cmp.visible() then
        cmp.select_prev_item(opts)
    elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        M.feedkey('<Plug>(vsnip-jump-prev)', '')
    elseif M.has_words_before() then
        cmp.complete()
        if cmp.visible() then
            cmp.select_prev_item(opts)
        end
    else
        fallback()
    end
end

---@param opts? cmp.ConfirmationConfig
---@return fun(fallback: fun())
function M.confirm(opts)
    opts = is_tbl(opts) and opts or {}
    opts.behavior = not is_nil(opts.behavior) and opts.behavior or cmp.ConfirmBehavior.Replace
    opts.select = is_bool(opts.select) and opts.select or false

    ---@type fun(fallback: fun())
    return function(fallback)
        if cmp.visible() and cmp.get_selected_entry() then
            cmp.confirm(opts)
        else
            fallback()
        end
    end
end

---@type TabMap
M.tab_map = {
    i = M.n_select,
    s = M.n_select,

    ---@param fallback fun()
    c = function(fallback)
        local opts = { behavior = cmp.SelectBehavior.Insert }

        if cmp.visible() then
            cmp.select_next_item(opts)
        elseif M.has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end,
}

M.s_tab_map = {
    i = M.n_shift_select,
    s = M.n_shift_select,

    ---@param fallback fun()
    c = function(fallback)
        local opts = { behavior = cmp.SelectBehavior.Select }

        if cmp.visible() then
            cmp.select_prev_item(opts)
        elseif M.has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end,
}

---@type CrMap
M.cr_map = {
    i = M.confirm(),
    s = M.confirm(),
    c = M.confirm({ select = true }),
}

---@param fallback fun()
function M.bs_map(fallback)
    if cmp.visible() then
        cmp.close()
    end

    fallback()
end

return M

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
