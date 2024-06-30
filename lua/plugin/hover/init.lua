---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user')
local Check = User.check
local maps_t = User.types.user.maps
local kmap = User.maps.kmap

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local nmap = kmap.n
local desc = kmap.desc

if not exists('hover') then
    return
end

local Hover = require('hover')

---@type Hover.Config
local Opts = {
    init = function()
        -- Providers
        if exists('lspconfig') then
            require('hover.providers.lsp')
        end

        require('hover.providers.man')

        --- Github
        require('hover.providers.gh')

        --- Github: Users
        require('hover.providers.gh_user')

        --- Jira
        -- require('hover.providers.jira')

        --- DAP
        -- require('hover.providers.dap')

        --- Dictionary
        -- require('hover.providers.dictionary')
    end,
    preview_opts = { border = 'single' },
    preview_window = false,
    title = true,
    mouse_providers = { 'LSP' },
    mouse_delay = 1000,
}

Hover.setup(Opts)

---@type Hover.Options
local HOpts = {
    bufnr = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win()),
    pos = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()),
}

---@type KeyMapDict
local Keys = {
    ['K'] = { Hover.hover, desc('Hover') },
    ['gK'] = { Hover.hover_select, desc('Hover Select') },
    ['<C-p>'] = {
        function()
            Hover.hover_switch('previous', HOpts)
        end,
        desc('Previous Hover'),
    },
    ['<C-n>'] = {
        function()
            Hover.hover_switch('next', HOpts)
        end,
        desc('Next Hover'),
    },
}

for lhs, v in next, Keys do
    v[2] = is_tbl(v[2]) and v[2] or {}
    nmap(lhs, v[1], v[2] or {})
end

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:confirm:fenc=utf-8:noignorecase:smartcase:ru:
