---@module 'lazy'

---@type LazySpec
return {
    'numToStr/Comment.nvim',
    event = 'InsertEnter',
    version = false,
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
        local User = require('user_api')
        local Check = User.check
        local exists = Check.exists.module

        local Comment = require('Comment')

        ---Function to call before (un)comment.
        ---
        ---It is called with a `ctx` argument of type
        ---[`comment.utils.CommentCtx`](lua://CommentCtx).
        ---
        ---(default: `nil`)
        --- ---
        ---@return string
        local function pre_hook(_)
            return vim.bo.commentstring
        end

        local function post_hook(_)
            local bufnr = vim.api.nvim_get_current_buf()
            local win = vim.api.nvim_get_current_win()

            local r = unpack(vim.api.nvim_win_get_cursor(win))

            if vim.api.nvim_buf_line_count(bufnr) > r then
                vim.api.nvim_win_set_cursor(win, { r + 1, 0 })
            end
        end

        if exists('ts_context_commentstring') then
            pre_hook =
                require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
        end

        ---@diagnostic disable-next-line:missing-fields
        Comment.setup({
            pre_hook = pre_hook,
            post_hook = post_hook,

            -- Add a space b/w comment and the line
            padding = true,

            -- Whether the cursor should stay at its position
            sticky = true,

            -- LHS of toggle mappings in NORMAL mode
            toggler = {
                -- Line-comment toggle keymap
                line = 'gcc',
                -- Block-comment toggle keymap
                block = 'gbc',
            },

            -- LHS of operator-pending mappings in NORMAL and VISUAL mode
            opleader = {
                -- Line-comment keymap
                line = 'gc',

                -- Block-comment keymap
                block = 'gb',
            },

            -- LHS of extra mappings
            extra = {
                -- Add comment on the line above
                above = 'gcO',

                -- Add comment on the line below
                below = 'gco',

                -- Add comment at the end of line
                eol = 'gcA',
            },

            ---Enable keybindings
            ---NOTE: If given `false` then the plugin won't create any mappings
            mappings = {
                -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
                basic = true,

                -- Extra mapping; `gco`, `gcO`, `gcA`
                extra = true,
            },
        })
    end,
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:ci:pi:
