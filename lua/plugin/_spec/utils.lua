---@module 'lazy'

---@type LazySpec[]
return {
    { 'epwalsh/pomo.nvim', version = false },
    {
        'hat0uma/doxygen-previewer.nvim',
        lazy = true,
        version = false,
        cmd = {
            'DoxygenOpen',
            'DoxygenUpdate',
            'DoxygenStop',
            'DoxygenLog',
            'DoxygenTempDoxyfileOpen',
        },
        dependencies = {
            {
                'hat0uma/prelive.nvim',
                lazy = true,
                version = false,
                cmd = {
                    'PreLiveGo',
                    'PreLiveStatus',
                    'PreLiveClose',
                    'PreLiveCloseAll',
                    'PreLiveLog',
                },
                opts = {
                    server = { host = '127.0.0.1', port = 0 },
                    http = {
                        tcp_max_backlog = 16, ---@type integer
                        tcp_recv_buffer_size = 1024, ---@type integer
                        keep_alive_timeout = 60 * 1000, ---@type integer
                        max_body_size = 1024 * 1024 * 1, ---@type integer
                        max_request_line_size = 1024 * 4, ---@type integer
                        max_header_field_size = 1024 * 4, ---@type integer
                        max_header_num = 100, ---@type integer
                        max_chunk_ext_size = 1024 * 1, ---@type integer
                    },
                    log = {
                        print_level = vim.log.levels.WARN,
                        file_level = vim.log.levels.DEBUG,
                        max_file_size = 1 * 1024 * 1024,
                        max_backups = 3,
                    },
                },
            },
        },
        opts = {
            tempdir = vim.fn.stdpath('cache'),
            update_on_save = true,
            doxygen = {
                cmd = 'doxygen',
                doxyfile_patterns = { 'Doxyfile', 'doc/Doxyfile' },
                fallback_cwd = function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    return vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
                end,
                --- Example:
                --- override_options = {
                ---   PROJECT_NAME = "PreviewProject",
                ---   HTML_EXTRA_STYLESHEET = vim.fn.stdpath("config") .. "/stylesheet.css"
                --- }
                ---@type table<string, string|fun():string>
                override_options = {},
            },
        },
        enabled = require('user_api.check.exists').executable('doxygen'),
    },
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
