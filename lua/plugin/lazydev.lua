---@module 'lazy'

---@type LazySpec
return {
    'folke/lazydev.nvim',
    version = false,
    dependencies = {
        { 'DrKJeff16/wezterm-types', lazy = true, dev = true, version = false },
    },
    enabled = require('user_api.check.exists').executable('lua-language-server'),
    opts = { ---@type lazydev.Config
        runtime = vim.env.VIMRUNTIME,
        library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            { path = 'snacks.nvim', words = { 'Snacks' } },
            { path = 'wezterm-types', mods = { 'wezterm' } },
        },
        enabled = function(root_dir) ---@type boolean|(fun(root_dir: string): boolean)
            local fs_stat = (vim.uv or vim.loop).fs_stat
            return not (fs_stat(root_dir .. '/.luarc.json') or fs_stat(root_dir .. '/luarc.json'))
        end,
        integrations = {
            lspconfig = true,
            cmp = true,
            coq = false,
        },
    },
    config = function(_, opts) ---@param opts lazydev.Config
        require('lazydev').setup(opts)
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
