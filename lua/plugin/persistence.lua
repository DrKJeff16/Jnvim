---@module 'lazy'

---@type LazySpec
return {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    version = false,
    opts = {
        dir = vim.fn.stdpath('state') .. '/sessions/', -- directory where session files are saved
        -- minimum number of file buffers that need to be open to save
        -- Set to 0 to always save
        need = 1,
        branch = false, -- use git branch to save session
    },
    config = function(_, opts)
        require('persistence').setup(opts)

        local desc = require('user_api.maps').desc
        require('user_api.config').keymaps({
            n = {
                ['<leader>s'] = { group = '+Session' },
                ['<leader>ss'] = {
                    require('persistence').load,
                    desc('Load Session For Current Dir'),
                },
                ['<leader>sS'] = { require('persistence').select, desc('Select Session') },
                ['<leader>sd'] = { require('persistence').stop, desc('Stop Session') },
                ['<leader>sl'] = {
                    function()
                        require('persistence').load({ last = true })
                    end,
                    desc('Load Last Session'),
                },
            },
        })
    end,
}

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:
