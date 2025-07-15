---@module 'plugin._types.lsp'

local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable
local exists = Check.exists.module
local is_nil = Check.value.is_nil

if exists('neodev') then
    return
end

if not (exists('lazydev') and executable('lua-language-server')) then
    return
end

local LazyDev = require('lazydev')

---@type lazydev.Library.spec[]
local library = { path = '${3rd}/luv/library', words = { 'vim%.uv' } }

LazyDev.setup({
    runtime = vim.env.VIMRUNTIME --[[@as string]],

    library = library,

    ---@type boolean|(fun(root_dir: string): boolean?)
    enabled = function(root_dir)
        return not is_nil(vim.g.lazydev_enabled) and vim.g.lazydev_enabled or true
    end,

    integrations = {
        lspconfig = true,
        cmp = exists('cmp'),
        coq = false,
    },
})

User:register_plugin('plugin.lazydev')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
