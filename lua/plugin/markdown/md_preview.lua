local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local executable = Check.exists.executable
local desc = User.maps.kmap.desc

local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local Fields = {
    browser = executable('firefox') and 'firefox'
        or (executable('xdg-open') and 'xdg-open' or 'open'),

    echo_preview_url = 1,

    auto_start = 1,
    auto_close = 0,

    open_to_the_world = 0,

    combine_preview = 1,
    combine_preview_auto_refresh = 1,

    preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 1,
        sync_scroll_type = 'relative',
        hide_yaml_meta = 0,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
    },

    page_title = '「${name}」',

    filetypes = { 'markdown' },
    theme = 'dark',
}

for key, value in next, Fields do
    vim.g['mkdp_' .. key] = value
end

local group = augroup('MarkdownPreviewInitHook', { clear = true })

au({ 'BufNew', 'BufWinEnter', 'BufEnter', 'BufRead', 'WinEnter' }, {
    pattern = { '*.md', '*.markdown', '*.MD' },
    group = group,
    callback = function(args)
        local bufnr = args.buf

        ---@type AllMaps
        local Keys = {
            ['<leader>f<C-M>'] = { group = '+MarkdownPreview', buffer = bufnr },

            ['<leader><C-p>'] = {
                ':MarkdownPreview<CR>',
                desc('Run Markdown Preview', true, bufnr),
            },

            ['<leader>f<C-M>t'] = {
                ':MarkdownPreviewToggle<CR>',
                desc('Toggle Markdown Preview', true, bufnr),
            },
            ['<leader>f<C-M>p'] = {
                ':MarkdownPreview<CR>',
                desc('Run Markdown Preview', true, bufnr),
            },
            ['<leader>f<C-M>s'] = {
                ':MarkdownPreviewStop<CR>',
                desc('Stop Markdown Preview', true, bufnr),
            },
        }

        Keymaps({ n = Keys }, bufnr)
    end,
})

User.register_plugin('plugin.markdown.md_preview')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
