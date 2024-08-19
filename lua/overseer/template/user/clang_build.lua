return {
    name = 'Build (clang)',
    builder = function()
        -- Full path to current file (see :help expand())
        local file = vim.fn.expand('%:p')
        return {
            cmd = { 'clang' },
            args = { file },
            components = { { 'on_output_quickfix', open = true }, 'default' },
        }
    end,
    condition = {
        filetype = { 'c' },
    },
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
