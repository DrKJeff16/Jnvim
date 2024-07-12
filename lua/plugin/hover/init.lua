---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check
local maps_t = User.types.user.maps
local kmap = User.maps.kmap

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local desc = kmap.desc
local map_dict = User.maps.map_dict

if not exists('hover') then
    return
end

local Hover = require('hover')

Hover.setup({
    --- Setup Providers
    init = function()
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
    preview_window = true,
    title = true,
    mouse_providers = { 'LSP' },
    mouse_delay = 1000,
})

---@type Hover.Options
local HOpts = {
    ---@return integer
    bufnr = function()
        return vim.api.nvim_get_current_buf()
    end,
    ---@return integer[]
    pos = function()
        return vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
    end,
}

---@type KeyMapDict
local Keys = {
    ['K'] = { Hover.hover, desc('Hover', false, HOpts.bufnr()) },
    ['gK'] = { Hover.hover_select, desc('Hover Select', false, HOpts.bufnr()) },
    ['<C-p>'] = {
        function()
            Hover.hover_switch('previous', HOpts)
        end,
        desc('Previous Hover', true, HOpts.bufnr()),
    },
    ['<C-n>'] = {
        function()
            Hover.hover_switch('next', HOpts)
        end,
        desc('Next Hover', true, HOpts.bufnr()),
    },
}

map_dict(Keys, 'wk.register', false, 'n', HOpts.bufnr())

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
