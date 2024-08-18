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
    mkdp_browser = executable('firefox') and '/usr/bin/firefox' or 'xdg-open',
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

au({ 'BufNew', 'BufWinEnter', 'BufEnter', 'BufRead', 'WinEnter' }, {
    group = augroup('MarkdownPreviewInitHook', { clear = false }),
    pattern = { '*.md', '*.markdown', '*.MD' },
    callback = function()
        ---@type KeyMapDict
        local Keys = {
            ['<leader>f<C-M>t'] = {
                function() vim.cmd('MarkdownPreviewToggle') end,
                desc('Toggle Markdown Preview', true, 0),
            },
            ['<leader>f<C-M>p'] = {
                function() vim.cmd('MarkdownPreview') end,
                desc('Run Markdown Preview', true, 0),
            },
            ['<leader>f<C-M>s'] = {
                function() vim.cmd('MarkdownPreviewStop') end,
                desc('Stop Markdown Preview', true, 0),
            },
        }

        ---@type RegKeysNamed
        local Names = {
            ['<leader>f<C-M>'] = { group = '+MarkdownPreview' },
        }

        local bufnr = vim.api.nvim_get_current_buf()

        if WK.available() then
            map_dict(Names, 'wk.register', false, 'n', 0)
            map_dict(Names, 'wk.register', false, 'v', 0)
        end

        map_dict(Keys, 'wk.register', false, 'n', 0)
        map_dict(Keys, 'wk.register', false, 'v', 0)
    end,
})

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
