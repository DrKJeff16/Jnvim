local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable
local exists = Check.exists.module

if exists('neodev') then
    User.deregister_plugin('plugin.lazydev')
    return
end

if not (exists('lazydev') and executable('lua-language-server')) then
    User.deregister_plugin('plugin.lazydev')
    return
end

local fs_stat = (vim.uv or vim.loop).fs_stat

local LazyDev = require('lazydev')

---@type (lazydev.Library.spec)[]
local library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    {
        path = vim.fn.environ()['HOME'] .. '/Projects/nvim/wezterm-types',
        mods = { 'wezterm' },
    },
}

LazyDev.setup({
    runtime = vim.env.VIMRUNTIME,

    library = library,

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

User.register_plugin('plugin.lazydev')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
