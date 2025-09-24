local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable
local exists = Check.exists.module

local fs_stat = (vim.uv or vim.loop).fs_stat

if exists('neodev') then
    return
end
if not (exists('lazydev') and executable('lua-language-server')) then
    return
end

local LazyDev = require('lazydev')

LazyDev.setup({
    runtime = vim.env.VIMRUNTIME,

    library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'wezterm-types', mods = { 'wezterm' } },
    },

    ---@type boolean|(fun(root_dir: string): boolean)
    enabled = function(root_dir)
        return not (fs_stat(root_dir .. '/.luarc.json') or fs_stat(root_dir .. '/luarc.json'))
    end,

    integrations = {
        lspconfig = true,
        cmp = true,
        coq = false,
    },
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
