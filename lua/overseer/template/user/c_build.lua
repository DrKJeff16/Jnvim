return {
    name = 'Build (gcc)',
    builder = function()
        -- Full path to current file (see :help expand())
        local file = vim.fn.expand('%:p')
        return {
            cmd = { 'gcc' },
            args = { file },
            components = { { 'on_output_quickfix', open = true }, 'default' },
        }
    end,
    condition = {
        filetype = { 'c' },
    },
}
