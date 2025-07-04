local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local executable = Check.exists.executable
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not exists('hover') then
    return
end

local Hover = require('hover')

Hover.setup({
    --- Setup Providers
    init = function()
        if exists('hover.providers.fold_preview') then
            require('hover.providers.fold_preview')
        end

        if exists('hover.providers.diagnostic') then
            require('hover.providers.diagnostic')
        end

        if exists('hover.providers.lsp') then
            require('hover.providers.lsp')
        end

        if executable('man') and exists('hover.providers.man') then
            require('hover.providers.man')
        end

        -- if executable('gh') then
        --     --- Github
        --     if exists('hover.providers.gh') then
        --         require('hover.providers.gh')
        --     end
        --
        --     --- Github: Users
        --     if exists('hover.providers.gh_user') then
        --         require('hover.providers.gh_user')
        --     end
        -- end

        --- Dictionary
        -- if exists('hover.providers.dictionary') then
        --     require('hover.providers.dictionary')
        -- end

        --- Jira
        -- if exists('hover.providers.jira') then
        --     require('hover.providers.jira')
        -- end

        --- DAP
        -- if exists('hover.providers.dap') then
        --     require('hover.providers.dap')
        -- end
    end,

    preview_opts = {
        ---@type 'none'|'single'|'double'|'rounded'|'solid'|'shadow'|table
        border = 'double',
    },
    preview_window = true,
    title = true,
    mouse_providers = { 'LSP' },
    mouse_delay = 500,
})

---@type Hover.Options
local HOpts = {
    ---@type fun(): integer
    bufnr = vim.api.nvim_get_current_buf,
    ---@return integer[]
    pos = function() return vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()) end,
}

---@type KeyMapDict
local Keys = {
    ['K'] = { Hover.hover, desc('Hover') },
    ['gK'] = { Hover.hover_select, desc('Hover Select') },
    ['<C-p>'] = {
        function() Hover.hover_switch('previous', HOpts) end,
        desc('Previous Hover'),
    },
    ['<C-n>'] = {
        function() Hover.hover_switch('next', HOpts) end,
        desc('Next Hover'),
    },
}

-- Mouse support (if mouse enabled)
if vim.opt.mouse:get()['a'] then
    Keys['<MouseMove>'] = { Hover.hover_mouse, desc('Mouse Hover') }
    vim.opt.mousemoveevent = true
end

map_dict(Keys, 'wk.register', false, 'n')

User:register_plugin('plugin.hover')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
