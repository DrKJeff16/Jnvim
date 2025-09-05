---@module 'lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable

---@type LazySpec[]
local Completion = {
    {
        'saghen/blink.cmp',
        version = false,
        dependencies = {
            {
                'L3MON4D3/LuaSnip',
                version = false,
                dependencies = {
                    'rafamadriz/friendly-snippets',
                    'benfowler/telescope-luasnip.nvim',
                },
                build = executable('make') and 'make -j $(nproc) install_jsregexp' or false,
                config = function(_, opts)
                    local luasnip = require('luasnip')
                    local ft_extend = luasnip.filetype_extend

                    if opts then
                        luasnip.config.setup(opts)
                    end
                    vim.tbl_map(function(type)
                        require('luasnip.loaders.from_' .. type).lazy_load()
                    end, { 'vscode', 'snipmate', 'lua' })

                    -- friendly-snippets - enable standardized comments snippets
                    ft_extend('c', { 'cdoc' })
                    ft_extend('cpp', { 'cppdoc' })
                    ft_extend('cs', { 'csharpdoc' })
                    ft_extend('java', { 'javadoc' })
                    ft_extend('javascript', { 'jsdoc' })
                    ft_extend('kotlin', { 'kdoc' })
                    ft_extend('lua', { 'luadoc' })
                    ft_extend('php', { 'phpdoc' })
                    ft_extend('python', { 'pydoc' })
                    ft_extend('ruby', { 'rdoc' })
                    ft_extend('rust', { 'rustdoc' })
                    ft_extend('sh', { 'shelldoc' })
                    ft_extend('typescript', { 'tsdoc' })
                end,
            },
            'onsails/lspkind.nvim',

            'folke/lazydev.nvim',
            'Kaiser-Yang/blink-cmp-git',
            'disrupted/blink-cmp-conventional-commits',
            {
                'bydlw98/blink-cmp-env',
                dev = true,
                version = false,
            },
            {
                'DrKJeff16/blink-cmp-sshconfig',
                branch = 'patch/build',
                dev = true,
                build = executable('uv') and 'make' or false,
                version = false,
            },
        },
        build = executable('cargo') and 'cargo build --release' or false,
        config = CfgUtil.require('plugin.blink_cmp'),
    },
    {
        'onsails/lspkind.nvim',
        version = false,
        config = CfgUtil.require('plugin.lspkind'),
        cond = not in_console(),
    },
}

return Completion

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
