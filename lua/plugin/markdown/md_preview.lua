local Keymaps = require('config.keymaps')
local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable
local desc = User.maps.kmap.desc

local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

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

for key, value in next, Fields do
    vim.g[key] = value
end

local group = augroup('MarkdownPreviewInitHook', { clear = false })

au({ 'BufNew', 'BufWinEnter', 'BufEnter', 'BufRead', 'WinEnter' }, {
    pattern = { '*.md', '*.markdown', '*.MD' },
    group = group,
    callback = function(args)
        local bufnr = args.buf

        ---@type AllMaps
        local Keys = {
            ['<leader>f<C-M>'] = { group = '+MarkdownPreview', buffer = bufnr },

            ['<leader>f<C-M>t'] = {
                ---@diagnostic disable-next-line
                function()
                    pcall(vim.cmd, 'MarkdownPreviewToggle')
                end,
                desc('Toggle Markdown Preview', true, bufnr),
            },
            ['<leader>f<C-M>p'] = {
                ---@diagnostic disable-next-line
                function()
                    pcall(vim.cmd, 'MarkdownPreview')
                end,
                desc('Run Markdown Preview', true, bufnr),
            },
            ['<leader>f<C-M>s'] = {
                ---@diagnostic disable-next-line
                function()
                    pcall(vim.cmd, 'MarkdownPreviewStop')
                end,
                desc('Stop Markdown Preview', true, bufnr),
            },
        }

        Keymaps:setup({ n = Keys }, bufnr)
    end,
})

User:register_plugin('plugin.markdown.md_preview')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
