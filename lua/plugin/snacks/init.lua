local User = require('user_api')
local Check = User.check

local exists = Check.exists.module

if not exists('snacks') then
    return
end

local SNK = require('snacks')

SNK.setup({
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.diagnostics():set(true)
        Snacks.toggle.line_number():set(vim.o.number)
        Snacks.toggle.treesitter():set(true)
        Snacks.toggle.inlay_hints():set(true)
        Snacks.toggle.indent():set(true)
        Snacks.toggle.dim():set(true)
    end,
})

User:register_plugin('plugin.snacks', 2)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
