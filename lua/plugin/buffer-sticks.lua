---@module 'lazy'

---@type LazySpec
return {
    'ahkohd/buffer-sticks.nvim',
    dev = true,
    version = false,
    config = function()
        require('buffer-sticks').setup({
            position = 'right', ---@type 'right'|'left'
            width = 3, ---@type integer
            offset = { x = 1, y = 0 }, ---@type { x: integer, y: integer }
            active_char = '──', ---@type string
            inactive_char = ' ─', ---@type string
            jump = { show = { 'filename', 'space', 'label' } },
            label = { show = 'always' },
            transparent = true, ---@type boolean
            -- Overrides `transparent`
            -- winblend = 100, ---@type integer
            filter = {
                filetypes = { 'terminal' },
            },
            highlights = {
                active = { link = 'Statement' },
                inactive = { link = 'Whitespace' },
                label = { link = 'Comment' },
            },
        })
    end,
}
-- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
