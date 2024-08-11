---@diagnostic disable:unused-local
---@diagnostic disable:unused-function

local User = require('user_api')
local Check = User.check
local Util = User.util
local types = User.types.lspconfig

local executable = Check.exists.executable
local exists = Check.exists.module
local is_nil = Check.value.is_nil

if not (exists('lazydev') and executable('lua-language-server') and not exists('neodev')) then
    return
end

local LazyDev = require('lazydev')

---@type lazydev.Library.spec[]
local library = vim.deepcopy(vim.opt.rtp:get())
table.insert(library, { path = 'luvit-meta/library', words = { 'vim%.uv' } })

LazyDev.setup({
    runtime = vim.env.VIMRUNTIME --[[@as string]],

    library = library,

    ---@type boolean|(fun(root_dir): boolean?)
    enabled = function(root_dir)
        return not is_nil(vim.g.lazydev_enabled) and vim.g.lazydev_enabled or true
    end,

    integrations = {
        lspconfig = true,
        cmp = exists('cmp'),
        coq = false,
    },
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
