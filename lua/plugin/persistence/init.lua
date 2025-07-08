local User = require('user_api')
local Keymaps = require('config.keymaps')
local Check = User.check

local exists = Check.exists.module
local desc = User.maps.kmap.desc

if not exists('persistence') then
    return
end

User:register_plugin('plugin.persistence')

local Pst = require('persistence')

Pst.setup({
    dir = vim.fn.stdpath('state') .. '/sessions/', -- directory where session files are saved
    -- minimum number of file buffers that need to be open to save
    -- Set to 0 to always save
    need = 1,
    branch = true, -- use git branch to save session
})

---@type AllMaps
local Keys = {
    ['<leader>S'] = { group = '+Session (Persistence)' },

    ['<leader>Sr'] = { Pst.load, desc('Restore Session') },
    ['<leader>Sd'] = { Pst.stop, desc("Don't Save Current Session") },
    ['<leader>Sl'] = {
        function()
            Pst.load({ last = true })
        end,
        desc('Restore Last Session'),
    },
    ['<leader>Sq'] = { Pst.stop, desc('Stop Persistence') },
}

Keymaps:setup({ n = Keys })

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
