---@module 'lazy'

---@type LazySpec
return {
    'nvim-mini/mini.icons',
    version = false,
    cond = not require('user_api.check').in_console(),
    opts = {
        style = 'glyph',
        default = {
            -- Override default glyph for "file" category (reuse highlight group)
            file = { glyph = '󰈤' },
        },
        extension = {
            -- Override highlight group (not necessary from 'mini.icons')
            lua = { hl = 'Special' },

            -- Add icons for custom extension. This will also be used in
            -- 'file' category for input like 'file.my.ext'.
            -- ['my.ext'] = { glyph = '󰻲', hl = 'MiniIconsRed' },
        },
    },
    config = function(_, opts)
        require('mini.icons').setup(opts)
        _G.MiniIcons.mock_nvim_web_devicons()
        _G.MiniIcons.tweak_lsp_kind('prepend')
    end,
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
