---@module 'config.lazy'

local CfgUtil = require('config.util')
local User = require('user_api')
local Check = User.check

local flag_installed = CfgUtil.flag_installed
local executable = Check.exists.executable

local curr_buf = vim.api.nvim_get_current_buf

---@type LazySpecs
local Utils = {
    {
        'vimwiki/vimwiki',
        priority = 1000,
        version = false,
        init = flag_installed('vimwiki', function()
            vim.g.vimwiki_list = {
                {
                    path = '~/.vimwiki',
                    syntax = 'default',
                    ext = '.wiki',
                },
            }
        end),
        enabled = false,
    },
    {
        'vim-scripts/UTL.vim',
        version = false,
        init = flag_installed('utl'),
    },

    {
        'epwalsh/pomo.nvim',
        event = 'VeryLazy',
        version = false,
    },

    {
        'hat0uma/doxygen-previewer.nvim',
        event = 'VeryLazy',
        version = false,
        cmd = {
            'DoxygenOpen',
            'DoxygenUpdate',
            'DoxygenStop',
            'DoxygenLog',
            'DoxygenTempDoxyfileOpen',
        },
        dependencies = { 'hat0uma/prelive.nvim' },
        opts = {
            --- Path to output doxygen results
            tempdir = vim.fn.stdpath('cache'),
            --- If true, update automatically when saving.
            update_on_save = true,
            --- doxygen settings section
            doxygen = {
                --- doxygen executable
                cmd = 'doxygen',
                --- doxyfile pattern.
                --- Search upward from the parent directory of the file to be previewed and use the first match.
                --- The directory matching the pattern is used as the cwd when doxygen is run.
                --- If not matched, doxygen's default settings will be used. (see `doxygen -g -`)
                doxyfile_patterns = {
                    'Doxyfile',
                    'doc/Doxyfile',
                },
                --- If the pattern in `doxyfile_patterns` setting is not found, use this parameter as cwd when running doxygen.
                fallback_cwd = function()
                    return vim.fs.dirname(vim.api.nvim_buf_get_name(curr_buf()))
                end,
                --- doxygen options to override.
                --- For details, see [Doxygen configuration](https://www.doxygen.nl/manual/config.html).
                --- Also, other options related to generation are overridden by default. see `Doxygen Options` section in README.md.
                --- If a function is specified in the value, it will be evaluated at runtime.
                --- For example:
                --- override_options = {
                ---   PROJECT_NAME = "PreviewProject",
                ---   HTML_EXTRA_STYLESHEET = vim.fn.stdpath("config") .. "/stylesheet.css"
                --- }
                --- @type table<string, string|fun():string>
                override_options = {},
            },
        },
        cond = executable('doxygen'),
    },
    {
        'hat0uma/prelive.nvim',
        event = 'VeryLazy',
        version = false,
        cmd = {
            'PreLiveGo',
            'PreLiveStatus',
            'PreLiveClose',
            'PreLiveCloseAll',
            'PreLiveLog',
        },
        opts = {
            server = {
                --- The host to bind the server to.
                --- It is strongly recommended not to expose it to the external network.
                host = '127.0.0.1',

                --- The port to bind the server to.
                --- If the value is 0, the server will bind to a random port.
                port = 0,
            },

            http = {
                --- maximum number of pending connections.
                ---
                --- If the number of pending connections is greater than this value,
                --- the client will receive ECONNREFUSED.
                --- @type integer
                tcp_max_backlog = 16,

                --- tcp recv buffer size.
                ---
                --- The size of the buffer used to receive data from the client.
                --- This value is used for `vim.uv.recv_buffer_size()`.
                --- @type integer
                tcp_recv_buffer_size = 1024,

                --- http keep-alive timeout in milliseconds.
                ---
                --- If the client does not send a new request within this time,
                --- the server will close the connection.
                --- @type integer
                keep_alive_timeout = 60 * 1000,

                --- request body size limit
                ---
                --- If the request body size exceeds this value,
                --- the server will return 413 Payload Too Large.
                --- @type integer
                max_body_size = 1024 * 1024 * 1,

                --- request line size limit
                --- The request line consists of the request method,
                --- request URI, and HTTP version.
                ---
                --- If the request line size exceeds this value,
                --- the server will return 414 URI Too Long.
                --- @type integer
                max_request_line_size = 1024 * 4,

                --- header field size limit (key + value)
                ---
                --- If the size of a header field exceeds this value,
                --- the server will return 431 Request Header Fields Too Large.
                --- @type integer
                max_header_field_size = 1024 * 4,

                --- max header count.
                ---
                --- If the number of header fields exceeds this value,
                --- the server will return 431 Request Header Fields Too Large.
                --- @type integer
                max_header_num = 100,

                --- max chunk-ext size limit for chunked body
                ---
                --- If the size of a chunk-ext exceeds this value,
                --- the server will return 400 Bad Request.
                --- @type integer
                max_chunk_ext_size = 1024 * 1,
            },

            log = {
                --- The log levels to print. see `vim.log.levels`.
                print_level = vim.log.levels.WARN,

                --- The log levels to write to the log file. see `vim.log.levels`.
                file_level = vim.log.levels.DEBUG,

                --- The maximum size of the log file in bytes.
                --- If 0, it does not output.
                max_file_size = 1 * 1024 * 1024,

                --- The maximum number of log files to keep.
                max_backups = 3,
            },
        },
    },
}

return Utils

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
