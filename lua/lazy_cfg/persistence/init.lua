---@diagnostic disable:unused-function
---@diagnostic disable:unused-label

local User = require('user')
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
    options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
    dir = vim.fn.stdpath('state') .. '/sessions/', -- directory where session files are saved
    pre_save = exists('barbar') and function()
        vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePre' })
    end or nil, -- a function to call before saving the session
    post_save = nil, -- a function to call after saving the session
    save_empty = true, -- don't save if there are no open file buffers
    pre_load = nil, -- a function to call before loading the session
    post_load = nil, -- a function to call after loading the session
})

---@type table<MapModes, KeyMapDict>
local Keys = {
    n = {
        ['<leader>Sr'] = { Pst.load, desc('Restore Session') },
        ['<leader>Sd'] = { Pst.stop, desc("Don't Save Current Session") },
        ['<leader>Sl'] = {
            function()
                Pst.load({ last = true })
            end,
            desc('Restore Last Session'),
        },
    },
    v = {
        ['<leader><C-S>r'] = { Pst.load, desc('Restore Session') },
        ['<leader><C-S>d'] = { Pst.stop, desc("Don't Save Current Session") },
        ['<leader><C-S>l'] = {
            function()
                Pst.load({ last = true })
            end,
            desc('Restore Last Session'),
        },
    },
}

---@type table<MapModes, RegKeysNamed>
local Names = {
    n = { ['<leader>S'] = { name = '+Session (Persistence)' } },
    v = { ['<leader><C-S>'] = { name = '+Session (Persistence)' } },
}

if WK.available() then
    map_dict(Names, 'wk.register', true, nil, 0)
end
map_dict(Keys, 'wk.register', true, nil, 0)
