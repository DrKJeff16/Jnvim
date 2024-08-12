---@diagnostic disable:unused-function
---@diagnostic disable:unused-label

local User = require('user_api')
local Check = User.check
local WK = User.maps.wk

local exists = Check.exists.module
local is_tbl = Check.value.is_tbl
local empty = Check.value.empty
local desc = User.maps.kmap.desc
local map_dict = User.maps.map_dict

if not exists('persistence') then
    return
end

local expand = vim.fn.expand
local stdpath = vim.fn.stdpath

local Pst = require('persistence')

Pst.setup({
    dir = vim.fn.stdpath('state') .. '/sessions/', -- directory where session files are saved
    -- minimum number of file buffers that need to be open to save
    -- Set to 0 to always save
    need = 1,
    branch = true, -- use git branch to save session
})

---@type table<MapModes, KeyMapDict>
local Keys = {
    ['<leader>Sr'] = { Pst.load, desc('Restore Session') },
    ['<leader>Sd'] = { Pst.stop, desc("Don't Save Current Session") },
    ['<leader>Sl'] = {
        function() Pst.load({ last = true }) end,
        desc('Restore Last Session'),
    },
    ['<leader>Sq'] = { Pst.stop, desc('Stop Persistence') },
}

---@type table<MapModes, RegKeysNamed>
local Names = {
    ['<leader>S'] = { group = '+Session (Persistence)' },
}

if WK.available() then
    map_dict(Names, 'wk.register', false, 'n', 0)
end
map_dict(Keys, 'wk.register', false, 'n', 0)

--- vim:ts=4:sts=4:sw=4:et:ai:si:sta:noci:nopi:
