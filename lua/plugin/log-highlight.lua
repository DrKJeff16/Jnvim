---@module 'lazy'

---@type LazySpec
return {
    'fei6409/log-highlight.nvim',
    version = false,
    opts = {
        extension = 'log', ---@type string|string[]
        filename = { 'syslog' }, ---@type string|string[]
        pattern = { ---@type string|string[]
            -- Use `%` to escape special characters and match them literally.
            '%/var%/log%/.*',
            'console%-ramoops.*',
            'log.*%.txt',
            'logcat.*',
            '.*%.log',
        },
        ---This allows you to define custom keywords to be highlighted based on
        ---the group.
        ---
        ---The following highlight groups are supported:
        ---    'error', 'warning', 'info', 'debug' and 'pass'.
        ---
        ---The value for each group can be a string or a list of strings.
        ---All groups are empty by default. Keywords are case-sensitive.
        keyword = { ---@type table<string, string|string[]>
            error = 'ERROR_MSG',
            warning = { 'WARN_X', 'WARN_Y' },
            info = { 'INFORMATION' },
            debug = {},
            pass = {},
        },
    },
}
