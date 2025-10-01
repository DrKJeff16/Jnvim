---@module 'lazy'

local function post_hook(_)
    local bufnr = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    local r = unpack(vim.api.nvim_win_get_cursor(win))
    if vim.api.nvim_buf_line_count(bufnr) > r then
        vim.api.nvim_win_set_cursor(win, { r + 1, 0 })
    end
end

---@type LazySpec
return {
    'numToStr/Comment.nvim',
    event = 'BufEnter',
    version = false,
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
    opts = { ---@type CommentConfig
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        post_hook = post_hook,
        ignore = 'nil',
        padding = true,
        sticky = true,
        toggler = { line = 'gcc', block = 'gbc' },
        opleader = { line = 'gc', block = 'gb' },
        extra = { above = 'gcO', below = 'gco', eol = 'gcA' },
        mappings = { basic = true, extra = true },
    },
    config = function(_, opts) ---@param opts CommentConfig
        require('Comment').setup(opts)
    end,
}
--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
