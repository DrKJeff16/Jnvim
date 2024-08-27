local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local executable = Check.exists.executable
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not exists('hover') then
    return
end

User:register_plugin('plugin.hover')

local Hover = require('hover')

Hover.setup({
    --- Setup Providers
    init = function()
        exists('hover.providers.fold_preview', true)
        exists('hover.providers.diagnostic', true)
        exists('hover.providers.lsp', true)

        if executable('man') then
            exists('hover.providers.man', true)
        end

        if executable('gh') then
            --- Github
            exists('hover.providers.gh', true)
            --- Github: Users
            exists('hover.providers.gh_user', true)
        end

        --- Dictionary
        -- exists('hover.providers.dictionary', true)

        --- Jira
        -- exists('hover.providers.jira', true)

        --- DAP
        -- exists('hover.providers.dap', true)
    end,
    preview_opts = {
        ---@type 'none'|'single'|'double'|'rounded'|'solid'|'shadow'|table
        border = 'rounded',
    },
    preview_window = true,
    title = false,
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
    ['K'] = { Hover.hover, desc('Hover', true, HOpts.bufnr()) },
    ['gK'] = { Hover.hover_select, desc('Hover Select', true, HOpts.bufnr()) },
    ['<C-p>'] = {
        function() Hover.hover_switch('previous', HOpts) end,
        desc('Previous Hover', true, HOpts.bufnr()),
    },
    ['<C-n>'] = {
        function() Hover.hover_switch('next', HOpts) end,
        desc('Next Hover', true, HOpts.bufnr()),
    },
}

-- Mouse support (if mouse enabled)
if vim.opt.mouse:get()['a'] then
    Keys['<MouseMove>'] = { Hover.hover_mouse, desc('Mouse Hover', true, HOpts.bufnr()) }
    vim.opt.mousemoveevent = true
end

map_dict(Keys, 'wk.register', false, 'n', HOpts.bufnr())

--[[ -- Simple
require('hover').register {
    name = 'Simple',
    --- @param bufnr integer
    enabled = function(bufnr)
        return true
    end,
    --- @param opts Hover.Options
    --- @param done fun(result: any)
    execute = function(opts, done)
        done{lines={'TEST'}, filetype="markdown"}
    end,
    priority = 1000,
} ]]

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
