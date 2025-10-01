---@module 'lazy'

---@type LazySpec
return {
    'nvim-tree/nvim-web-devicons',
    version = false,
    cond = not require('user_api.check').in_console(),
    opts = {
        color_icons = true,
        default_icons = true,
        strict = true,
        variant = 'dark',
        override = {},
        override_by_filename = {
            ['.gitignore'] = {
                icon = '',
                color = '#f1502f',
                name = 'Gitignore',
            },
        },
        override_by_extension = {},
        override_by_operating_system = {
            ['apple'] = {
                icon = '',
                color = '#A2AAAD',
                cterm_color = '248',
                name = 'Apple',
            },
        },
    },
    config = function(_, opts)
        require('nvim-web-devicons').setup(opts)
        require('nvim-web-devicons').set_up_highlights()
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
