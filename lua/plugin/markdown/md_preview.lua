local User = require('user_api')
local Check = User.check
local maps_t = User.types.user.maps
local WK = User.maps.wk

local executable = Check.exists.executable
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

User.register_plugin('plugin.markdown.md_preview')

local Fields = {
    mkdp_auto_start = 0,
    mkdp_browser = executable('firefox') and '/usr/bin/firefox' or '',
    mkdp_echo_preview_url = 1,
    mkdp_open_to_the_world = 0,
    mkdp_auto_close = 1,
    mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'relative',
        hide_yaml_meta = 0,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
    },
    mkdp_filetypes = { 'markdown' },
    mkdp_theme = 'dark',
}

for k, v in next, Fields do
    vim.g[k] = v
end

au({ 'BufNew', 'BufWinEnter', 'BufEnter', 'BufRead' }, {
    group = augroup('MarkdownPreviewInitHook', { clear = true }),
    pattern = '*.md',
    callback = function()
        ---@type KeyMapModeDict
        local Keys = {
            n = {
                ['<leader>f<C-m>t'] = {
                    function() vim.cmd('MarkdownPreviewToggle') end,
                    desc('Toggle Markdown Preview'),
                },
                ['<leader>f<C-m>p'] = {
                    function() vim.cmd('MarkdownPreview') end,
                    desc('Run Markdown Preview'),
                },
                ['<leader>f<C-m>s'] = {
                    function() vim.cmd('MarkdownPreviewStop') end,
                    desc('Stop Markdown Preview'),
                },
            },
            v = {
                ['<leader>f<C-m>t'] = {
                    function() vim.cmd('MarkdownPreviewToggle') end,
                    desc('Toggle Markdown Preview'),
                },
                ['<leader>f<C-m>p'] = {
                    function() vim.cmd('MarkdownPreview') end,
                    desc('Run Markdown Preview'),
                },
                ['<leader>f<C-m>s'] = {
                    function() vim.cmd('MarkdownPreviewStop') end,
                    desc('Stop Markdown Preview'),
                },
            },
        }

        ---@type ModeRegKeysNamed
        local Names = {
            n = { ['<leader>f<C-m>'] = { group = '+MarkdownPreview' } },
            v = { ['<leader>f<C-m>'] = { group = '+MarkdownPreview' } },
        }

        local bufnr = vim.api.nvim_get_current_buf()

        if WK.available() then
            map_dict(Names, 'wk.register', true, nil, 0)
        end
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
