---@module 'lazy'

---@type LazySpec
return {
    'ThePrimeagen/refactoring.nvim',
    lazy = false,
    version = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        require('refactoring').setup({
            prompt_func_return_type = {
                go = false,
                java = false,

                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            prompt_func_param_type = {
                go = false,
                java = false,

                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
            -- shows a message with information about the refactor on success
            -- i.e. [Refactor] Inlined 3 variable occurrences
            show_success_message = false,
        })
        local Keymaps = require('user_api.config.keymaps')
        local desc = require('user_api.maps').desc
        Keymaps({
            n = {
                ['<leader>r'] = { group = '+Refactoring' },

                ['<leader>rB'] = {
                    ':Refactor extract_block_to_file',
                    desc('Extlarn Block To File'),
                },
                ['<leader>rb'] = {
                    ':Refactor extract_block',
                    desc('Extract Block'),
                },
                ['<leader>ri'] = {
                    ':Refactor inline_var',
                    desc('Inline Var'),
                },
                ['<leader>rI'] = {
                    ':Refactor inline_func',
                    desc('Inline Func'),
                },
            },

            x = {
                ['<leader>r'] = { group = '+Refactoring' },

                ['<leader>re'] = {
                    ':Refactor extract ',
                    desc('Extract'),
                },
                ['<leader>rf'] = {
                    ':Refactor extract_to_file ',
                    desc('Extract To File'),
                },
                ['<leader>ri'] = {
                    ':Refactor inline_var',
                    desc('Inline Var'),
                },
                ['<leader>rv'] = {
                    ':Refactor extract_var ',
                    desc('Extract Var'),
                },
            },
        })

        vim.keymap.set({ 'n', 'x' }, '<leader>re', function()
            return require('refactoring').refactor('Extract Function')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>rf', function()
            return require('refactoring').refactor('Extract Function To File')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>rv', function()
            return require('refactoring').refactor('Extract Variable')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>rI', function()
            return require('refactoring').refactor('Inline Function')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>ri', function()
            return require('refactoring').refactor('Inline Variable')
        end, { expr = true })

        vim.keymap.set({ 'n', 'x' }, '<leader>rbb', function()
            return require('refactoring').refactor('Extract Block')
        end, { expr = true })
        vim.keymap.set({ 'n', 'x' }, '<leader>rbf', function()
            return require('refactoring').refactor('Extract Block To File')
        end, { expr = true })
    end,
}
