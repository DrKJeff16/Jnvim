local Keymaps = require('user_api.config.keymaps')
local User = require('user_api')
local Check = User.check

local exists = Check.exists.module
local desc = User.maps.kmap.desc

if not exists('persistence') then
    return
end

local P = require('persistence')

P.setup({
    dir = vim.fn.stdpath('state') .. '/sessions/', -- directory where session files are saved
    -- minimum number of file buffers that need to be open to save
    -- Set to 0 to always save
    need = 0,
    branch = true, -- use git branch to save session
})

---@type AllMaps
local Keys = {
    ['<leader>s'] = { group = '+Session' },

    ['<leader>ss'] = { P.load, desc('Load Session For Current Dir') },
    ['<leader>sS'] = { P.select, desc('Select Session') },
    ['<leader>sd'] = { P.stop, desc('Stop Session') },

    ['<leader>sl'] = {
        function()
            P.load({ last = true })
        end,
        desc('Load Last Session'),
    },
}

Keymaps({ n = Keys })

User.register_plugin('plugin.persistence')

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
